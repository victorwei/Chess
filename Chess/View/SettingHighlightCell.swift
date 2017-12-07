//
//  SettingHighlightCell.swift
//  Chess
//
//  Created by Victor Wei on 12/5/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class SettingHighlightCell: UITableViewCell {

  @IBOutlet weak var highlightSwitch: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    highlightSwitch.isOn = Settings.shared.showMoves
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
}
