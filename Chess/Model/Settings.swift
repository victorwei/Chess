//
//  Options.swift
//  Chess
//
//  Created by Victor Wei on 12/5/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class Settings: NSObject {
  
  // Initalizers
  
  @objc static let shared = Settings()
  override private init(){}
  
  // Properties
  
  @objc var showMoves: Bool = true
  @objc dynamic var boardColor = Colors.brown
  let colorChoices = [Colors.blue, Colors.green, Colors.brown]
}





enum Colors {
  
  static let green = UIColor(displayP3Red: 40.0 / 256.0, green: 110.0 / 256.0, blue: 35.0 / 256.0, alpha: 1.0)
  static let brown = UIColor.brown
  static let blue = UIColor(displayP3Red: 50.0 / 256.0, green: 50.0 / 256.0, blue: 150.0 / 256.0, alpha: 1.0)
  
}
