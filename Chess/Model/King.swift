////
////  King.swift
////  Chess
////
////  Created by Victor Wei on 10/12/17.
////  Copyright © 2017 vDub. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class King: ChessPiece {
//    
//    convenience init(frame: CGRect, color: ChessPiece.Side) {
//        self.init(frame: frame)
//        if color == .white {
//            image = UIImage(named: "king_white")
//        } else {
//            image = UIImage(named: "king_black")
//        }
//        self.type = PiecesType.King
//        self.side = color
//        imageView.image = image
//    }
//    
//    
//    func getAllPossibleKingMoves(chessboard: [[Square]]) {
//        guard let square = self.square else {
//            return
//        }
//        let arrayNotation = square.boardNotation.returnArrayNotation()
//        
//        let height = arrayNotation.0
//        let row = arrayNotation.1
//        
//        var possibleMoves = [BoardNotation]()
//        
//        let moveUp = height - 1
//        let moveDown = height + 1
//        let moveRight = row + 1
//        let moveLeft = row - 1
//        
//        
//        if checkValidSquare(index: moveUp) {
//            if checkValidSquare(index: moveRight){
//                let potentialSquare = chessboard[moveUp][moveRight]
//                if let chessPieceOnSquare = potentialSquare.chessPiece {
//                    if chessPieceOnSquare.getColor() != self.getColor() {
//                        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
//                    }
//                } else {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveUp))
//                }
//            }
//            if checkValidSquare(index: moveLeft){
//                let potentialSquare = chessboard[moveUp][moveLeft]
//                if let chessPieceOnSquare = potentialSquare.chessPiece {
//                    if chessPieceOnSquare.getColor() != self.getColor() {
//                        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
//                    }
//                } else {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveUp))
//                }
//            }
//            
//            let potentialSquare = chessboard[moveUp][row]
//            if let chessPieceOnSquare = potentialSquare.chessPiece {
//                if chessPieceOnSquare.getColor() != self.getColor() {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
//                }
//            } else {
//                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveUp))
//            }
//            
//        }
//        
//        //Check squares that queen can move in the Down direction
//        if checkValidSquare(index: moveDown) {
//            if checkValidSquare(index: moveRight) {
//                let potentialSquare = chessboard[moveDown][moveRight]
//                if let chessPieceOnSquare = potentialSquare.chessPiece {
//                    if chessPieceOnSquare.getColor() != self.getColor() {
//                        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
//                    }
//                } else {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: moveDown))
//                }
//            }
//            
//            if checkValidSquare(index: moveLeft) {
//                let potentialSquare = chessboard[moveDown][moveLeft]
//                if let chessPieceOnSquare = potentialSquare.chessPiece {
//                    if chessPieceOnSquare.getColor() != self.getColor() {
//                        possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
//                    }
//                } else {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: moveDown))
//                }
//            }
//            
//            let potentialSquare = chessboard[moveDown][row]
//            if let chessPieceOnSquare = potentialSquare.chessPiece {
//                if chessPieceOnSquare.getColor() != self.getColor() {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
//                }
//            } else {
//                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: row)!, height: moveDown))
//            }
//            
//        }
//        
//        //Check squares that queen can move to the right
//        if checkValidSquare(index: moveRight) {
//            let potentialSquare = chessboard[height][moveRight]
//            if let chessPieceOnSquare = potentialSquare.chessPiece {
//                if chessPieceOnSquare.getColor() != self.getColor() {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
//                }
//            } else {
//                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveRight)!, height: height))
//            }
//        }
//        
//        //Check squares that queen can move to the left
//        if checkValidSquare(index: moveLeft) {
//            let potentialSquare = chessboard[height][moveLeft]
//            if let chessPieceOnSquare = potentialSquare.chessPiece {
//                if chessPieceOnSquare.getColor() != self.getColor() {
//                    possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
//                }
//            } else {
//                possibleMoves.append(BoardNotation(row: BoardNotation.RowNotation(rawValue: moveLeft)!, height: height))
//            }
//        }
//        
//        
//        self.possibleMoves = possibleMoves
//    }
//    
//}

