//
//  Bishop.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Bishop: Pieces {
    
    convenience init(frame: CGRect, color: Pieces.Side) {
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
    
    
    func getPossibleBishopMoves() -> [(Int, Int)]? {
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
                if checkValidSquare(index: moveRight) {
                    possibleMoves.append((moveUp, moveRight))
                }
                if checkValidSquare(index: moveLeft) {
                    possibleMoves.append((moveUp, moveLeft))
                }
            }
            
            if checkValidSquare(index: moveDown) {
                if checkValidSquare(index: moveRight) {
                    possibleMoves.append((moveDown, moveRight))
                }
                if checkValidSquare(index: moveLeft) {
                    possibleMoves.append((moveDown, moveLeft))
                }
            }
            
        }
        // Capture opponent pieces
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
    
}
