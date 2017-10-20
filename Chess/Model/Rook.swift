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
    
    func getPossibleRookMoves() -> [BoardNotation]? {
        guard let square = self.square else {
            return nil
        }
        let arrayNotation = square.boardNotation.returnArrayNotation()
        
        var height = arrayNotation.0
        var row = arrayNotation.1
        
        var possibleMoves = [BoardNotation]()
        
        for index in (1...7) {
            let moveUp = height - index
            let moveDown = height + index
            let moveRight = row + index
            let moveLeft = row - index
            
            if checkValidSquare(index: moveUp) {
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveUp)!, height: row))
            }
            
            if checkValidSquare(index: moveDown) {
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveDown)!, height: row))
            }
            
            if checkValidSquare(index: moveRight) {
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: height)!, height: moveRight))
            }
            if checkValidSquare(index: moveLeft) {
                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: height)!, height: moveLeft))
            }
        }
        
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
}
