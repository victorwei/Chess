//
//  Queen.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Queen: ChessPiece {
 
    convenience init(frame: CGRect, color: ChessPiece.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "queen_white")
        } else {
            image = UIImage(named: "queen_black")
        }
        
        self.title = PiecesType.Queen
        self.side = color
        imageView.image = image
    }
    
    func getAllPossibleQueenMoves(chessboard: [[Square]]) -> [BoardNotation]? {
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
}
