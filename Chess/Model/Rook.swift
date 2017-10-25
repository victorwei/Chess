//
//  Rook.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit


class Rook: ChessPiece {
    
    convenience init(frame: CGRect, color: ChessPiece.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "rook_white")
        } else {
            image = UIImage(named: "rook_black")
        }
        title = PiecesType.Rook
        self.side = color
        imageView.image = image
    }
    
    func getAllPossibleRookMoves(chessboard: [[Square]]) {
        guard let square = self.square else {
            return
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
                    if chessPieceOnSquare.getColor() == self.getColor() {
                        continue
                    }
                }
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
            }
            
            // moving right
            if checkValidSquare(index: moveRight) && canMoveRight {
                let potentialSquare = chessboard[height][moveRight]
                if let chessPieceOnSquare = potentialSquare.chessPiece {
                    canMoveRight = false
                    if chessPieceOnSquare.getColor() == self.getColor() {
                        continue
                    }
                }
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
            }
            
            // moving left
            if checkValidSquare(index: moveLeft) && canMoveLeft {
                let potentialSquare = chessboard[height][moveLeft]
                if let chessPieceOnSquare = potentialSquare.chessPiece {
                    canMoveLeft = false
                    if chessPieceOnSquare.getColor() == self.getColor() {
                        continue
                    }
                }
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
            }
        }
        
        self.possibleMoves = possibleMoves
    }
    
}
