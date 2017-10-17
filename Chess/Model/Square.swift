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




struct BoardNotation {
    
    enum RowNotation: Int {
        case A = 0, B, C, D, E, F, G, H
        
        var description: String {
            switch self {
            case .A:
                return "A"
            case .B:
                return "B"
            case .C:
                return "C"
            case .D:
                return "D"
            case .E:
                return "E"
            case .F:
                return "F"
            case .G:
                return "G"
            case .H:
                return "H"
            }
        }
    }
    
    var row: RowNotation
    var height: Int
    
    func returnBoardNotation()-> (String, Int) {
        let boardHeight = height + 1
        let boardRow = row.description
        return (boardRow, boardHeight)
    }
    
    func returnArrayNotation() -> (Int, Int) {
        return (row.rawValue, height)
    }
    
    func returnTapArrayIndex() -> Int {
        return row.rawValue + (height * 8)
    }
    
}

class Square: UIView {
    
    var imageView: UIImageView?
    var boardNotation: BoardNotation!
    var tappableView: UIView!
    var highlightView: UIView!
    weak var chessPiece: Pieces? {
        didSet {
            if let image = chessPiece?.image {
                self.imageView?.image = image
            }
        }
    }
    
    
    var highlighted: Bool = false {
        didSet {
            switch highlighted {
            case true:
                highlightView.isHidden = false
            case false:
                highlightView.isHidden = true
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, arrayIndex: (Int, Int)) {
        
        self.init(frame: frame)
        setNotation(row: arrayIndex.0, height: arrayIndex.1)
//        setupImageView()
        setupHighlightView()
        setTappableView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var checkIfPieceIsThere: Bool {
        return chessPiece != nil
    }
    
    
    private func setTappableView() {
        tappableView = UIView()
        self.addSubview(tappableView)
        
        let widthLayout = NSLayoutConstraint(item: tappableView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .width ,
                                             multiplier:  1.0,
                                             constant: 0)
        let heightLayout = NSLayoutConstraint(item: tappableView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .height,
                                              multiplier: 1.0,
                                              constant: 0)
        let xCenterLayout = NSLayoutConstraint(item: tappableView,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerX,
                                               multiplier: 1.0,
                                               constant: 1.0)
        let YCenterLayout = NSLayoutConstraint(item: tappableView,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerY,
                                               multiplier: 1.0,
                                               constant: 1.0)
        NSLayoutConstraint.activate([widthLayout, heightLayout, xCenterLayout, YCenterLayout])
        tappableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setNotation(row: Int, height: Int) {
        
        if let rowNotation = BoardNotation.RowNotation(rawValue: row) {
            boardNotation = BoardNotation(row: rowNotation, height: height)
        }
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
    
    func setupHighlightView() {
        highlightView = UIView()
        highlightView.backgroundColor = UIColor.yellow
        highlightView.alpha = 0.5
        highlightView.isHidden = true
        self.addSubview(highlightView)
        
        let widthLayout = NSLayoutConstraint(item: highlightView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .width ,
                                             multiplier:  1.0,
                                             constant: 0)
        let heightLayout = NSLayoutConstraint(item: highlightView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .height,
                                              multiplier: 1.0,
                                              constant: 0)
        let xCenterLayout = NSLayoutConstraint(item: highlightView,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerX,
                                               multiplier: 1.0,
                                               constant: 1.0)
        let YCenterLayout = NSLayoutConstraint(item: highlightView,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .centerY,
                                               multiplier: 1.0,
                                               constant: 1.0)
        NSLayoutConstraint.activate([widthLayout, heightLayout, xCenterLayout, YCenterLayout])
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    
    
    func removePieces() {
        chessPiece = nil
    }
    
    func addPiece(type: PiecesType, color: Pieces.Side) {
        
        switch type {
            
        case .Rook:
            chessPiece = Rook(frame: self.frame, color: color)
            
        case .King:
            chessPiece = King(frame: self.frame, color: color)
        case .Queen:
            chessPiece = Queen(frame: self.frame, color: color)
        case .Bishop:
            chessPiece = Bishop(frame: self.frame, color: color)
        case .Knight:
            chessPiece = Knight(frame: self.frame, color: color)
        case .Pawn:
            chessPiece = Pawn(frame: self.frame, color: color)
            
        }
    }
    
    
}
