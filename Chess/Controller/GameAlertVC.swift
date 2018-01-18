//
//  GameAlertVC.swift
//  Chess
//
//  Created by Victor Wei on 1/10/18.
//  Copyright © 2018 vDub. All rights reserved.
//

import UIKit

class GameAlertVC: UIViewController {

  @IBOutlet weak var alertContainerView: UIView!
  @IBOutlet weak var btn1: UIButton!
  @IBOutlet weak var btn2: UIButton!
  
  weak var delegate: GamerAlertDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupBtnAppearance(button: btn1)
    setupBtnAppearance(button: btn2)
    
    alertContainerView.layer.cornerRadius = 15.0
    alertContainerView.layer.borderColor = UIColor.lightGray.cgColor
    alertContainerView.layer.borderWidth = 2.0
    
    btn1.addTarget(self, action: #selector(resumeGameOnTap(_:)), for: .touchUpInside)
    btn2.addTarget(self, action: #selector(newGameOnTap(_:)), for: .touchUpInside)
  }
  

  func setupBtnAppearance(button: UIButton) {
    button.layer.cornerRadius = button.frame.height / 2
    button.layer.borderWidth = 2.0
    button.layer.borderColor = UIColor.white.cgColor
  }
  
  
  @objc func resumeGameOnTap(_ selector: UIButton) {
    
    dismiss(animated: true, completion: nil)
    delegate.resumeGame()
  }
  
  @objc func newGameOnTap(_ selector: UIButton) {
    
    dismiss(animated: true, completion: nil)
    delegate.startNewGame()
  }
  
}


protocol GamerAlertDelegate: class {
  
  func startNewGame()
  func resumeGame()
  
}
