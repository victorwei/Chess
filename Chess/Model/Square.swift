//
//  Square.swift
//  Chess
//
//  Created by Victor Wei on 10/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit




struct BoardNotation {
  
  enum RowNotation: Int {
    case A = 0, B, C, D, E, F, G, H
    
    var description: String {
      switch self {
      case .A:
        return "a"
      case .B:
        return "b"
      case .C:
        return "c"
      case .D:
        return "d"
      case .E:
        return "e"
      case .F:
        return "f"
      case .G:
        return "g"
      case .H:
        return "h"
      }
    }
  }
  
  
  var row: RowNotation
  var height: Int
  
  func returnBoardNotation(whitesTurn: Bool)-> String {
    var boardHeight = height + 1
    var boardRow = row.description
    if whitesTurn {
      boardHeight = 8 - height
    } else {
      // If it is black's turn, the board row should be flipped
      switch boardRow {
      case "a":
        boardRow = "h"
      case "b":
        boardRow = "g"
      case "c":
        boardRow = "f"
      case "d":
        boardRow = "e"
      case "e":
        boardRow = "d"
      case "f":
        boardRow = "c"
      case "g":
        boardRow = "b"
      case "h":
        boardRow = "a"
      default:
        break
      }
    }
    let notation = boardRow + String(boardHeight)
    return notation

    
//    return (boardRow, boardHeight)
  }
  
  func returnArrayNotation() -> (Int, Int) {
    return (height, row.rawValue)
  }
  
  func returnTapArrayIndex() -> Int {
    return row.rawValue + (height * 8)
  }
  
}

class Square: UIView {
  
  var boardNotation: BoardNotation!
  var highlightView: UIView!
  var interactableView: UIView!
  weak var chessPiece: ChessPiece?
  
  
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
    setNotation(row: arrayIndex.1, height: arrayIndex.0)
    setupHighlightView()
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var checkIfPieceIsThere: Bool {
    return chessPiece != nil
  }
  
  
  private func setNotation(row: Int, height: Int) {
    if let rowNotation = BoardNotation.RowNotation(rawValue: row) {
      boardNotation = BoardNotation(row: rowNotation, height: height)
    }
  }
  
  
  func setupHighlightView() {
    highlightView = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: self.frame.width,
                                         height: self.frame.height))
    highlightView.backgroundColor = UIColor.yellow
    highlightView.alpha = 0.5
    highlightView.isHidden = true
    self.addSubview(highlightView)
  }
  
  func removePieces() {
    chessPiece = nil
  }

  
  func flashErrorView() {
    highlightView.backgroundColor = UIColor.red
    self.highlightView.alpha = 0.7
    highlightView.isHidden = false
    
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
        self.highlightView.backgroundColor = UIColor.yellow
        self.highlightView.alpha = 0.5
      }) { (completed) in
//        self.highlightView.alpha = 0.5
//        self.highlightView.backgroundColor = UIColor.yellow
      }
    }
    
//    UIView.animate(withDuration: 1.5, animations: {
//      //
//      self.highlightView.backgroundColor = UIColor.red
//    }) { [weak self] (completed) in
////      self?.highlightView.backgroundColor = UIColor.yellow
//    }
    
  }
  
  
}
