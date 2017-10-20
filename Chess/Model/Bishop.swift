//
//  Bishop.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Bishop: ChessPiece {
    
    convenience init(frame: CGRect, color: ChessPiece.Side) {
        self.init(frame: frame)
        if color == .white {
            image = UIImage(named: "bishop_white")
        } else {
            image = UIImage(named: "bishop_black")
        }
        title = PiecesType.Bishop
        self.side = color
        imageView.image = image
    }
    
    
    func getPossibleBishopMoves() -> [BoardNotation]? {
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
                if checkValidSquare(index: moveRight) {
                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
                }
                if checkValidSquare(index: moveLeft) {
                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
                }
            }
            
            if checkValidSquare(index: moveDown) {
                if checkValidSquare(index: moveRight) {
                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
                }
                if checkValidSquare(index: moveLeft) {
                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
                }
            }
            
        }
        // Capture opponent pieces
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
    
}
