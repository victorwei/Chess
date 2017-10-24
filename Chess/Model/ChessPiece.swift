//
//  Pieces.swift
//  Chess
//
//  Created by Victor Wei on 10/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit



class ChessPiece: UIView {
    
    enum Side {
        case white, black
    }

    var image: UIImage!
    var title: PiecesType!
    var square: Square!
    var imageView: UIImageView!
    var possibleMoves: [BoardNotation]?
    var side: Side!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToSquare(square: Square) {
        
        self.square.removePieces()
        self.square = square
        UIView.animate(withDuration: 1.0, animations: {
            self.frame = self.square.frame
        }, completion: nil)
        
    }
    
    func setColor(side: Side) {
        self.side = side
    }
    
    func getColor()-> Side {
        return side
    }
    
    
    func checkValidSquare(index: Int)-> Bool {
        return (0...7).contains(index)
    }
    
    
    // Helper function to check if a chessboard square has a chess piece and determine whether it is the same side as the current chess piece
    // Used to help determine what moves are available for the chessPiece
    func checkSquareForChesspieceAndColor(square: Square)-> (Bool, Bool) {
        if let chesspiece = square.chessPiece {
            if chesspiece.getColor() == self.getColor() {
                return (true, true)
            }
            return(true, false)
        }
        return (false, false)
    }
    
}
