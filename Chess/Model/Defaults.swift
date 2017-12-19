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
    guard let value = value else {
      set(nil, forKey: forKey)
      return
    }
    set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: forKey)
  }
  
  public func colorForKey(key: String)-> UIColor? {
    guard let data = value(forKey: key),
      let color = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UIColor else {
        return nil
    }
    return color
  }
  
}
