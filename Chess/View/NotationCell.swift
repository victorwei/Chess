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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
}
