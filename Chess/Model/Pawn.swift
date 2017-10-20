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
    
    
    func getPossiblePawnMoves() -> [BoardNotation]? {
        guard let square = self.square else {
            return nil
        }
        let arrayNotation = square.boardNotation.returnArrayNotation()
        
        var height = arrayNotation.0
        var row = arrayNotation.1
        
        var possibleMoves = [BoardNotation]()
        var moveRight = row + 1
        var moveLeft = row - 1
        var moveUp = height - 1
        var moveUp2 = height - 2
        // Go either one or two steps forward
        if height == 6 {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp2))
        }
        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
        if checkValidSquare(index: moveRight) {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
        }
        if checkValidSquare(index: moveLeft) {
            possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
        }
        
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
}
