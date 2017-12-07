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
  
  var showMoves: Bool = true
  
  @objc dynamic var boardColor = Colors.brown
  
}





enum Colors {
  
  static let green = UIColor.green
  static let brown = UIColor.brown
  static let blue = UIColor.blue
  
}
