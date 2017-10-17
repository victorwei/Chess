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
    var chessboardView: UIView!
    
    func setup(viewController: UIViewController) {
        drawBoard(view: viewController.view)
        setupPiecesForNewGame()
    }
    
    // Function to create the main chessboard view
    private func drawBoard(view: UIView) {
        
        //original view dimensions
        let width = view.frame.width
        let height = view.frame.height
        
        // get 8x8 frame with 15 frame
        availableWidth = width - (2 * horizontalPadding)
        
//        chessboardView = UIView()
//        chessboardView.backgroundColor = UIColor.lightGray
//        view.addSubview(chessboardView)
//        let widthLayout = NSLayoutConstraint(item: chessboardView,
//                                             attribute: .width,
//                                             relatedBy: .equal,
//                                             toItem: nil,
//                                             attribute: .notAnAttribute,
//                                             multiplier: 1.0,
//                                             constant: availableWidth)
//        let heightLayout = NSLayoutConstraint(item: chessboardView,
//                                              attribute: .height,
//                                              relatedBy: .equal,
//                                              toItem: nil,
//                                              attribute: .notAnAttribute,
//                                              multiplier: 1.0,
//                                              constant: availableWidth)
//        let xCenterLayout = NSLayoutConstraint(item: chessboardView,
//                                               attribute: .centerX,
//                                               relatedBy: .equal,
//                                               toItem: view,
//                                               attribute: .centerX,
//                                               multiplier: 1.0,
//                                               constant: 1.0)
//        let YCenterLayout = NSLayoutConstraint(item: chessboardView,
//                                               attribute: .centerY,
//                                               relatedBy: .equal,
//                                               toItem: view,
//                                               attribute: .centerY,
//                                               multiplier: 1.0,
//                                               constant: 1.0)
//        NSLayoutConstraint.activate([widthLayout, heightLayout, xCenterLayout, YCenterLayout])
        
        
        
        
        
        
        chessboardView = UIView(frame: CGRect(x: horizontalPadding,
                                              y: view.frame.height / 2 - availableWidth / 2,
                                              width: availableWidth,
                                              height: availableWidth))
        chessboardView.backgroundColor = UIColor.lightGray
        chessboardView.layer.borderColor = UIColor.red.cgColor
        chessboardView.layer.borderWidth = 2.0
        view.addSubview(chessboardView)
        
        addSquares(chessboardView: chessboardView)
    }
    
    
    // Helper function to add checkerboard squares
    // Set up board datasource 
    private func addSquares(chessboardView: UIView) {
        
        let squareWidth: CGFloat = availableWidth / 8.0
        
        for index in (0..<8) {
            
            var row = [Square]()
            
            for index2 in (0..<8) {
                
                var boardSquareWidth = chessboardView.frame.width / 8
                let boardCGPoint = CGPoint(x: (boardSquareWidth * CGFloat(index2)),
                                           y: (boardSquareWidth * CGFloat(index)))
                let boardSize = CGSize(width: boardSquareWidth, height: boardSquareWidth)
                let rect = CGRect(origin: boardCGPoint, size: boardSize)
                
                let newSquareView = Square(frame: rect, arrayIndex: (index, index2))

                chessboardView.addSubview(newSquareView)
                
                if index2 % 2 == 0 {
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.white : UIColor.green
                } else {
                    newSquareView.backgroundColor = index % 2 == 0 ? UIColor.green  : UIColor.white
                }
//                let widthLayout = NSLayoutConstraint(item: newSquareView,
//                                                     attribute: .width,
//                                                     relatedBy: .equal,
//                                                     toItem: nil,
//                                                     attribute: .notAnAttribute,
//                                                     multiplier: 1.0,
//                                                     constant: squareWidth)
//                let heightLayout = NSLayoutConstraint(item: newSquareView,
//                                                      attribute: .height,
//                                                      relatedBy: .equal,
//                                                      toItem: nil,
//                                                      attribute: .notAnAttribute,
//                                                      multiplier: 1.0,
//                                                      constant: squareWidth)
//                let leadingLayout = NSLayoutConstraint(item: newSquareView,
//                                                       attribute: .leading,
//                                                       relatedBy: .equal,
//                                                       toItem: chessboardView,
//                                                       attribute: .leading,
//                                                       multiplier: 1.0,
//                                                       constant: CGFloat(index) * squareWidth)
//                let topLayout = NSLayoutConstraint(item: newSquareView,
//                                                   attribute: .top,
//                                                   relatedBy: .equal,
//                                                   toItem: chessboardView,
//                                                   attribute: .top,
//                                                   multiplier: 1.0,
//                                                   constant: CGFloat(index2) * squareWidth)
//                NSLayoutConstraint.activate([widthLayout, heightLayout, leadingLayout, topLayout])
//                newSquareView.translatesAutoresizingMaskIntoConstraints = false
                
                row.append(newSquareView)
            }
            board.append(row)
        }
    }
    
    
    // Function to set pieces object at each square
    private func setupPiecesForNewGame() {
        
        for height in (0..<board.count) {
            for row in (0..<board[height].count) {
                let boardSquare = board[height][row]
                if height == (board.count - 1) || height == 0 {
                    switch row {
                    case 0, 7:
                        
                        if height == 0 {
                            addPiece(square: boardSquare, type: .Rook, color: .black)
                        } else {
                            addPiece(square: boardSquare, type: .Rook, color: .white)
                        }
                    case 1, 6:
                        if height == 0 {
                            addPiece(square: boardSquare, type: .Knight, color: .black)
                        } else {
                            addPiece(square: boardSquare, type: .Knight, color: .white)
                        }
                    case 2, 5:
                        if height == 0 {
                            addPiece(square: boardSquare, type: .Bishop, color: .black)
                        } else {
                            addPiece(square: boardSquare, type: .Bishop, color: .white)
                        }
                    case 3:
                        if height == 0 {
                            addPiece(square: boardSquare, type: .Queen, color: .black)
                        } else {
                            addPiece(square: boardSquare, type: .Queen, color: .white)
                        }
                    case 4:
                        if height == 0 {
                            addPiece(square: boardSquare, type: .King, color: .black)
                        } else {
                            addPiece(square: boardSquare, type: .King, color: .white)
                        }
                    default:
                        break
                    }
                } else if height == 1 || height == (board.count - 2) {
                    if height == 1 {
                        addPiece(square: boardSquare, type: .Pawn, color: .black)
                    } else {
                        addPiece(square: boardSquare, type: .Pawn, color: .white)
                    }
                }
                
            }
        }
    }
    
    
    func possibleMoves(currentSquare: Square)-> [Square.Type]? {
        guard let piece = currentSquare.chessPiece,
        let pieceType = piece.title else {
            return nil
        }
        
        switch pieceType {
            
        case .Bishop:
            break
        case .Rook:
            break
        case .Knight:
            break
        case .Pawn:
            break
        case .King:
            break
        case .Queen:
            break
        }
        return nil
    }
    
    private func addPiece(square: Square, type: PiecesType, color: Pieces.Side) {
        var chessPiece: Pieces!
        switch type {
        case .Rook:
            chessPiece = Rook(frame: square.frame, color: color)
            
        case .King:
            chessPiece = King(frame: square.frame, color: color)
        case .Queen:
            chessPiece = Queen(frame: square.frame, color: color)
        case .Bishop:
            chessPiece = Bishop(frame: square.frame, color: color)
        case .Knight:
            chessPiece = Knight(frame: square.frame, color: color)
        case .Pawn:
            chessPiece = Pawn(frame: square.frame, color: color)
            
        }
        square.chessPiece = chessPiece
        chessPiece.square = square
        chessboardView.addSubview(chessPiece)
    }
    
    
    private func getPossiblePawnMoves(square: BoardNotation) -> [(Int, Int)]? {
        
        let arrayNotation = square.returnArrayNotation()
        
        var row = arrayNotation.0
        var height = arrayNotation.1
        
        var possibleMoves = [(Int, Int)]()
        for index in (1...2) {
            let possibleHeight = height - index
            if (possibleHeight > 0) || (height > 7) {
                possibleMoves.append((row, possibleHeight))
            }
        }
        return possibleMoves
    }
    
    
    
// func setupTapGestures(viewController: UIViewController) {
//
//        board.flatMap{$0}.forEach { (square) in
//            let tapGesture = UITapGestureRecognizer(target: viewController, action: #selector(Chessboard.tapSquare(_:)))
//            square.tappableView.addGestureRecognizer(tapGesture)
//            square.tappableView.isUserInteractionEnabled = true
//            print(square.boardNotation.returnBoardNotation())
//            print(square.boardNotation.returnArrayNotation())
//            print(square.boardNotation.returnTapArrayIndex())
//        }
//    }
//
//
//    @objc func tapSquare(_ sender: UITapGestureRecognizer) {
//
////        guard let piece = square.chessPiece else {
////            return
////        }
//
//        print("Touched")
////
////        switch piece.title! {
////        case .Pawn:
////            if let possibleMoves = getPossiblePawnMoves(square: square.boardNotation) {
////                for notation in possibleMoves {
////                    board[notation.0][notation.1].highlighted = !board[notation.0][notation.1].highlighted
////                }
////            }
////
////
////
////
////        default:
////            break
////        }
//
//    }
}
