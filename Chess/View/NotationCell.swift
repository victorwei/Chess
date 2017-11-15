//
//  NotationCell.swift
//  Chess
//
//  Created by Victor Wei on 11/14/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class NotationCell: UITableViewCell {
  
  // MARK: - Properties
  @IBOutlet weak var moveLabel: UILabel!
  @IBOutlet weak var whiteLabel: UILabel!
  @IBOutlet weak var blackLabel: UILabel!
  
  @IBOutlet weak var moveView: UIView!
  @IBOutlet weak var whiteView: UIView!
  @IBOutlet weak var blackView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
//    moveView.layer.borderWidth = 1.0
//    moveView.layer.borderColor = UIColor.black.cgColor
    
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
}
