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
    
    
    
    // Function for moving a piece to a certain square
    // When a piece moves, the original square no longer holds a chess piece anymore
    //  the new square should hold a new chesspiece object
    // If the square has a chessPiece on it, that piece should disappear
    func moveToSquare(square: Square, completion: @escaping ()-> ()) {
        
        self.square.removePieces()
        if let oldPiece = square.chessPiece {
            UIView.animate(withDuration: 1.0, animations: {
                self.frame = square.frame
                oldPiece.alpha = 0
            }, completion: { (finished) in
                if finished {
                    oldPiece.removeFromSuperview()
                    oldPiece.square = nil
                    completion()
                }
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.frame = square.frame
            }, completion: { (finished) in
                completion()
            })
        }
        square.chessPiece = self
        self.square = square
        
    }
    
    func setColor(side: Side) {
        self.side = side
    }
    
    func getColor()-> Side {
        return side
    }
    
    // Helper function to make sure the index we are accessing is within the board indexes
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
