//
//  Square.swift
//  Chess
//
//  Created by Victor Wei on 10/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit


enum PiecesType {
    case King, Queen, Bishop, Knight, Pawn, Rook
}

class Square: UIView {
    
    var imageView: UIImageView?
    
    var chessPiece: Pieces? {
        didSet {
            setupImageView()
            
            if let image = chessPiece?.image {
                self.imageView?.image = image
//                self.layer.backgroundColor = UIColor.red.cgColor
                
            }
            
        }
    }
    
    var checkIfPieceIsThere: Bool {
        return chessPiece != nil
    }
    
    
    
    func setupImageView() {
        imageView = UIImageView()
        guard let imageView = imageView else {
            return
        }
        self.addSubview(imageView)
        let widthLayout = NSLayoutConstraint(item: imageView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .width ,
                                             multiplier:  0.9,
                                             constant: 0)
        let heightLayout = NSLayoutConstraint(item: imageView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .height,
                                             multiplier: 0.9,
                                             constant: 0)
        let xCenterLayout = NSLayoutConstraint(item: imageView,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerX,
                                               multiplier: 1.0,
                                               constant: 1.0)
        let YCenterLayout = NSLayoutConstraint(item: imageView,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerY,
                                               multiplier: 1.0,
                                               constant: 1.0)
        NSLayoutConstraint.activate([widthLayout, heightLayout, xCenterLayout, YCenterLayout])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    
    
    
    
    func removePieces() {
        chessPiece = nil
    }
    
    func addPiece(type: PiecesType, color: Pieces.Side) {
        
        switch type {
            
        case .Rook:
            chessPiece = Rook(color: color)
            
        case .King:
            chessPiece = King(color: color)
        case .Queen:
            chessPiece = Queen(color: color)
        case .Bishop:
            chessPiece = Bishop(color: color)
        case .Knight:
            chessPiece = Knight(color: color)
        case .Pawn:
            chessPiece = Pawn(color: color)
            
        }
    }
    
    
}
