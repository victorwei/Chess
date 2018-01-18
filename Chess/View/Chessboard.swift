//
//  Chessboard.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Chessboard: UIView {
  
  var horizontalPadding: CGFloat = 15.0
  var availableWidth: CGFloat!
  var board: [[Square]] = []
  var chessboardView: UIView!
  var boardBorderView: UIView!
  var tappableViews = [UIView]()
  var selectedChessPiece: ChessPiece?
  
  var rowNotation: [UILabel] = []
  var heightNotation: [UILabel] = []
  
  var whiteKing: ChessPiece!
  var blackKing: ChessPiece!
  var whiteChessPieces: [ChessPiece] = []
  var blackChessPieces: [ChessPiece] = []
  var canEnPassant: [ChessPiece] = []
  var enPassantableSquare: Square?
  var enPassantablePawn: ChessPiece?
  var promotePawn: ChessPiece?
  
  var temporaryChessPiece: ChessPiece?
  var gameNotation: [String] = []
  
  weak var delegate: ChessboardDelegate!
  
  var castleAvailable: Bool {
    get {
      let castles = isCastleAvailable()
      return castles.0 || castles.1
    }
  }
  var whiteTurn: Bool = true
  
  
  public func setupForGame(viewController: UIViewController, newGame: Bool, whitesTurn: Bool) {
    drawBoard(view: viewController.view)
    setupBoardNotation()
    
    if !newGame {
      self.whiteTurn = whitesTurn
      loadPreviousGame()
      if !whitesTurn {
        swapBoardNotation()
      }
    } else {
      setupPiecesForNewGame()
    }
    
    setupTappableAreas()
    
    
//    let backgroundImage = UIImageView(frame: self.frame)
//    backgroundImage.image = #imageLiteral(resourceName: "game_bg")
//    self.insertSubview(backgroundImage, at: 0)
    self.backgroundColor = UIColor.lightGray
    
    Settings.shared.addObserver(self, forKeyPath: #keyPath(Settings.boardColor), options: [.old, .new], context: nil)
  }
  
  
  public
  
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(Settings.boardColor) {
      self.updateBoardColor()
    }
  }
  
  
  //MARK: - Deinitialization
  
  deinit {
    Settings.shared.removeObserver(self, forKeyPath: #keyPath(Settings.boardColor))
  }
  
  // MARK: SETUP Functions
  
  // Function to create the main chessboard view
  private func drawBoard(view: UIView) {
    
    self.frame = view.frame
    
    //original view dimensions
    let width = view.frame.width
    let height = view.frame.height
    
    // get 8x8 frame with 15 frame
    availableWidth = width - (2 * horizontalPadding)
    
    chessboardView = UIView(frame: CGRect(x: horizontalPadding,
                                          y: view.frame.height / 2 - availableWidth / 2,
                                          width: availableWidth,
                                          height: availableWidth))
    chessboardView.backgroundColor = UIColor.lightGray
    chessboardView.layer.borderColor = UIColor.black.cgColor
    chessboardView.layer.borderWidth = 1.5

    boardBorderView = UIView(frame: CGRect(x: 0.0,
                                         y: (view.frame.height / 2 - availableWidth / 2) - 22,
                                         width: view.frame.width,
                                         height: availableWidth + 44))
    boardBorderView.backgroundColor = Settings.shared.boardColor
    boardBorderView.layer.borderColor = UIColor.black.cgColor
    boardBorderView.layer.borderWidth = 1.0
    self.addSubview(boardBorderView)
    
    
    self.addSubview(chessboardView)
    view.addSubview(self)
    addSquares(chessboardView: chessboardView)
    
    
  }
  
  func setGradientBackground() {
    let topColor = UIColor(red: 170.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
    let bottomColor = UIColor(red: 100.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [ topColor, bottomColor]
    gradientLayer.locations = [ 0.0, 2.0]
    gradientLayer.frame = self.bounds
    
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  // Helper function to add checkerboard squares
  // Set up board datasource.
  private func addSquares(chessboardView: UIView) {
    
    for index in (0..<8) {
      var row = [Square]()
      for index2 in (0..<8) {
        
        let boardSquareWidth = chessboardView.frame.width / 8
        let boardCGPoint = CGPoint(x: (boardSquareWidth * CGFloat(index2)),
                                   y: (boardSquareWidth * CGFloat(index)))
        let boardSize = CGSize(width: boardSquareWidth, height: boardSquareWidth)
        let rect = CGRect(origin: boardCGPoint, size: boardSize)
        
        let newSquareView = Square(frame: rect, arrayIndex: (index, index2))
        
        chessboardView.addSubview(newSquareView)
        
        if index2 % 2 == 0 {
          newSquareView.backgroundColor = index % 2 == 0 ? UIColor.white : Settings.shared.boardColor
        } else {
          newSquareView.backgroundColor = index % 2 == 0 ? Settings.shared.boardColor  : UIColor.white
        }
        row.append(newSquareView)
      }
      board.append(row)
    }
  }
  
  
  private func setupTappableAreas () {
    
    board.flatMap{$0}.forEach { (square) in
      
      let tappableView = UIView(frame: square.frame)
      chessboardView.addSubview(tappableView)
      square.interactableView = tappableView
      let arrayNotation = square.boardNotation.returnTapArrayIndex()
      tappableView.tag = arrayNotation
      
    }
  }
  
  
  
  // Function to set pieces object at each square
  private func setupPiecesForNewGame() {
    
    for height in (0..<board.count) {
      for row in (0..<board[height].count) {
        let boardSquare = board[height][row]
        if height == (board.count - 1) || height == 0 {
          switch row {
          case 0, 7:
            
            if height == 0 {
              addPiece(square: boardSquare, type: .Rook, color: .black)
            } else {
              addPiece(square: boardSquare, type: .Rook, color: .white)
            }
          case 1, 6:
            if height == 0 {
              addPiece(square: boardSquare, type: .Knight, color: .black)
            } else {
              addPiece(square: boardSquare, type: .Knight, color: .white)
            }
          case 2, 5:
            if height == 0 {
              addPiece(square: boardSquare, type: .Bishop, color: .black)
            } else {
              addPiece(square: boardSquare, type: .Bishop, color: .white)
            }
          case 3:
            if height == 0 {
              addPiece(square: boardSquare, type: .Queen, color: .black)
            } else {
              addPiece(square: boardSquare, type: .Queen, color: .white)
            }
          case 4:
            if height == 0 {
              addPiece(square: boardSquare, type: .King, color: .black)
            } else {
              addPiece(square: boardSquare, type: .King, color: .white)
            }
          default:
            break
          }
        } else if height == 1 || height == (board.count - 2) {
          if height == 1 {
            addPiece(square: boardSquare, type: .Pawn, color: .black)
          } else {
            addPiece(square: boardSquare, type: .Pawn, color: .white)
          }
        }
        
      }
    }
  }
  
  private func setupBoardNotation() {
    let squareSize = availableWidth / 8
    let boardYPos = chessboardView.frame.minY
    for index in (0..<8) {
      
      // Height Notation
      let label = UILabel(frame: CGRect(x: 0,
                                        y: boardYPos + (CGFloat(index) * squareSize),
                                        width: horizontalPadding,
                                        height: squareSize))
      label.textAlignment = .center
      label.text = String(8 - index)
      self.addSubview(label)
      heightNotation.append(label)
      
      let label2 = UILabel(frame: CGRect(x: chessboardView.frame.maxX,
                                         y: boardYPos + (CGFloat(index) * squareSize),
                                         width: horizontalPadding,
                                         height: squareSize))
      label2.textAlignment = .center
      label2.text = String(8 - index)
      self.addSubview(label2)
      heightNotation.append(label2)
      
      
      
      // Row Notation
      let rowLabel = UILabel(frame: CGRect(x: chessboardView.frame.minX +
        (CGFloat(index) * squareSize),
                                           y: chessboardView.frame.maxY,
                                           width: squareSize,
                                           height: 20.0))
      rowLabel.textAlignment = .center
      if let rowUnicodeScalar = UnicodeScalar(97 + (index)) {
        rowLabel.text = String(Character(rowUnicodeScalar))
        self.addSubview(rowLabel)
        rowNotation.append(rowLabel)
      }
      
      
      // Row Notation
      let rowLabel2 = UILabel(frame: CGRect(x: chessboardView.frame.minX +
        (CGFloat(index) * squareSize),
                                            y: chessboardView.frame.minY - 20,
                                            width: squareSize,
                                            height: 20.0))
      rowLabel2.textAlignment = .center
      if let rowUnicodeScalar = UnicodeScalar(97 + (index)) {
        rowLabel2.text = String(Character(rowUnicodeScalar))
        self.addSubview(rowLabel2)
        rowNotation.append(rowLabel2)
        
      }
    }
    if !whiteTurn && !isBoardSetForWhitesTurn() {
      swapBoardNotation()
    }
  }
  
  
  private func addPiece(square: Square, type: PiecesType, color: ChessPiece.Side) {
   
    let chessPiece = ChessPiece(frame: square.frame, color: color, type: type, square: square)
    square.chessPiece = chessPiece
    
    if color == .black {
      self.blackChessPieces.append(chessPiece)
      if type == .King {
        blackKing = chessPiece
      }
    } else {
      self.whiteChessPieces.append(chessPiece)
      if type == .King {
        whiteKing = chessPiece
      }
    }
    
    chessboardView.addSubview(chessPiece)
  }
  
  
  // Change the board color of chessboard
  private func updateBoardColor() {
    if board.count == 0 {
      return
    }
    for index in (0..<8) {
      for index2 in (0..<8) {
        
        if index2 % 2 != 0 && index % 2 == 0{
          board[index][index2].backgroundColor = Settings.shared.boardColor
        } else if index2 % 2 == 0 && index % 2 != 0 {
          board[index][index2].backgroundColor = Settings.shared.boardColor
        }
      }
    }
    boardBorderView.backgroundColor = Settings.shared.boardColor
  }
  
  
  
   func resetGame() {
    
    resetBoard()
    resetGameState()
  }
  
  private func resetGameState() {
    whiteTurn = true
    gameNotation.removeAll()
    self.clearHighlightedSquares()
    self.selectedChessPiece = nil
    canEnPassant.removeAll()
    
    if !isBoardSetForWhitesTurn() {
      swapBoardNotation()
    }
  }
  
  private func resetBoard() {
    
    for height in (0..<board.count) {
      for row in (0..<board[height].count) {
        
        let boardSquare = board[height][row]

        if height == (board.count - 1) || height == 0 {

          DispatchQueue.global(qos: .userInitiated).async {
            let piece: ChessPiece = (height == 0) ? self.blackChessPieces[row] : self.whiteChessPieces[row + 8]
            piece.square = boardSquare
            boardSquare.chessPiece = piece
            
            DispatchQueue.main.async {
              piece.alpha = 1.0
              piece.moveToSquare(square: boardSquare, completion: { (captured) in
                piece.hasMoved = false
              })
            }
          }

        } else if height == 1 || height == (board.count - 2) {

          DispatchQueue.global(qos: .userInitiated).async {
            let piece: ChessPiece = height == 1 ? self.blackChessPieces[row + 8] : self.whiteChessPieces[row]
            piece.square = boardSquare
            boardSquare.chessPiece = piece
            if piece.type != .Pawn {
              piece.changePieceType(type: .Pawn)
            }

            DispatchQueue.main.async {
              piece.alpha = 1.0
              piece.moveToSquare(square: boardSquare, completion: { (captured) in
              })
            }
          }
        } else {
          boardSquare.chessPiece = nil
        }
      }
    } // end of 1st forloop
  }
  
}

// MARK: - CoreData Methods
// Functions to save and load game data

extension Chessboard {
  
  public func saveCurrentState() {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    for piece in (whiteChessPieces + blackChessPieces) {
      
      guard let entity = NSEntityDescription.entity(forEntityName: "ManagedChessPiece", in: managedContext) else { return }
      
      let managedChessPieceObject = NSManagedObject(entity: entity, insertInto: managedContext)
      
      setChessPieceAsManagedObject(chessPiece: piece, managedObject: managedChessPieceObject)

      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
  }
  
  private func setChessPieceAsManagedObject(chessPiece: ChessPiece, managedObject: NSManagedObject){
    
    let whiteSide: Bool = chessPiece.side == .white ? true : false
    managedObject.setValue(whiteSide, forKey: CoreDataPieceKeys.whiteSide)
    
    let pieceType = chessPiece.type.rawValue
    managedObject.setValue(pieceType, forKey: CoreDataPieceKeys.type)
    
    managedObject.setValue(chessPiece.hasMoved, forKey: CoreDataPieceKeys.pieceHasMoved)
    
    let pieceFrame = NSValue.init(cgRect: chessPiece.frame)
    managedObject.setValue(pieceFrame, forKey: CoreDataPieceKeys.chessPieceFrame)
    
    let squareCoordinate = chessPiece.square?.boardNotation.returnArrayNotation()
    managedObject.setValue(squareCoordinate?.0, forKey: CoreDataPieceKeys.squareColumn)
    managedObject.setValue(squareCoordinate?.1, forKey: CoreDataPieceKeys.squareRow)
  }
  
  
  public func loadPreviousGame() {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataPieceKeys.entity)
    
    do {
      let managedObjects = try managedContext.fetch(fetchRequest)
      convertManagedObjectToChessPiece(objects: managedObjects)
      
      // Delete old record so we don't have duplicates later
      for managedObject in managedObjects {
        managedContext.delete(managedObject)
      }
      try managedContext.save()
      
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    
    loadPreviousNotation()
    
  }
  
  private func loadPreviousNotation() {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataGameNotation.entity)
    
    do {
      let managedObjects = try managedContext.fetch(fetchRequest)
      
      let oldGameNotation = managedObjects[0].value(forKey: CoreDataGameNotation.gameNotation) as! [String]
      self.gameNotation = oldGameNotation
      for managedObject in managedObjects {
        managedContext.delete(managedObject)
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    
  }
  
  
  
  private func convertManagedObjectToChessPiece(objects: [NSManagedObject]) {
    
    for object in objects {
      
      let type = object.value(forKey: CoreDataPieceKeys.type) as! String
      let pieceType: PiecesType = PiecesType(rawValue: type)!
      
      
      let whiteSide = object.value(forKey: CoreDataPieceKeys.whiteSide) as! Bool
      let color = whiteSide ? ChessPiece.Side.white : ChessPiece.Side.black
      
      let hasMoved = object.value(forKey: CoreDataPieceKeys.pieceHasMoved) as! Bool
      let frameValue = object.value(forKey: CoreDataPieceKeys.chessPieceFrame) as! NSValue
      let pieceFrame = frameValue.cgRectValue
      let squareColumn = object.value(forKey: CoreDataPieceKeys.squareColumn) as? Int
      let squareRow = object.value(forKey: CoreDataPieceKeys.squareRow) as? Int
      
      
      // Add the piece to the board.  if there is no row/column, that means the piece was captured already.
      // Add the piece to the correct square if there is row/column values
      // If piece doesn't have row/clumn value, Add piece to the board but keep it hidden
      
      addPieceFromPreviousGame(row: squareRow, column: squareColumn, type: pieceType, color: color, hasMoved: hasMoved)
      
    }
    
  }
  
  private func addPieceFromPreviousGame(row: Int?, column: Int?, type: PiecesType, color: ChessPiece.Side, hasMoved: Bool) {
    
    var chessPiece: ChessPiece!
    
    if let row = row,
      let column = column {
      
      let square = board[column][row]
      chessPiece = ChessPiece(frame: square.frame, color: color, type: type, square: square, hasMoved: hasMoved)
      square.chessPiece = chessPiece
      
    } else {
      chessPiece = ChessPiece(frame: board[0][0].frame , color: color, type: type, square: nil, hasMoved: hasMoved)
    }
    
    
    if color == .black {
      self.blackChessPieces.append(chessPiece)
      if type == .King {
        blackKing = chessPiece
      }
    } else {
      self.whiteChessPieces.append(chessPiece)
      if type == .King {
        whiteKing = chessPiece
      }
    }
    
    if row == nil {
      chessPiece.alpha = 0
    }
    
    chessboardView.addSubview(chessPiece)
    
  }
    
  
  
  private func addPieceFromPreviousGame1(square: Square?, type: PiecesType, color: ChessPiece.Side, hasMoved: Bool) {
    
    
    guard let square = square else { return }
    
    let chessPiece = ChessPiece(frame: square.frame, color: color, type: type, square: square, hasMoved: hasMoved)
    square.chessPiece = chessPiece
    
    if color == .black {
      self.blackChessPieces.append(chessPiece)
      if type == .King {
        blackKing = chessPiece
      }
    } else {
      self.whiteChessPieces.append(chessPiece)
      if type == .King {
        whiteKing = chessPiece
      }
    }

    chessboardView.addSubview(chessPiece)
  }
  
  
  
  
  
  public func saveGame() {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

    let managedContext = appDelegate.persistentContainer.viewContext

    guard let entity = NSEntityDescription.entity(forEntityName: CoreDataGameKeys.entity, in: managedContext) else { return }

    let managedGameObject = NSManagedObject(entity: entity, insertInto: managedContext)

    managedGameObject.setValue(whiteTurn, forKey: CoreDataGameKeys.whiteTurn)
    managedGameObject.setValue(true, forKey: CoreDataGameKeys.resumeGame)

    do {
      try managedContext.save()
      saveCurrentState()
      saveGameNotation()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  
  private func saveGameNotation() {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    guard let entity = NSEntityDescription.entity(forEntityName: CoreDataGameNotation.entity, in: managedContext) else { return }
    
    let managedNotationObject = NSManagedObject(entity: entity, insertInto: managedContext)
    
    managedNotationObject.setValue(gameNotation, forKey: CoreDataGameNotation.gameNotation)
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    
    
  }
  
  
}






// MARK: - Methods for handling user interaction
extension Chessboard {
  
  // Function used when user selects a chess square
  func selectSquare(index: Int) {
    
    let arrayIndex = getArrayIndexFromTag(tag: index)
    let selectedBoardSquare = board[arrayIndex.1][arrayIndex.0]
    
    
    
    // If this is part 2 of a move (user has already selected a chesspiece to move)
    // There are 2 options - if user selects the chess piece again, or if user selects the square where he wants the chessPiece to move to
    if let selectedChessPiece = selectedChessPiece,
      let possibleMovesChessPieceCanGo = selectedChessPiece.possibleMoves {
      
      // Use case if user selects the same square as before. We want to remove any highlighted squares and remove the current chess piece selection
      if selectedChessPiece.square?.boardNotation.returnTapArrayIndex() == index {
        self.selectedChessPiece = nil
        clearHighlightedSquares()
        return
      }
      
      // Castle functions
      if selectedChessPiece.type == .King && castleAvailable {
        let isCastlePossible = isCastleAvailable()
        
        if isCastlePossible.0 {
          let kingSideSquareNotation = getKingSideCastleHighlightSquare()
          if selectedBoardSquare.boardNotation.returnArrayNotation() == kingSideSquareNotation.returnArrayNotation() {
            // perform King Side Castle
            performKingSideCastle {
              self.gameNotation.append("0-0")
              print("0-0")
              self.finishMoveAndUpdateBoard()
            }
          }
        } else if isCastlePossible.1 {
          let queenSideSquareNotation = getQueenSideCastleHighlightSquare()
          if selectedBoardSquare.boardNotation.returnArrayNotation() == queenSideSquareNotation.returnArrayNotation() {
            // perform Queen Side Castle
            performQueenSideCastle {
              self.gameNotation.append("0-0-0")
              print("0-0-0")
              self.finishMoveAndUpdateBoard()
            }
          }
        }
        return
      }
      
      
      // Check to see if EnPassant was selected
      if let enPassanteSquare = enPassantableSquare,
        selectedBoardSquare == enPassanteSquare,
        canEnPassant.contains(selectedChessPiece) {
        
        let originalSquare = selectedChessPiece.square!
        simulateMoveForCheck(chessPiece: selectedChessPiece, to: selectedBoardSquare)
        if checkIfInCheck() {
          undoSimulateMoveForCheck(chessPiece: selectedChessPiece, to: originalSquare)
          selectedBoardSquare.flashErrorView()
          print("can't move you in check!")
          return
        }
        undoSimulateMoveForCheck(chessPiece: selectedChessPiece, to: originalSquare)
        
        if let capturedPawn = enPassantablePawn {
          capturedPawn.square?.chessPiece = nil
          capturedPawn.square = nil
          UIView.animate(withDuration: 0.5) {
            capturedPawn.alpha = 0
          }
          
          selectedChessPiece.moveToSquare(square: enPassanteSquare) { captured in
            
            let originalPawnRowNotation = originalSquare.boardNotation.returnBoardNotation(whitesTurn: self.whiteTurn).first!
            let enPasssantSquareNotation = enPassanteSquare.boardNotation.returnBoardNotation(whitesTurn: self.whiteTurn)
            
            let chessNotation = String(originalPawnRowNotation) + enPasssantSquareNotation
            
            self.gameNotation.append(chessNotation)
            print(chessNotation)
            
            self.removeEnPassantableProperties()
            self.finishMoveAndUpdateBoard()
            return
          }
        }
      } else {
        self.removeEnPassantableProperties()
      }
      
      
      
      // Use case if user selects the chess square where the selected chess piece should go.
      if verifyValidSquareToGoTo(squares: possibleMovesChessPieceCanGo, selectedSquare: index) {
        
        let side: ChessPiece.Side = whiteTurn ? .white : .black
        
        // Get the original square that the selected Chess piece currently resides in so we have a reference to move the piece back if needed
        let originalSquare = selectedChessPiece.square!
        
        
        simulateMoveForCheck(chessPiece: selectedChessPiece, to: selectedBoardSquare)
        
        if checkIfInCheck() {
          undoSimulateMoveForCheck(chessPiece: selectedChessPiece, to: originalSquare)
          selectedBoardSquare.flashErrorView()
          print("can't move you in check!")
          
          return
        }
        
        undoSimulateMoveForCheck(chessPiece: selectedChessPiece, to: originalSquare)
        
        // Check to see if En Passant is available.  Triggered only when a pawn moves from its starting location 2 squares up.
        // Triggers checks for the next turn
        checkIfEnPassantWillBeAvailable(selectedSquare: selectedBoardSquare)
        
        //Make a check for pawn to see if it capturing another piece
        let currentRowForSelectedPiece = selectedChessPiece.square?.boardNotation.returnBoardNotation(whitesTurn: whiteTurn)
        
        clearHighlightedSquares()
        highlightPossibleSquares(boardSquares: [selectedBoardSquare.boardNotation])
        selectedChessPiece.moveToSquare(square: selectedBoardSquare, completion: { [weak self] captured in
          
          // Check if pawn reached the end of the square
          if selectedChessPiece.type == .Pawn && selectedBoardSquare.boardNotation.returnArrayNotation().0 == 0 {
            self?.promotePawn = selectedChessPiece
            self?.delegate.showChooseNewPieceAlert(whiteTurn: (self?.whiteTurn)!)
            //            selectedChessPiece.changePieceType(type: PiecesType.Queen)
            return
          }
          
          // Used for getting game notation
          var chessNotation = ""
          if selectedChessPiece.type == .Pawn && captured {
            let pawnRow = currentRowForSelectedPiece?.first
            chessNotation = (self?.getChessNotationForMove(chessPiece: selectedChessPiece, boardSquare: selectedBoardSquare.boardNotation, pawnSquare: String(describing: pawnRow!)))!
          } else {
            chessNotation = (self?.getChessNotationForMove(chessPiece: selectedChessPiece, boardSquare: selectedBoardSquare.boardNotation, pawnSquare: nil))!
          }
          print(chessNotation)
          self?.gameNotation.append(chessNotation)
          
          self?.finishMoveAndUpdateBoard()
        })
      } else {
        
        // if there is a piece on the square
        if let chessPiece = selectedBoardSquare.chessPiece {
          
          if (whiteTurn && blackChessPieces.contains(chessPiece)) ||
            (!whiteTurn && whiteChessPieces.contains(chessPiece)) {
            return
          }
          
          clearHighlightedSquares()
          self.selectedChessPiece = chessPiece
          selectedBoardSquare.highlighted = true
          highlightPossibleMovesForSelectedPiece()
          
          
          // Check if castle is available.  Called only if the chessPiece selected is a king
          if chessPiece.type == .King {
            let isCastlePossible = isCastleAvailable()
            let possibleCastleMoves = getCastleSquares(kingCastle: isCastlePossible.0, queenCastle: isCastlePossible.1)
            highlightPossibleSquares(boardSquares: possibleCastleMoves)
          }
          
          // Check if EnPassant is available
          if canEnPassant.contains(chessPiece),
            let highlightedSquare = enPassantableSquare {
            let highlightBoardNotation = [highlightedSquare.boardNotation!]
            highlightPossibleSquares(boardSquares: highlightBoardNotation)
          }
        } else {
          self.selectedChessPiece = nil
          clearHighlightedSquares()
        }
        
      }
      return
    }
    
    // if there is a piece on the square
    if let chessPiece = selectedBoardSquare.chessPiece {
      
      if (whiteTurn && blackChessPieces.contains(chessPiece)) ||
        (!whiteTurn && whiteChessPieces.contains(chessPiece)) {
        return
      }
      
      chessPiece.selected = true
      selectedChessPiece = chessPiece
      selectedBoardSquare.highlighted = true
      highlightPossibleMovesForSelectedPiece()
      
      
      // Check if castle is available.  Called only if the chessPiece selected is a king
      if chessPiece.type == .King {
        let isCastlePossible = isCastleAvailable()
        let possibleCastleMoves = getCastleSquares(kingCastle: isCastlePossible.0, queenCastle: isCastlePossible.1)
        highlightPossibleSquares(boardSquares: possibleCastleMoves)
      }
      
      // Check if EnPassant is available
      if canEnPassant.contains(chessPiece),
        let highlightedSquare = enPassantableSquare {
        let highlightBoardNotation = [highlightedSquare.boardNotation!]
        highlightPossibleSquares(boardSquares: highlightBoardNotation)
      }
    }
  }
  
  // Helper function used after player moves a chess piece
  private func finishMoveAndUpdateBoard() {
    
    self.clearHighlightedSquares()
    if checkIfCheckmate() {
      delegate.showCheckMateAlert(whiteWins: whiteTurn)
      print("CHECKMATE")
      return
    }
    
    self.selectedChessPiece = nil
    self.swapSides()
  }
  
  
  // Function to determine if there is a checkmate.
  // Iterate through all of the pieces to see if other side is in check.  If so, iterate through all the other pieces on the other side to see if any move will prevent check.
  private func checkIfCheckmate()-> Bool {
    
    
    if checkIfOpponentInCheck() {
      
      var noLongerInCheck = false
      
      let chessPieces = whiteTurn ? blackChessPieces : whiteChessPieces
      for piece in chessPieces {
        if piece.square == nil {
          continue
        }
        
        if let moves = piece.getAllPossibleOpponentMoves(chessboard: board) {
          
          var originalSquare = piece.square!
          
          for move in moves {
            
            let selectedSquareNotation = move.returnArrayNotation()
            let selectedSquare = board[selectedSquareNotation.0][selectedSquareNotation.1]
            
            simulateMoveForCheck(chessPiece: piece, to: selectedSquare)
            if !checkIfOpponentInCheck() {
              noLongerInCheck = true
            }
            undoSimulateMoveForCheck(chessPiece: piece, to: originalSquare)
            
            if noLongerInCheck {
              return false
            }
          }
        }
      }
    } else {
      return false
    }
    return true
  }
  
  
  // Helper function to switch black and white sides after each "turn".
  // Swap half of the board with another in order to 'invert' the view.
  private func swapSides() {
    
    // Only need to swap half the board.
    for height1 in 0..<(board.count / 2) {
      for row1 in 0..<board[height1].count {
        
        let square1 = board[height1][row1]
        let square2 = board[7 - height1][7 - row1]
        swapSquares(square1: square1, square2: square2)
      }
    }
    whiteTurn = !whiteTurn
    swapBoardNotation()
  }
  
  
  // Helper function to swap board notation
  private func swapBoardNotation() {
    
    for index in 0..<(rowNotation.count / 2) {
      
      let opposingIndex = rowNotation.count - 1 - index
      
      let row1Text = rowNotation[index].text
      let row2Text = rowNotation[opposingIndex].text
      rowNotation[index].text = row2Text
      rowNotation[opposingIndex].text = row1Text
      
      let height1Text = heightNotation[index].text
      let height2Text = heightNotation[opposingIndex].text
      heightNotation[index].text = height2Text
      heightNotation[opposingIndex].text = height1Text
    }
  }
  
  // Determine if the board is set for White or for black.
  // Used for when resuming a game to see if board is already set to white or black.
  private func isBoardSetForWhitesTurn()-> Bool {
    return rowNotation[0].text == "a"
  }
  
  
  // Helper function to swap chess pieces on a square
  // The chesspieces should switch frames, and the squares reference to the chesspieces should be switched as well
  private func swapSquares(square1: Square, square2: Square) {
    
    if square1.chessPiece == nil && square2.chessPiece == nil {
      return
    }
    
    var square10 = square1
    var square20 = square2
    
    if let square1piece = square1.chessPiece {
      square1piece.frame = square2.frame
      square1piece.square = square2
      
    }
    
    if let square2piece = square2.chessPiece {
      square2piece.frame = square1.frame
      square2piece.square = square1
    }
    
    swapSquaresPieces(square1: &square10, square2: &square20)
  }
  
  
  private func swapSquaresPieces(square1: inout Square, square2: inout Square) {
    swap(&square1.chessPiece, &square2.chessPiece)
  }
  
  
  
  // Helper function to verify the user's second selection (moving a piece to a valid square) is valid or not
  private func verifyValidSquareToGoTo(squares: [BoardNotation], selectedSquare: Int)-> Bool {
    for square in squares {
      if square.returnTapArrayIndex() == selectedSquare {
        return true
      }
    }
    return false
    
  }
  
  // Helper function to get correct array index from tag number
  private func getArrayIndexFromTag(tag: Int)-> (Int, Int) {
    
    let row = tag % 8
    let height = (tag - row) / 8
    return (row, height)
  }
  
  private func clearHighlightedSquares() {
    board.flatMap{ $0 }.forEach { (square) in
      square.highlighted = false
    }
  }
  
  // Helper function to display all possible moves for the selected piece
  private func highlightPossibleMovesForSelectedPiece() {
    
    guard let chessPiece = selectedChessPiece,
      let possibleMoves = chessPiece.getAllPossibleMoves(chessboard: board) else {
        return
    }
    
    highlightPossibleSquares(boardSquares: possibleMoves)
    
  }
  
  // Helper function to turn square highlighted var to true
  private func highlightPossibleSquares(boardSquares: [BoardNotation]) {
    
    if !Settings.shared.showMoves {
      return
    }
    
    for square in boardSquares {
      let arrayIndex = square.returnArrayNotation()
      board[arrayIndex.0][arrayIndex.1].highlighted = true
    }
  }
  
  
  // Helper function to check if current user is in check
  private func checkIfInCheck()-> Bool {
    
    // TODO: - check King's position (find out the square).  Then iterate through other side's pieces and check all of their possible moves.  If one of their moves lands on the same square, then check is confirmed
    
    let currentKing: ChessPiece = whiteTurn ? whiteKing : blackKing
    let opponentPieces: [ChessPiece] = whiteTurn ? blackChessPieces : whiteChessPieces
    
    for piece in opponentPieces {
      if let possibleMoves = piece.getAllPossibleOpponentMoves(chessboard: board) {
        for possibleMove in possibleMoves {
          if possibleMove.returnArrayNotation() ==  (currentKing.square?.boardNotation.returnArrayNotation())! {
            return true
          }
        }
      }
    }
    return false
  }
  
  
  // Helper function to check if the other sideis in check
  private func checkIfOpponentInCheck()-> Bool {
    
    // TODO: - check King's position (find out the square).  Then iterate through other side's pieces and check all of their possible moves.  If one of their moves lands on the same square, then check is confirmed
    
    let currentKing: ChessPiece = whiteTurn ? blackKing : whiteKing
    let opponentPieces: [ChessPiece] = whiteTurn ? whiteChessPieces : blackChessPieces
    
    for piece in opponentPieces {
      if let possibleMoves = piece.getAllPossibleMoves(chessboard: board){
        for possibleMove in possibleMoves {
          if possibleMove.returnArrayNotation() ==  (currentKing.square?.boardNotation.returnArrayNotation())! {
            return true
          }
        }
      }
    }
    return false
  }
  
  
  // Helper function to simulate moving a piece to a location to check for check
  private func simulateMoveForCheck(chessPiece: ChessPiece, to chessSquare: Square) {
    guard let currentSquare = chessPiece.square else {
      return
    }
    currentSquare.removePieces()
    if let chessSquareChessPiece = chessSquare.chessPiece {
      self.temporaryChessPiece = chessSquareChessPiece
      self.temporaryChessPiece?.square = nil
      chessSquare.chessPiece = chessPiece
    } else {
      chessSquare.chessPiece = chessPiece
    }
    chessPiece.square = chessSquare
  }
  
  
  private func undoSimulateMoveForCheck(chessPiece: ChessPiece, to originalSquare: Square) {
    guard let currentSquare = chessPiece.square else {
      return
    }
    
    // Set the square for the chess Piece
    chessPiece.square = originalSquare
    originalSquare.chessPiece = chessPiece
    
    // Replace temporaryChessPiece's square
    self.temporaryChessPiece?.square = currentSquare
    
    // replace chess piece on current square
    currentSquare.chessPiece = self.temporaryChessPiece
    self.temporaryChessPiece = nil
  }
  
  
  // Check if castle is available
  private func isCastleAvailable()-> (Bool, Bool) {
    return (checkIfKingSideCastleAvailable(), checkIfQueenSideCastleAvailable())
  }
  
  // Helper function to get which squares to highlight if castle is available
  // Returns an array of BoardNotation
  private func getCastleSquares(kingCastle: Bool, queenCastle: Bool)-> [BoardNotation] {
    
    var castleSquares = [BoardNotation]()
    if kingCastle {
      castleSquares.append(getKingSideCastleHighlightSquare())
    }
    if queenCastle {
      castleSquares.append(getQueenSideCastleHighlightSquare())
    }
    return castleSquares
  }
  
  private func getKingSideCastleHighlightSquare()-> BoardNotation {
    let kingSideCastleIndex = whiteTurn ? 6 : 1
    return board[7][kingSideCastleIndex].boardNotation
  }
  
  private func getQueenSideCastleHighlightSquare() -> BoardNotation {
    let queenSideCastleIndex = whiteTurn ? 2 : 5
    return board[7][queenSideCastleIndex].boardNotation
  }
  
  
  // Helper function to determine if a King side castle is available
  private func checkIfKingSideCastleAvailable() -> Bool {
    
    let king = whiteTurn ? whiteKing : blackKing
    
    if checkIfInCheck() || (king?.hasMoved)! {
      return false
    }
    
    // Set array indices based on whiteTurn
    let kingSideRookIndex = whiteTurn ? 7: 0
    let kingSideIndex = whiteTurn ? 5 : 1
    let kingSideIndex2 = whiteTurn ? 6 : 2
    
    // Check if the rook is at the correct board position, if it has moved, and if there are any pieces in the way of a castle
    guard let kingSideRook = board[7][kingSideRookIndex].chessPiece,
      !kingSideRook.hasMoved,
      !board[7][kingSideIndex].checkIfPieceIsThere,
      !board[7][kingSideIndex2].checkIfPieceIsThere,
      kingSideRook.type == .Rook else {
        return false
    }
    
    // Get the squares to check if a king will castle through check
    let kingSideCastleSquares = [ board[7][kingSideIndex].boardNotation.returnArrayNotation(),
                                  board[7][kingSideIndex2].boardNotation.returnArrayNotation()]
    
    // Go through each of the opponent pieces and see if they will cause a check if the king castles
    let opponentPieces = whiteTurn ? blackChessPieces : whiteChessPieces
    for piece in opponentPieces {
      if let possibleMoves = piece.getAllPossibleOpponentMoves(chessboard: board) {
        for possibleMove in possibleMoves {
          if kingSideCastleSquares.contains(where: { (arrayNotation) -> Bool in
            return arrayNotation == possibleMove.returnArrayNotation()
          }) {
            return false
          }
        }
      }
    }
    return true
    
  }
  
  private func checkIfQueenSideCastleAvailable() -> Bool {
    
    let king = whiteTurn ? whiteKing : blackKing
    
    if checkIfInCheck() || (king?.hasMoved)! {
      return false
    }
    
    // Set array indices based on whiteTurn
    let queenSideRookIndex = whiteTurn ? 0: 7
    let queenSideIndex = whiteTurn ? 1 : 6
    let queenSideIndex2 = whiteTurn ? 2 : 5
    let queenSideIndex3 = whiteTurn ? 3: 4
    
    // Check if the rook is at the correct board position, if it has moved, and if there are any pieces in the way of a castle
    guard let queenSideRook = board[7][queenSideRookIndex].chessPiece,
      !queenSideRook.hasMoved,
      !board[7][queenSideIndex].checkIfPieceIsThere,
      !board[7][queenSideIndex2].checkIfPieceIsThere,
      !board[7][queenSideIndex3].checkIfPieceIsThere,
      queenSideRook.type == .Rook else {
        return false
    }
    
    // Get the squares to check if a king will castle through check
    let queenSideCastleSquares = [ board[7][queenSideIndex2].boardNotation.returnArrayNotation(),
                                   board[7][queenSideIndex3].boardNotation.returnArrayNotation()]
    
    // Go through each of the opponent pieces and see if they will cause a check if the king castles
    let opponentPieces = whiteTurn ? blackChessPieces : whiteChessPieces
    for piece in opponentPieces {
      if let possibleMoves = piece.getAllPossibleOpponentMoves(chessboard: board) {
        for possibleMove in possibleMoves {
          if queenSideCastleSquares.contains(where: { (arrayNotation) -> Bool in
            return arrayNotation == possibleMove.returnArrayNotation()
          }) {
            return false
          }
        }
      }
    }
    return true
  }
  
  
  // Helper function to perform King Side Castle
  private func performKingSideCastle(completion: @escaping ()-> Void) {
    
    let king: ChessPiece = whiteTurn ? whiteKing : blackKing
    let rookIndex = whiteTurn ?  7: 0
    let kingSideRook = board[7][rookIndex].chessPiece
    
    let newKingIndex = whiteTurn ? 6: 1
    let newRookIndex = whiteTurn ? 5: 2
    
    let newKingSquare = board[7][newKingIndex]
    let newRookSquare = board[7][newRookIndex]
    
    // Move King to correct position
    king.moveToSquare(square: newKingSquare) {_ in
      kingSideRook?.moveToSquare(square: newRookSquare, completion: {_ in
        completion()
      })
    }
  }
  
  
  // Helper function to perform Queen Side Castle
  private func performQueenSideCastle(completion: @escaping ()-> Void) {
    
    let king: ChessPiece = whiteTurn ? whiteKing : blackKing
    let rookIndex = whiteTurn ? 0 : 7
    let kingSideRook = board[7][rookIndex].chessPiece
    
    let newKingIndex = whiteTurn ? 2: 5
    let newRookIndex = whiteTurn ? 3: 4
    
    let newKingSquare = board[7][newKingIndex]
    let newRookSquare = board[7][newRookIndex]
    
    // Move King to correct position
    king.moveToSquare(square: newKingSquare) {_ in
      kingSideRook?.moveToSquare(square: newRookSquare, completion: {_ in
        completion()
      })
    }
  }
  
  // Helper function used to remove all properties used with En Passant
  private func removeEnPassantableProperties() {
    canEnPassant.removeAll()
    enPassantablePawn = nil
    enPassantableSquare = nil
  }
  
  // Helper function to see if there are pawns on either side of the square
  // Used in conjunction with En Passant
  private func checkIfEnPassantWillBeAvailable(selectedSquare: Square){
    guard let selectedChessPiece = selectedChessPiece,
      selectedChessPiece.type == .Pawn else {
        return
    }
    let currentPawnSquare = selectedChessPiece.square?.boardNotation.returnArrayNotation()
    
    // Check if the pawn is moving up 2 squares to avoid capture
    guard (currentPawnSquare?.0)! - selectedSquare.boardNotation.returnArrayNotation().0  == 2  else {
      return
    }
    let currentSide: ChessPiece.Side = whiteTurn ? .white : .black
    let squareArrayNotation = selectedSquare.boardNotation.returnArrayNotation()
    let squareRow = squareArrayNotation.1
    let squareHeight = squareArrayNotation.0
    
    var enPassantAvailable = false
    
    if squareRow + 1 < 8,
      let otherPawn = board[squareHeight][squareRow + 1].chessPiece,
      otherPawn.type == .Pawn,
      currentSide != otherPawn.getColor() {
      canEnPassant.append(otherPawn)
      enPassantAvailable = true
    }
    
    if squareRow - 1 >= 0,
      let otherPawn = board[squareHeight][squareRow - 1].chessPiece,
      otherPawn.type == .Pawn,
      currentSide != otherPawn.getColor() {
      canEnPassant.append(otherPawn)
      enPassantAvailable = true
    }
    
    if enPassantAvailable {
      enPassantableSquare = board[7 - (squareHeight + 1)][7 - squareRow]
      enPassantablePawn = selectedChessPiece
    }
  }
  
  // Helper function to help print the board square
  private func getChessNotationForMove(chessPiece: ChessPiece, boardSquare: BoardNotation, pawnSquare: String?)-> String {
    
    var pieceNotation = ""
    switch chessPiece.type {
    case .Pawn:
      break
    case .Knight:
      pieceNotation = "N"
    case .Bishop:
      pieceNotation = "B"
    case .Rook:
      pieceNotation = "R"
    case .Queen:
      pieceNotation = "Q"
    case .King:
      pieceNotation = "K"
    }
    let boardSquareNotation = boardSquare.returnBoardNotation(whitesTurn: whiteTurn)
    
    if let pawnSquare = pawnSquare {
      return pawnSquare + pieceNotation + boardSquareNotation
    }
    return pieceNotation + boardSquareNotation
  }
  
}



protocol ChessboardDelegate: class {
  func showCheckMateAlert(whiteWins: Bool)
  func showChooseNewPieceAlert(whiteTurn: Bool)
}
