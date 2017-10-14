//
//  Pieces.swift
//  Chess
//
//  Created by Victor Wei on 10/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit



class Pieces: NSObject {
    
    enum Side {
        case white, black
    }

    var image: UIImage!
    var title: PiecesType!
    private var side: Side!
    
    
    func setColor(side: Side) {
        self.side = side
    }
    
    func getColor()-> Side {
        return side
    }
}
