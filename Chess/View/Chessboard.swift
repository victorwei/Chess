//
//  Chessboard.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Chessboard: UIView {
    
    
    var originFrame = CGRect.zero
    var boardFrame: CGRect?
    var horizontalPadding: CGFloat = 15.0
    var availableWidth: CGFloat!
    var board: [[Square]] = []
    var chessboardView: UIView!
    var tappableViews = [UIView]()
    var selectedChessPiece: ChessPiece?
    
    var rowNotation: [UILabel] = []
    var heightNotation: [UILabel] = []
    
    var whiteChessPieces: [ChessPiece] = []
    var blackChessPieces: [ChessPiece] = []
    
    
    var whiteTurn: Bool = true
    
    
    func setup(viewController: UIViewController) {
        drawBoard(view: viewController.view)
        setupPiecesForNewGame()
        setupTappableAreas()
        setupBoardNotation()
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
        chessboardView.layer.borderColor = UIColor.red.cgColor
        chessboardView.layer.borderWidth = 2.0
        self.addSubview(chessboardView)
        view.addSubview(self)
        addSquares(chessboardView: chessboardView)
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
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.white : UIColor.brown
                } else {
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.brown  : UIColor.white
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
            let label = UILabel(frame: CGRect(x: 4,
                                              y: boardYPos + (CGFloat(index) * squareSize) + (squareSize / 2.2),
                                              width: 20.0,
                                              height: 20.0))
            label.text = String(8 - index)
            self.addSubview(label)
            heightNotation.append(label)
            
            
            
            // Row Notation
            let rowLabel = UILabel(frame: CGRect(x: chessboardView.frame.minX +
                (CGFloat(index) * squareSize) + (squareSize / 2.2),
                                                 y: chessboardView.frame.maxY + 4,
                                                 width: 20.0,
                                                 height: 20.0))
            if let rowUnicodeScalar = UnicodeScalar(97 + (index)) {
                rowLabel.text = String(Character(rowUnicodeScalar))
                self.addSubview(rowLabel)
                rowNotation.append(rowLabel)
            }
            
        }
        
        
    }
    
    private func addPiece(square: Square, type: PiecesType, color: ChessPiece.Side) {
        
        var chessPiece: ChessPiece!
        switch type {
        case .Rook:
            chessPiece = Rook(frame: square.frame, color: color)
        case .King:
            chessPiece = King(frame: square.frame, color: color)
        case .Queen:
            chessPiece = Queen(frame: square.frame, color: color)
        case .Bishop:
            chessPiece = Bishop(frame: square.frame, color: color)
        case .Knight:
            chessPiece = Knight(frame: square.frame, color: color)
        case .Pawn:
            chessPiece = Pawn(frame: square.frame, color: color)
        }
        square.chessPiece = chessPiece
        chessPiece.square = square
        
        if color == .black {
            self.blackChessPieces.append(chessPiece)
        } else {
            self.whiteChessPieces.append(chessPiece)
        }
        
        chessboardView.addSubview(chessPiece)
    }
    
    

}




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
            
            // User case if user selects the chess square where the selected chess piece should go.
            if verifyValidSquareToGoTo(squares: possibleMovesChessPieceCanGo, selectedSquare: index) {
                selectedChessPiece.moveToSquare(square: selectedBoardSquare, completion: {
                    print(selectedChessPiece.title)
                    print(selectedBoardSquare.boardNotation.returnBoardNotation())
                    self.clearHighlightedSquares()
                    self.selectedChessPiece = nil
                    
                    self.swapSides()
                })
                
            }
            return
        }
        
        // if there is a piece on the square
        if let chessPiece = selectedBoardSquare.chessPiece {
            selectedChessPiece = chessPiece
            selectedBoardSquare.highlighted = true
            highlightPossibleMovesForSelectedPiece()
        }
    }
    
    
    // Helper function to switch black and white sides after each "turn".
    // Swap half of the board with another in order to 'invert' the view.
    private func swapSides() {
        
        // Only need to swap half the board.
        for height1 in 0..<(board.count / 2) {
            for row1 in 0..<board[height1].count {
                
                let square1 = board[height1][row1]
                let square2 = board[7 - height1][7 - row1]
                swapSquares(square1: square1, square2: square2)            }
        }
        
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
    
    
    
    func highlightPossibleMovesForSelectedPiece() {
        
        guard let chessPiece = selectedChessPiece,
            let chessPieceType = chessPiece.title else {
            return
        }
        
        switch chessPieceType {
            
        case .Bishop:
            let bishop = chessPiece as! Bishop
            bishop.getAllPossibleBishopMoves(chessboard: board)
            if let moves = bishop.possibleMoves {
                highlightPossibleSquares(boardSquares: moves)
            }

        case .Knight:
            let knight = chessPiece as! Knight
            knight.getAllPossibleKnightMoves(chessboard: board)
            if let moves = knight.possibleMoves {
                highlightPossibleSquares(boardSquares: moves)
            }

        case .Rook:
            let rook = chessPiece as! Rook
            rook.getAllPossibleRookMoves(chessboard: board)
            if let moves = rook.possibleMoves {
                highlightPossibleSquares(boardSquares: moves)
            }
            
        case .King:
            let king = chessPiece as! King
            king.getAllPossibleKingMoves(chessboard: board)
            if let moves = king.possibleMoves {
                highlightPossibleSquares(boardSquares: moves)
            }

        case .Queen:
            let queen = chessPiece as! Queen
            queen.getAllPossibleQueenMoves(chessboard: board)
            if let moves = queen.possibleMoves {
                highlightPossibleSquares(boardSquares: moves)
            }
            
        case .Pawn:
            let pawn = chessPiece as! Pawn
            pawn.getAllPossiblePawnMoves(chessboard: board)
            if let moves = pawn.possibleMoves {
                highlightPossibleSquares(boardSquares: moves)
            }
        }
    }
    
    private func highlightPossibleSquares(boardSquares: [BoardNotation]) {
        for square in boardSquares {
            let arrayIndex = square.returnArrayNotation()
            board[arrayIndex.0][arrayIndex.1].highlighted = true
        }
    }
    
//    private func getValidPawnMoves(possibleMoves: [BoardNotation], pawn: Pawn )-> [BoardNotation] {
//        let currentSquareNotation = pawn.square.boardNotation.returnArrayNotation()
//        return possibleMoves.filter({ (boardNotation) -> Bool in
//            let arrayIndex = boardNotation.returnArrayNotation()
//            let possibleSquare = self.board[arrayIndex.0][arrayIndex.1]
//            guard let chesspieceOnSquare = possibleSquare.chessPiece else {
//                return true
//            }
//
//            if currentSquareNotation.1 == arrayIndex.1 {
//                return pawn.side == chesspieceOnSquare.getColor()
//            } else {
//                return pawn.side != chesspieceOnSquare.getColor()
//            }
//        })
//    }
    
    
//    private func getValidPossibleMoves(possibleMoves: [BoardNotation], color: ChessPiece.Side)-> [BoardNotation] {
//
//        return possibleMoves.filter({ (boardNotation) -> Bool in
//            let arrayIndex = boardNotation.returnArrayNotation()
//            let possibleSquare = self.board[arrayIndex.0][arrayIndex.1]
//            guard let chesspieceOnSquare = possibleSquare.chessPiece else {
//                return true
//            }
//            return color != chesspieceOnSquare.getColor()
//        })
//    }
}
