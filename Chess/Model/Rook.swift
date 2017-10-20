//
//  Rook.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit


class Rook: Pieces {
    
    convenience init(frame: CGRect, color: Pieces.Side) {
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
    
    func getPossibleRookMoves() -> [(Int, Int)]? {
        guard let square = self.square else {
            return nil
        }
        let arrayNotation = square.boardNotation.returnArrayNotation()
        
        var height = arrayNotation.0
        var row = arrayNotation.1
        
        var possibleMoves = [(Int, Int)]()
        
        for index in (1...7) {
            let moveUp = height - index
            let moveDown = height + index
            let moveRight = row + index
            let moveLeft = row - index
            
            if checkValidSquare(index: moveUp) {
                possibleMoves.append((moveUp, row))
            }
            
            if checkValidSquare(index: moveDown) {
                possibleMoves.append((moveDown, row))
            }
            
            if checkValidSquare(index: moveRight) {
                possibleMoves.append((height, moveRight))
            }
            if checkValidSquare(index: moveLeft) {
                possibleMoves.append((height, moveLeft))
            }
        }
        
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
}
