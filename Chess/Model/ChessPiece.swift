//
//  Pieces.swift
//  Chess
//
//  Created by Victor Wei on 10/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

enum PiecesType: String {
  case King = "king"
  case Queen = "queen"
  case Bishop = "bishop"
  case Knight = "knight"
  case Pawn = "pawn"
  case Rook = "rook"
  
}


class ChessPiece: UIView {
  
  enum Side {
    case white, black
  }
  
  var image: UIImage!
  var type: PiecesType
  var square: Square?
  var imageView: UIImageView!
  var possibleMoves: [BoardNotation]?
  var side: Side
  var hasMoved: Bool = false
  
  
  var selected: Bool = false {
    didSet {
      switch selected {
      case true:
        switch type {
        case .Pawn:
          image = side == .white ? UIImage(named: "wp") : UIImage(named: "bp")
        case .King:
          image = side == .white ? UIImage(named: "wk") : UIImage(named: "bk")
        case .Queen:
          image = side == .white ? UIImage(named: "wq") : UIImage(named: "bq")
        case .Bishop:
          image = side == .white ? UIImage(named: "wb") : UIImage(named: "bb")
        case .Knight:
          image = side == .white ? UIImage(named: "wn") : UIImage(named: "bn")
        case .Rook:
          image = side == .white ? UIImage(named: "wr") : UIImage(named: "br")
        }
      case false:
        switch type {
        case .Pawn:
          image = side == .white ? UIImage(named: "wp") : UIImage(named: "bp")
        case .King:
          image = side == .white ? UIImage(named: "wk") : UIImage(named: "bk")
        case .Queen:
          image = side == .white ? UIImage(named: "wq") : UIImage(named: "bq")
        case .Bishop:
          image = side == .white ? UIImage(named: "wb") : UIImage(named: "bb")
        case .Knight:
          image = side == .white ? UIImage(named: "wn") : UIImage(named: "bn")
        case .Rook:
          image = side == .white ? UIImage(named: "wr") : UIImage(named: "br")
        }
      }
      imageView.image = image
    }
  }
  
  
  init(frame: CGRect, color: ChessPiece.Side, type: PiecesType, square: Square?) {
    self.type = type
    self.side = color
    self.square = square
    super.init(frame: frame)
    
    
    switch type {
    case .Pawn:
      image = color == .white ? UIImage(named: "wp") : UIImage(named: "bp")
    case .King:
      image = color == .white ? UIImage(named: "wk") : UIImage(named: "bk")
    case .Queen:
      image = color == .white ? UIImage(named: "wq") : UIImage(named: "bq")
    case .Bishop:
      image = color == .white ? UIImage(named: "wb") : UIImage(named: "bb")
    case .Knight:
      image = color == .white ? UIImage(named: "wn") : UIImage(named: "bn")
    case .Rook:
      image = color == .white ? UIImage(named: "wr") : UIImage(named: "br")
    }
    
    imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    self.addSubview(imageView)
    imageView.image = image
  }
  
  
  convenience init(frame: CGRect, color: ChessPiece.Side, type: PiecesType, square: Square?, hasMoved: Bool) {
    self.init(frame: frame, color: color, type: type, square: square)
    self.hasMoved = hasMoved
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) h.as not been implemented")
  }
  

  
  
  // Function for moving a piece to a certain square
  // When a piece moves, the original square no longer holds a chess piece anymore
  //  the new square should hold a new chesspiece object
  // If the square has a chessPiece on it, that piece should disappear
  func moveToSquare(square: Square, completion: @escaping (_ capture: Bool)-> ()) {
    if self.square == nil {
      return
    }
    self.square?.removePieces()
    if let oldPiece = square.chessPiece {
      UIView.animate(withDuration: 1.0, animations: {
        self.frame = square.frame
        oldPiece.alpha = 0
      }, completion: { (finished) in
        if finished {
//          oldPiece.removeFromSuperview()
          oldPiece.square = nil
          completion(true)
        }
      })
    } else {
      UIView.animate(withDuration: 1.0, animations: {
        self.frame = square.frame
      }, completion: { (finished) in
        completion(false)
      })
    }
    
    self.selected = false
    square.chessPiece = self
    self.square = square
    self.hasMoved = true
    
  }
  
  func getColor()-> Side {
    return side
  }
  
  // Helper function to make sure the index we are accessing is within the board indexes
  func checkValidSquare(index: Int)-> Bool {
    return (0...7).contains(index)
  }
  
  
  // Helper function to check if a chessboard square has a chess piece and determine whether it is the same side as the current chess piece
  // Used to help determine what moves are available for the chessPiece
  func checkSquareForChesspieceAndColor(square: Square)-> (Bool, Bool) {
    if let chesspiece = square.chessPiece {
      if chesspiece.getColor() == self.getColor() {
        return (true, true)
      }
      return(true, false)
    }
    return (false, false)
  }
  
  

  
  
  
  
  func changePieceType(type: PiecesType) {
    
    switch type {
      
    case .Pawn:
      image = getColor() == .white ? UIImage(named: "wp") : UIImage(named: "bp")
    case .King:
      image = getColor() == .white ? UIImage(named: "wk") : UIImage(named: "bk")
    case .Queen:
      image = getColor() == .white ? UIImage(named: "wq") : UIImage(named: "bq")
    case .Bishop:
      image = getColor() == .white ? UIImage(named: "wb") : UIImage(named: "bb")
    case .Knight:
      image = getColor() == .white ? UIImage(named: "wn") : UIImage(named: "bn")
    case .Rook:
      image = getColor() == .white ? UIImage(named: "wr") : UIImage(named: "br")
    }
    imageView.image = image
    self.type = type
    
  }
  
  
  
  func getAllPossibleMoves(chessboard: [[Square]])-> [BoardNotation]? {
    
    switch self.type {
    case .Pawn:
      return getAllPossiblePawnMoves(chessboard: chessboard)
    case .King:
      return getAllPossibleKingMoves(chessboard: chessboard)
    case .Queen:
      return getAllPossibleQueenMoves(chessboard: chessboard)
    case .Bishop:
      return getAllPossibleBishopMoves(chessboard: chessboard)
    case .Knight:
      return getAllPossibleKnightMoves(chessboard: chessboard)
    case .Rook:
      return getAllPossibleRookMoves(chessboard: chessboard)
    }
  }
  
  
  func getAllPossibleOpponentMoves(chessboard: [[Square]])-> [BoardNotation]? {
    
    switch self.type {
    case .Pawn:
      return getAllPossibleOpponentPawnMoves(chessboard: chessboard)
    case .King:
      return getAllPossibleKingMoves(chessboard: chessboard)
    case .Queen:
      return getAllPossibleQueenMoves(chessboard: chessboard)
    case .Bishop:
      return getAllPossibleBishopMoves(chessboard: chessboard)
    case .Knight:
      return getAllPossibleKnightMoves(chessboard: chessboard)
    case .Rook:
      return getAllPossibleRookMoves(chessboard: chessboard)
    }
  }
  
  
  
  
}

