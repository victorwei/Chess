//
//  Chessboard.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation
import UIKit

class Chessboard: UIView {
    
    var originFrame = CGRect.zero
    var boardFrame: CGRect?
    var horizontalPadding: CGFloat = 15.0
    var availableWidth: CGFloat!
    var board: [[Square]] = []
    
    func setup(view: UIView) {
        drawBoard(view: view)
        setupPiecesForNewGame()
        setupTapGestures()
    }
    
    // Function to create the main chessboard view
    private func drawBoard(view: UIView) {
        
        //original view dimensions
        let width = view.frame.width
        let height = view.frame.height
        
        // get 8x8 frame with 15 frame
        availableWidth = width - (2 * horizontalPadding)
        
        let chessboardView = UIView()
        chessboardView.backgroundColor = UIColor.lightGray
        view.addSubview(chessboardView)
        let widthLayout = NSLayoutConstraint(item: chessboardView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: availableWidth)
        let heightLayout = NSLayoutConstraint(item: chessboardView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: availableWidth)
        let xCenterLayout = NSLayoutConstraint(item: chessboardView,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .centerX,
                                               multiplier: 1.0,
                                               constant: 1.0)
        let YCenterLayout = NSLayoutConstraint(item: chessboardView,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .centerY,
                                               multiplier: 1.0,
                                               constant: 1.0)
        NSLayoutConstraint.activate([widthLayout, heightLayout, xCenterLayout, YCenterLayout])
        chessboardView.translatesAutoresizingMaskIntoConstraints = false
        chessboardView.layer.borderColor = UIColor.red.cgColor
        chessboardView.layer.borderWidth = 2.0
        
        addSquares(chessboardView: chessboardView)
        
    }
    
    
    // Helper function to add checkerboard squares
    // Set up board datasource 
    private func addSquares(chessboardView: UIView) {
        
        let squareWidth: CGFloat = availableWidth / 8.0
        
        for index in (0..<8) {
            
            var row = [Square]()
            
            for index2 in (0..<8) {
                let newSquareView = Square()
                chessboardView.addSubview(newSquareView)
                
                if index2 % 2 == 0 {
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.white : UIColor.green
                } else {
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.green  : UIColor.white
                }
                
                
                let widthLayout = NSLayoutConstraint(item: newSquareView,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: squareWidth)
                let heightLayout = NSLayoutConstraint(item: newSquareView,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1.0,
                                                      constant: squareWidth)
                let leadingLayout = NSLayoutConstraint(item: newSquareView,
                                                       attribute: .leading,
                                                       relatedBy: .equal,
                                                       toItem: chessboardView,
                                                       attribute: .leading,
                                                       multiplier: 1.0,
                                                       constant: CGFloat(index) * squareWidth)
                let topLayout = NSLayoutConstraint(item: newSquareView,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: chessboardView,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: CGFloat(index2) * squareWidth)
                NSLayoutConstraint.activate([widthLayout, heightLayout, leadingLayout, topLayout])
                newSquareView.translatesAutoresizingMaskIntoConstraints = false
                
                row.append(newSquareView)
            }
            board.append(row)
        }
    }
    
    
    private func setupPiecesForNewGame() {
        
        
        for height in (0..<board.count) {
            
            for row in (0..<board[height].count) {
                if height == (board.count - 1) || height == 0 {
                    switch row {
                    case 0, 7:
                        
                        if height == 0 {
                            board[row][height].addPiece(type: .Rook, color: .black)
                        } else {
                            board[row][height].addPiece(type: .Rook, color: .white)
                        }
                    case 1, 6:
                        if height == 0 {
                            board[row][height].addPiece(type: .Knight, color: .black)
                        } else {
                            board[row][height].addPiece(type: .Knight, color: .white)
                        }
                    case 2, 5:
                        if height == 0 {
                            board[row][height].addPiece(type: .Bishop, color: .black)
                        } else {
                            board[row][height].addPiece(type: .Bishop, color: .white)
                        }
                    case 3:
                        if height == 0 {
                            board[row][height].addPiece(type: .Queen, color: .black)
                        } else {
                            board[row][height].addPiece(type: .Queen, color: .white)
                        }
                    case 4:
                        if height == 0 {
                            board[row][height].addPiece(type: .King, color: .black)
                        } else {
                            board[row][height].addPiece(type: .King, color: .white)
                        }
                    default:
                        break
                    }
                } else if height == 1 || height == (board.count - 2) {
                    if height == 1 {
                        board[row][height].addPiece(type: .Pawn, color: .black)
                    } else {
                        board[row][height].addPiece(type: .Pawn, color: .white)
                    }
                }
                
            }
        }
    }
    
    
    private func setupTapGestures() {
        
        board.flatMap{$0}.forEach { (square) in
            square.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSquare(_:)))
            square.addGestureRecognizer(tapGesture)
        }
    }
    
    
    @objc func tapSquare(_ square: Square) {
        
        if square.checkIfPieceIsThere {
            
        }
        
    }
}
