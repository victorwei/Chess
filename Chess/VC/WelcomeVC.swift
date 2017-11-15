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
  
  @IBOutlet weak var btn1: UIButton!
  @IBOutlet weak var btn2: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.isNavigationBarHidden = true
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
    self.navigationController?.pushViewController(gameVC, animated: true)
  }
  
  @IBAction func onClickBtn2(_ sender: Any) {
  }
  
  
}
