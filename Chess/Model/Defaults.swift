//
//  Defaults.swift
//  Chess
//
//  Created by Victor Wei on 12/18/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit


extension UserDefaults {
  
  public func setColor(value: UIColor?, forKey: String ) {
    set(NSKeyedArchiver.archivedData(withRootObject: value as Any), forKey: forKey)
  }
  
  public func colorForKey(key: String)-> UIColor? {
    guard let data = value(forKey: key),
      let color = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UIColor else {
        return nil
    }
    return color
  }
  
}



enum CoreDataPieceKeys {
  static let squareRow = "squareRow"
  static let squareColumn = "squareColumn"
  static let chessPieceFrame = "frameRect"
  static let pieceHasMoved = "hasMoved"
  static let type = "type"
  static let whiteSide = "whiteSide"
  
  static let entity = "ManagedChessPiece"
}


enum CoreDataGameKeys {
  static let whiteTurn = "whiteTurn"
  static let resumeGame = "resumeGame"
  
  static let entity = "ManagedGame"
}

enum CoreDataGameNotation {
  static let gameNotation = "gameNotation"
  
  static let entity = "ManagedGameNotation"
}
