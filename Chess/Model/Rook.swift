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
        imageView.image = image
    }
}
