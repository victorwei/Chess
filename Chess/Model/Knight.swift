//
//  Knight.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Knight: ChessPiece {
    
    convenience init(frame: CGRect, color: ChessPiece.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "knight_white")
            imageView.image = image
            
        } else {
            image = UIImage(named: "knight_black")
            imageView.image = image
        }
        self.title = PiecesType.Knight
        self.side = color
        imageView.image = image
    }
    
    
    

    
    func getAllPossibleKnightMoves(chessboard: [[Square]]) {
        guard let square = self.square else {
            return
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
    }
}
