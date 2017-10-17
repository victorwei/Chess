//
//  Pieces.swift
//  Chess
//
//  Created by Victor Wei on 10/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit



class Pieces: UIView {
    
    enum Side {
        case white, black
    }

    var image: UIImage!
    var title: PiecesType!
    var square: Square!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private var side: Side!
    func setColor(side: Side) {
        self.side = side
    }
    
    func getColor()-> Side {
        return side
    }
    
    
}
