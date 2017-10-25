//
//  Pawn.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Pawn: ChessPiece {
    
    convenience init(frame: CGRect, color: ChessPiece.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "pawn_white")
            imageView.image = image
        } else {
            image = UIImage(named: "pawn_black")
            imageView.image = image
        }
        
        self.title = PiecesType.Pawn
        self.side = color
        imageView.image = image
    }
    
    
    func getAllPossiblePawnMoves(chessboard: [[Square]]) -> [BoardNotation]? {
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
        
        // Go up two steps forward
        if height == 6 {
            let potentialSquare = chessboard[moveUp2][row]
            if !potentialSquare.checkIfPieceIsThere {
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp2))
            }
        }
        
        //check going up 1 step
        let potentialSquare = chessboard[moveUp][row]
        if !potentialSquare.checkIfPieceIsThere {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
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
            let potentialSquare = chessboard[moveUp][moveRight]
            if let chesspiece = potentialSquare.chessPiece,
                chesspiece.getColor() != self.getColor() {
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
            }
            
        }
        
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
}
