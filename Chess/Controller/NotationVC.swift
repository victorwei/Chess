//
//  NotationVC.swift
//  Chess
//
//  Created by Victor Wei on 11/14/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class NotationVC: UIViewController {
  
  // MARK: - Properties
  var tableView: UITableView!
  var gameNotation: [String]!
  var whiteMoves: [String] = []
  var blackMoves: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navBarSetup()
    tableViewSetup()
    splitGameNotation()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if let navController = self.navigationController {
      UIView.transition(with: navController.view, duration: 0.75, options: .transitionFlipFromRight, animations: {
        self.navigationController?.popViewController(animated: false)
      }, completion: nil)
    }
  }
  
  func splitGameNotation() {
    
    var whiteTurn = true
    for notation in gameNotation {
      whiteTurn ? whiteMoves.append(notation) : blackMoves.append(notation)
      whiteTurn = !whiteTurn
    }
  }
  
  func tableViewSetup() {
    
    
    guard let navBarHeight = self.navigationController?.navigationBar.frame.height else {
      return
    }
    
    tableView = UITableView(frame: self.view.frame,
                            style: .grouped)
    tableView.delegate = self
    tableView.dataSource = self
    self.view.addSubview(tableView)
    tableView.allowsSelection = false
    
    let notationNib = UINib(nibName: "NotationCell", bundle: nil)
    tableView.register(notationNib, forCellReuseIdentifier: "notationCell")
    tableView.separatorColor = UIColor.darkGray
    tableView.contentInset = UIEdgeInsetsMake(-(navBarHeight + UIApplication.shared.statusBarFrame.height), 0, 0, 0)
  }
  
  
  
}

// MARK: - UITableView Delegate/Datasource
extension NotationVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (whiteMoves.count < 15) ? 15 : whiteMoves.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "notationCell", for: indexPath) as! NotationCell
    
    if let whitesMove = whiteMoves[safe: indexPath.row] {
      cell.whiteLabel.text = whitesMove
    }
    if let blacksMove = blackMoves[safe: indexPath.row] {
      cell.blackLabel.text = blacksMove
    }
    
    cell.moveLabel.text = String(indexPath.row)
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.view.frame.height / 15
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableCell(withIdentifier: "notationCell") as! NotationCell
    headerView.setForHeaderView()
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return self.view.frame.height / 12
  }
}


extension Collection {
  // Returns the element at the specified index iff it is within bounds, otherwise return nil
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
