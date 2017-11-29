//
//  ViewController.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
  
  
  var chessboard: Chessboard!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navBarSetup()
    addNotationBtn()
    chessboard = Chessboard()
    chessboard.setup(viewController: self)
    setupTapGesturesForChessboard()
  }
  
  
  func addNotationBtn() {
    let button = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(onTapNotationBtn(_:)))
    self.navigationItem.setRightBarButton(button, animated: true)
  }
  
  @objc func onTapNotationBtn(_ sender: UIBarButtonItem) {
    
    let notationVC = NotationVC()
    notationVC.gameNotation = chessboard.gameNotation
    self.navigationController?.pushViewController(notationVC, animated: true)
    
  }
  
  
  @objc func tapSquare(_ sender: UITapGestureRecognizer) {
    
    guard let index = sender.view?.tag else {
      return
    }
    chessboard.selectSquare(index: index)
    
    
  }
  
  func setupTapGesturesForChessboard() {
    chessboard.board.flatMap{$0}.forEach { (square) in
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSquare(_:)))
      
      square.interactableView.addGestureRecognizer(tapGesture)
      square.interactableView.isUserInteractionEnabled = true
      
      let arrayNotation = square.boardNotation.returnTapArrayIndex()
      square.interactableView.tag = arrayNotation
    }
  }
  
}


extension UIViewController {
  
  func navBarSetup() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
  }
}

