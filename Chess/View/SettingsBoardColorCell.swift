//
//  SettingsBoardColorCell.swift
//  Chess
//
//  Created by Victor Wei on 12/6/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class SettingsBoardColorCell: UITableViewCell {

  @IBOutlet weak var colorView1: UIView!
  @IBOutlet weak var colorView2: UIView!
  @IBOutlet weak var colorView3: UIView!
  
  var viewsArr = [UIView]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupViews()
    setupTapGestures()
    backgroundColor = UIColor.clear
  }
  
  private func setupViewTags() {
    colorView1.tag = 0
    colorView2.tag = 1
    colorView3.tag = 2
  }
  
  private func setupViews() {
    viewsArr = [colorView1, colorView2, colorView3]
    setupViewTags()

    for (index, colorView) in viewsArr.enumerated() {
      colorView.backgroundColor = Settings.shared.colorChoices[index]
      if colorView.backgroundColor == Settings.shared.boardColor {
        selectColorView(selectedView: colorView)
      }
    }
  }

  
  func setupTapGestures() {
    colorView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapColorView(_:))))
    colorView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapColorView(_:))))
    colorView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapColorView(_:))))
  }
  
  @objc func onTapColorView(_ sender: AnyObject) {
    let tag = sender.view.tag
    selectColorView(selectedView: viewsArr[tag])
  }
  
  private func selectColorView(selectedView: UIView) {
    
    for colorView in viewsArr {
      if colorView == selectedView {
        selectedView.layer.borderColor = UIColor.red.cgColor
        selectedView.layer.borderWidth = 2.0
        Settings.shared.boardColor = colorView.backgroundColor!
      } else {
        deselectColorView(selectedView: colorView)
      }
    }
  }
  
  private func deselectColorView(selectedView: UIView) {
    selectedView.layer.borderColor = UIColor.darkGray.cgColor
    selectedView.layer.borderWidth = 1.0
  }
  

  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
    
}
