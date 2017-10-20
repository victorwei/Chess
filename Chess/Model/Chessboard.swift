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
    var selectedChessPiece: Pieces?
    
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
    // Set up board datasource 
    private func addSquares(chessboardView: UIView) {
        
        let squareWidth: CGFloat = availableWidth / 8.0
        
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
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.white : UIColor.green
                } else {
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.green  : UIColor.white
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
            let label = UILabel(frame: CGRect(x: 4,
                                              y: boardYPos + (CGFloat(index) * squareSize) + (squareSize / 2.2),
                                              width: 20.0,
                                              height: 20.0))
            label.text = String(8 - index)
            self.addSubview(label)
            
            let rowLabel = UILabel(frame: CGRect(x: chessboardView.frame.minX +
                (CGFloat(index) * squareSize) + (squareSize / 2.2),
                                                 y: chessboardView.frame.maxY + 4,
                                                 width: 20.0,
                                                 height: 20.0))
            if let rowUnicodeScalar = UnicodeScalar(97 + (index)) {
                rowLabel.text = String(Character(rowUnicodeScalar))
                self.addSubview(rowLabel)
            }
            
        }
        
        
    }
    
    private func addPiece(square: Square, type: PiecesType, color: Pieces.Side) {
        var chessPiece: Pieces!
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
        chessboardView.addSubview(chessPiece)
    }
    
    
    

}

extension Chessboard {
    func selectSquare(index: Int) {
        
        let arraxIndex = getArrayIndexFromTag(tag: index)
        var selectedBoardSquare = board[arraxIndex.0][arraxIndex.1]
        
        // If this is part 2 of a move
        
        if let selectedChessPiece = selectedChessPiece {
    
            selectedBoardSquare.chessPiece = selectedChessPiece
            selectedChessPiece.moveToSquare(square: selectedBoardSquare)
            
            self.selectedChessPiece = nil
            clearHighlightedSquares()
            
            return
        }
        
        
        
        // if there is a piece on the square
        if let chessPiece = selectedBoardSquare.chessPiece {
            selectedChessPiece = chessPiece
            selectedBoardSquare.highlighted = true
            getPossibleMoves()
        }
        
        
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
    
    
    
    func getPossibleMoves()-> [Square.Type]? {
        
        guard let chessPiece = selectedChessPiece,
            let chessPieceType = chessPiece.title else {
            return nil
        }
        
        switch chessPieceType {
            
        case .Bishop:
            let bishop = chessPiece as! Bishop
            if var moves = bishop.getPossibleBishopMoves() {
                
                moves = getValidPossibleMoves(possibleMoves: moves, color: chessPiece.getColor())
                bishop.possibleMoves = moves
                
                for move in moves {
                    board[move.0][move.1].highlighted = true
                }
            }
        case .Knight:
            let knight = chessPiece as! Knight
            if var moves = knight.getPossibleKnightMoves() {
                
                moves = getValidPossibleMoves(possibleMoves: moves, color: chessPiece.getColor())
                knight.possibleMoves = moves
                
                for move in moves {
                    board[move.0][move.1].highlighted = true
                }
            }
        case .Rook:
            let rook = chessPiece as! Rook
            if var moves = rook.getPossibleRookMoves() {
                
                moves = getValidPossibleMoves(possibleMoves: moves, color: chessPiece.getColor())
                rook.possibleMoves = moves
                
                for move in moves {
                    board[move.0][move.1].highlighted = true
                }
            }
        case .King:
            let king = chessPiece as! King
            if var moves = king.getPossibleKingMoves() {
                
                moves = getValidPossibleMoves(possibleMoves: moves, color: chessPiece.getColor())
                king.possibleMoves = moves
                
                for move in moves {
                    board[move.0][move.1].highlighted = true
                }
            }
        case .Queen:
            let queen = chessPiece as! Queen
            if var moves = queen.getPossibleQueenMoves() {
                
                moves = getValidPossibleMoves(possibleMoves: moves, color: chessPiece.getColor())
                queen.possibleMoves = moves
                
                for move in moves {
                    board[move.0][move.1].highlighted = true
                }
            }
        case .Pawn:
            let pawn = chessPiece as! Pawn
            if var moves = pawn.getPossiblePawnMoves() {
                moves = getValidPossibleMoves(possibleMoves: moves, color: chessPiece.getColor())
                pawn.possibleMoves = moves
                for move in moves {
                    board[move.0][move.1].highlighted = true
                }
            }
            
        }
        
        return nil
    }
    
    private func getValidPossibleMoves(possibleMoves: [(Int, Int)], color: Pieces.Side)-> [(Int, Int)] {
        
        return possibleMoves.filter({ (arrayIndex) -> Bool in
            let possibleSquare = self.board[arrayIndex.0][arrayIndex.1]
            guard let chesspieceOnSquare = possibleSquare.chessPiece else {
                return true
            }
            return color != chesspieceOnSquare.getColor()
        })
    }
    
    
    
    
    
    
}
