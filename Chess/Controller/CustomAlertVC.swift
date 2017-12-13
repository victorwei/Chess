//
//  CustomAlertVC.swift
//  Chess
//
//  Created by Victor Wei on 12/11/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class CustomAlertVC: UIViewController {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var btn1: UIButton!
  @IBOutlet weak var btn2: UIButton!
  @IBOutlet weak var btn3: UIButton!
  @IBOutlet weak var closeBtn: UIButton!
  @IBOutlet weak var messageLabel: UILabel!
  
  weak var delegate: CustomAlertDelegate!
  var checkmateAlert: Bool!
  var whiteWin: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let checkmateAlert = checkmateAlert else {
      return
    }
    
    containerView.layer.cornerRadius = 15.0
    containerView.layer.borderColor = UIColor.lightGray.cgColor
    containerView.layer.borderWidth = 2.0
    setupBlurBackground()
    setupCloseBtn()
    setupButtons()
    
    if checkmateAlert {
      setupCheckmateAlert()
    }
  }
  
  func setupCloseBtn() {
    closeBtn.setImage(#imageLiteral(resourceName: "closeBtn_pressed"), for: .highlighted)
  }
  
  
  func setupCheckmateAlert() {
    btn1.isHidden = true
    btn1.isEnabled = false
    messageLabel.isHidden = false
    
    messageLabel.text = whiteWin ? "White Wins!" : "Black Wins!"
  }
  
  private func setupBlurBackground() {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.view.insertSubview(blurEffectView, at: 0)
  }
  
  private func setupButtons() {
    
    
    
    setupBtnAppearance(button: btn1)
    setupBtnAppearance(button: btn2)
    setupBtnAppearance(button: btn3)
    
    if checkmateAlert {
      btn2.setTitle("New Game", for: .normal)
      btn2.addTarget(self, action: #selector(restartBtnOnTap(_:)), for: .touchUpInside)
    } else {
      btn1.setTitle("Restart", for: .normal)
      btn2.setTitle("Options", for: .normal)
      btn1.addTarget(self, action: #selector(restartBtnOnTap(_:)), for: .touchUpInside)
      btn2.addTarget(self, action: #selector(optionBtnOnTap(_:)), for: .touchUpInside)
    }
    
    btn3.setTitle("Main Menu", for: .normal)
    btn3.addTarget(self, action: #selector(menuBtnOnTap(_:)), for: .touchUpInside)
    closeBtn.addTarget(self, action: #selector(closeBtnOnTap(_:)), for: .touchUpInside)
  }
  
  func setupBtnAppearance(button: UIButton) {
    button.layer.cornerRadius = button.frame.height / 2
    button.layer.borderWidth = 2.0
    button.layer.borderColor = UIColor.white.cgColor
  }
  
  @objc func restartBtnOnTap(_ sender: Any) {
    delegate.restartBtnTapped()
    dismiss(animated: true, completion: nil)
  }
  
  @objc func optionBtnOnTap(_ sender: Any) {
    delegate.optionsBtnTapped()
    dismiss(animated: true, completion: nil)
  }
  
  @objc func menuBtnOnTap(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    delegate.mainMenuBtnTapped()
  }
  
  @objc func closeBtnOnTap(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
}

protocol CustomAlertDelegate: class {
  func restartBtnTapped()
  func optionsBtnTapped()
  func mainMenuBtnTapped()
}
