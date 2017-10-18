//
//  Pawn.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Pawn: Pieces {
    
    convenience init(frame: CGRect, color: Pieces.Side) {
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
    
    
    func getPossiblePawnMoves() -> [(Int, Int)]? {
        guard let square = self.square else {
            return nil
        }
        let arrayNotation = square.boardNotation.returnArrayNotation()
        
        var height = arrayNotation.0
        var row = arrayNotation.1
        
        var possibleMoves = [(Int, Int)]()
        
        // Go either one or two steps forward
        for index in (1...2) {
            let possibleHeight = height - index
            if (possibleHeight > 0) || (height > 7) {
                possibleMoves.append((possibleHeight, row))
            }
        }
        
        // Capture opponent pieces
        
        
        return possibleMoves
    }
}