// MARK: - Possible Moves for each type of piece
extension ChessPiece {
  
  // Helper function - return array of BoardNotation that a King can travel to
  private func getAllPossibleKingMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var possibleMoves = [BoardNotation]()
    
    let moveUp = height - 1
    let moveDown = height + 1
    let moveRight = row + 1
    let moveLeft = row - 1
    
    // TODO: - check if castle is available
    switch self.side {
    case .black:
      break
      
    case .white:
      break
    }
    
    
    if checkValidSquare(index: moveUp) {
      if checkValidSquare(index: moveRight){
        let potentialSquare = chessboard[moveUp][moveRight]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
        }
      }
      if checkValidSquare(index: moveLeft){
        let potentialSquare = chessboard[moveUp][moveLeft]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
        }
      }
      
      let potentialSquare = chessboard[moveUp][row]
      if let chessPieceOnSquare = potentialSquare.chessPiece {
        if chessPieceOnSquare.getColor() != self.getColor() {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
        }
      } else {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
      }
      
    }
    
    //Check squares that queen can move in the Down direction
    if checkValidSquare(index: moveDown) {
      if checkValidSquare(index: moveRight) {
        let potentialSquare = chessboard[moveDown][moveRight]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
        }
      }
      
      if checkValidSquare(index: moveLeft) {
        let potentialSquare = chessboard[moveDown][moveLeft]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
        }
      }
      
      let potentialSquare = chessboard[moveDown][row]
      if let chessPieceOnSquare = potentialSquare.chessPiece {
        if chessPieceOnSquare.getColor() != self.getColor() {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
        }
      } else {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
      }
    }
    
    //Check squares that queen can move to the right
    if checkValidSquare(index: moveRight) {
      let potentialSquare = chessboard[height][moveRight]
      if let chessPieceOnSquare = potentialSquare.chessPiece {
        if chessPieceOnSquare.getColor() != self.getColor() {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
        }
      } else {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
      }
    }
    
    //Check squares that queen can move to the left
    if checkValidSquare(index: moveLeft) {
      let potentialSquare = chessboard[height][moveLeft]
      if let chessPieceOnSquare = potentialSquare.chessPiece {
        if chessPieceOnSquare.getColor() != self.getColor() {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
        }
      } else {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
      }
    }
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  
  
  // Helper function - return array of BoardNotation that a Bishop can travel to
  private func getAllPossibleBishopMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var canMoveUpRight = true
    var canMoveUpLeft = true
    var canMoveDownRight = true
    var canMoveDownLeft = true
    
    var possibleMoves = [BoardNotation]()
    
    for index in (1...7) {
      let moveUp = height - index
      let moveDown = height + index
      let moveRight = row + index
      let moveLeft = row - index
      
      if checkValidSquare(index: moveUp) {
        if checkValidSquare(index: moveRight) && canMoveUpRight{
          let potentialSquare = chessboard[moveUp][moveRight]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveUpRight = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
          }
          
        }
        if checkValidSquare(index: moveLeft) && canMoveUpLeft {
          let potentialSquare = chessboard[moveUp][moveLeft]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveUpLeft = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
          }
        }
      }
      
      if checkValidSquare(index: moveDown) {
        
        if checkValidSquare(index: moveRight) && canMoveDownRight {
          let potentialSquare = chessboard[moveDown][moveRight]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveDownRight = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
          }
        }
        
        if checkValidSquare(index: moveLeft) && canMoveDownLeft{
          let potentialSquare = chessboard[moveDown][moveLeft]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveDownLeft = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
          }
        }
      }
      
    }
    // Capture opponent pieces
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  // Helper function - return array of BoardNotation that a Knight can travel to
  private func getAllPossibleKnightMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var possibleMoves = [BoardNotation]()
    
    
    for index in (1...2) {
      let sideAction = index == 1 ? 2 : 1
      
      let moveHeight = height - index
      let moveRow = row - sideAction
      let moveHeight2 = height + index
      let moveRow2 = row + sideAction
      
      if checkValidSquare(index: moveHeight) {
        if checkValidSquare(index: moveRow) {
          let potentialSquare = chessboard[moveHeight][moveRow]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow)!, height: moveHeight))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow)!, height: moveHeight))
          }
        }
        if checkValidSquare(index: moveRow2) {
          let potentialSquare = chessboard[moveHeight][moveRow2]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow2)!, height: moveHeight))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow2)!, height: moveHeight))
          }
        }
      }
      
      if checkValidSquare(index: moveHeight2) {
        if checkValidSquare(index: moveRow) {
          let potentialSquare = chessboard[moveHeight2][moveRow]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow)!, height: moveHeight2))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow)!, height: moveHeight2))
          }
        }
        if checkValidSquare(index: moveRow2) {
          let potentialSquare = chessboard[moveHeight2][moveRow2]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow2)!, height: moveHeight2))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRow2)!, height: moveHeight2))
          }
        }
      }
    }
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  
  // Helper function - return array of BoardNotation that a Pawn can travel to
  private func getAllPossiblePawnMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var possibleMoves = [BoardNotation]()
    let moveRight = row + 1
    let moveLeft = row - 1
    let moveUp = height - 1
    let moveUp2 = height - 2
    
    
    
    //check going up 1 step
    let potentialSquare = chessboard[moveUp][row]
    if !potentialSquare.checkIfPieceIsThere {
      possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
      
      // Go up two steps forward
      if height == 6 {
        let potentialSquare = chessboard[moveUp2][row]
        if !potentialSquare.checkIfPieceIsThere {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp2))
        }
      }
    }
    
    //check to see if there is a piece to capture on the right
    if checkValidSquare(index: moveRight) {
      let potentialSquare = chessboard[moveUp][moveRight]
      if let chesspiece = potentialSquare.chessPiece,
        chesspiece.getColor() != self.getColor() {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
      }
    }
    if checkValidSquare(index: moveLeft) {
      let potentialSquare = chessboard[moveUp][moveLeft]
      if let chesspiece = potentialSquare.chessPiece,
        chesspiece.getColor() != self.getColor() {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
      }
      
    }
    
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  
  // Helper function - return array of BoardNotation that a Pawn can travel to
  private func getAllPossibleOpponentPawnMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var possibleMoves = [BoardNotation]()
    let moveRight = row + 1
    let moveLeft = row - 1
    let moveUp = height + 1
    let moveUp2 = height + 2
    
    //check going up 1 step
    let potentialSquare = chessboard[moveUp][row]
    if !potentialSquare.checkIfPieceIsThere {
      possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
      
      // Go up two steps forward
      if height == 1 {
        let potentialSquare = chessboard[moveUp2][row]
        if !potentialSquare.checkIfPieceIsThere {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp2))
        }
      }
    }
    
    
    //check to see if there is a piece to capture on the right
    if checkValidSquare(index: moveRight) {
      let potentialSquare = chessboard[moveUp][moveRight]
      if let chesspiece = potentialSquare.chessPiece,
        chesspiece.getColor() != self.getColor() {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
      }
    }
    if checkValidSquare(index: moveLeft) {
      let potentialSquare = chessboard[moveUp][moveLeft]
      if let chesspiece = potentialSquare.chessPiece,
        chesspiece.getColor() != self.getColor() {
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
      }
      
    }
    
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  
  // Helper function - return array of BoardNotation that a Queen can travel to
  private func getAllPossibleQueenMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var possibleMoves = [BoardNotation]()
    
    var canMoveUp = true
    var canMoveUpRight = true
    var canMoveUpLeft = true
    var canMoveRight = true
    var canMoveLeft = true
    var canMoveDown = true
    var canMoveDownRight = true
    var canMoveDownLeft = true
    
    
    for index in (1...7) {
      let moveUp = height - index
      let moveDown = height + index
      let moveRight = row + index
      let moveLeft = row - index
      
      //Check squares that queen can move in the Up direction
      if checkValidSquare(index: moveUp) {
        if checkValidSquare(index: moveRight) && canMoveUpRight{
          let potentialSquare = chessboard[moveUp][moveRight]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveUpRight = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
          }
        }
        if checkValidSquare(index: moveLeft) && canMoveUpLeft {
          let potentialSquare = chessboard[moveUp][moveLeft]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveUpLeft = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
          }
        }
        if canMoveUp {
          let potentialSquare = chessboard[moveUp][row]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveUp = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
          }
        }
      }
      
      //Check squares that queen can move in the Down direction
      if checkValidSquare(index: moveDown) {
        if checkValidSquare(index: moveRight) && canMoveDownRight{
          let potentialSquare = chessboard[moveDown][moveRight]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveDownRight = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
          }
        }
        
        if checkValidSquare(index: moveLeft) && canMoveDownLeft {
          let potentialSquare = chessboard[moveDown][moveLeft]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveDownLeft = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
          }
        }
        if canMoveDown {
          let potentialSquare = chessboard[moveDown][row]
          if let chessPieceOnSquare = potentialSquare.chessPiece {
            canMoveDown = false
            if chessPieceOnSquare.getColor() != self.getColor() {
              possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
            }
          } else {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
          }
        }
      }
      
      //Check squares that queen can move to the right
      if checkValidSquare(index: moveRight) && canMoveRight {
        let potentialSquare = chessboard[height][moveRight]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          canMoveRight = false
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
        }
      }
      
      //Check squares that queen can move to the left
      if checkValidSquare(index: moveLeft) && canMoveLeft {
        let potentialSquare = chessboard[height][moveLeft]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          canMoveLeft = false
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
        }
      }
    }
    
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  // Helper function - return array of BoardNotation that a Rook can travel to
  func getAllPossibleRookMoves(chessboard: [[Square]])-> [BoardNotation]? {
    guard let square = self.square else {
      return nil
    }
    let arrayNotation = square.boardNotation.returnArrayNotation()
    
    let height = arrayNotation.0
    let row = arrayNotation.1
    
    var possibleMoves = [BoardNotation]()
    
    var canMoveUp = true
    var canMoveDown = true
    var canMoveRight = true
    var canMoveLeft = true
    
    for index in (1...7) {
      let moveUp = height - index
      let moveDown = height + index
      let moveRight = row + index
      let moveLeft = row - index
      
      // moving up
      if checkValidSquare(index: moveUp) && canMoveUp {
        let potentialSquare = chessboard[moveUp][row]
        
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          canMoveUp = false
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
        }
        
      }
      
      // moving down
      if checkValidSquare(index: moveDown) && canMoveDown {
        let potentialSquare = chessboard[moveDown][row]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          canMoveDown = false
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
        }
        
      }
      
      // moving right
      if checkValidSquare(index: moveRight) && canMoveRight {
        let potentialSquare = chessboard[height][moveRight]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          canMoveRight = false
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
        }
        
      }
      
      // moving left
      if checkValidSquare(index: moveLeft) && canMoveLeft {
        let potentialSquare = chessboard[height][moveLeft]
        if let chessPieceOnSquare = potentialSquare.chessPiece {
          canMoveLeft = false
          if chessPieceOnSquare.getColor() != self.getColor() {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
          }
        } else {
          possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
        }
        
      }
    }
    
    self.possibleMoves = possibleMoves
    return possibleMoves
  }
  
  
  
  
}
