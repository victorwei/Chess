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
    
    tableViewSetup()
    splitGameNotation()
    
  }
  
  func splitGameNotation() {
    
    var whiteTurn = true
    for notation in gameNotation {
      if whiteTurn {
        whiteMoves.append(notation)
      } else {
        blackMoves.append(notation)
      }
      whiteTurn = !whiteTurn
    }
    
    
  }
  
  func tableViewSetup() {
    
    tableView = UITableView(frame: self.view.frame)
    tableView.delegate = self
    tableView.dataSource = self
    self.view.addSubview(tableView)
    
    let notationNib = UINib(nibName: "NotationCell", bundle: nil)
    tableView.register(notationNib, forCellReuseIdentifier: "notationCell")
  }
  
  
  
}

// MARK: - UITableView Delegate/Datasource
extension NotationVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return whiteMoves.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "notationCell", for: indexPath) as! NotationCell
    
    let whitesMove = whiteMoves[indexPath.row]
    if let blacksMove = blackMoves[safe: indexPath.row] {
      cell.blackLabel.text = blacksMove
    }
    
    cell.moveLabel.text = String(indexPath.row)
    cell.whiteLabel.text = whitesMove
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.view.frame.height / 15
  }
  
}


extension Collection {
  // Returns the element at the specified index iff it is within bounds, otherwise return nil
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
