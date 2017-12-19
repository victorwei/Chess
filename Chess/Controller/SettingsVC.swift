//
//  SettingsVC.swift
//  Chess
//
//  Created by Victor Wei on 11/27/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

  
  var tableView: UITableView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupNavBar()
    self.view.backgroundColor = UIColor.gray
  }
  
  func setupTableView() {
    tableView = UITableView(frame: self.view.frame)
    tableView.delegate = self
    tableView.dataSource = self
    self.view.addSubview(tableView)
    
    tableView.allowsSelection = false
    tableView.isScrollEnabled = false
    tableView.separatorStyle = .none
    tableView.backgroundColor = nil
    
    let highlightNib = UINib(nibName: "SettingHighlightCell", bundle: nil)
    tableView.register(highlightNib, forCellReuseIdentifier: "highlightCell")
    let boardColorNib = UINib(nibName: "SettingsBoardColorCell", bundle: nil)
    tableView.register(boardColorNib, forCellReuseIdentifier: "colorCell")
    
  }
  
  func setupNavBar() {
    self.navigationController?.navigationBar.tintColor = UIColor.white
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    self.title = "Options"

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let navController = self.navigationController {
      UIView.transition(with: navController.view, duration: 0.75, options: .transitionCrossDissolve, animations: {
        self.navigationController?.popViewController(animated: false)
      }, completion: nil)
    }
  }
  

}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "highlightCell", for: indexPath) as! SettingHighlightCell
      
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! SettingsBoardColorCell
      
      return cell
      
    }
    
    let cell = UITableViewCell()
    cell.backgroundColor =  indexPath.row % 2 == 0 ? UIColor.green : UIColor.blue
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    Settings.shared.boardColor = UIColor.yellow
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.view.frame.height / 9
  }
}
