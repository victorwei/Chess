//
//  Knight.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Knight: Pieces {
    
    convenience init(frame: CGRect, color: Pieces.Side) {
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
    
    
    

    
    func getPossibleKnightMoves() -> [(Int, Int)]? {
        guard let square = self.square else {
            return nil
        }
        let arrayNotation = square.boardNotation.returnArrayNotation()
        
        var height = arrayNotation.0
        var row = arrayNotation.1
        
        var possibleMoves = [(Int, Int)]()
        
        
        for index in (1...2) {
            let sideAction = index == 1 ? 2 : 1
            
            let moveHeight = height - index
            let moveRow = row - sideAction
            let moveHeight2 = height + index
            let moveRow2 = row + sideAction
            
            if checkValidSquare(index: moveHeight) {
                if checkValidSquare(index: moveRow) {
                    possibleMoves.append((moveHeight, moveRow))
                }
                if checkValidSquare(index: moveRow2) {
                    possibleMoves.append((moveHeight, moveRow2))
                }
            }
            
            if checkValidSquare(index: moveHeight2) {
                if checkValidSquare(index: moveRow) {
                    possibleMoves.append((moveHeight2, moveRow))
                }
                if checkValidSquare(index: moveRow2) {
                    possibleMoves.append((moveHeight2, moveRow2))
                }
            }
        }
        
        
        self.possibleMoves = possibleMoves
        return possibleMoves
    }
}
