//
//  WelcomeVC.swift
//  Chess
//
//  Created by Victor Wei on 11/10/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var btn1: UIButton!
  @IBOutlet weak var btn2: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTitleShdadow()
    setGradientBackground()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }
  
  func setTitleShdadow() {
    titleLabel.layer.shadowColor = UIColor.black.cgColor
    titleLabel.layer.shadowRadius = 2.5
    titleLabel.layer.shadowOpacity = 1.0
    titleLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
    titleLabel.layer.masksToBounds = false
  }
  
  func setGradientBackground() {
    let topColor = UIColor(red: 170.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
    let bottomColor = UIColor(red: 100.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [ topColor, bottomColor]
    gradientLayer.locations = [ 0.0, 3.0]
    gradientLayer.frame = self.view.bounds
    
    self.view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.isNavigationBarHidden = false
  }
  
  
  // MARK: - IBActions
  
  @IBAction func onClickBtn1(_ sender: Any) {
    let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameVC")
    let gameNC = UINavigationController(rootViewController: gameVC)
    
//    var modalStyle = UIModalTransitionStyle.crossDissolve
//    gameNC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    present(gameNC, animated: true, completion: nil)
    
//    let transition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//    transition.type = kCATransitionFade
//    self.navigationController?.view.layer.add(transition, forKey: nil)
//    self.navigationController?.pushViewController(gameVC, animated: false)
  }
  
  @IBAction func onClickBtn2(_ sender: Any) {
    
    let settingsVC = SettingsVC()
    self.navigationController?.pushViewController(settingsVC, animated: false)
  }
  
  
}
