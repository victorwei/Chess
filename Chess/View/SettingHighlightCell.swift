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
    highlightSwitch.addTarget(self, action: #selector(onSwitchChange(_:)), for: .touchUpInside)
  }

  @objc func onSwitchChange(_ sender: UISwitch) {
    Settings.shared.showMoves = highlightSwitch.isOn
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
}
