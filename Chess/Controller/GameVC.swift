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
    addNavigationBtns()
    chessboard = Chessboard()
    chessboard.setup(viewController: self)
    setupTapGesturesForChessboard()
  }
  
  func addNavigationBtns() {
    addBackBtn()
    addNotationBtn()
  }
  
  private func addBackBtn() {
    let button1 = UIBarButtonItem(barButtonSystemItem: .stop , target: self, action: #selector(onTapBackBtn(_:)))
    self.navigationItem.setLeftBarButton(button1, animated: true)
  }
  
  
  private func addNotationBtn() {
    let button2 = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(onTapNotationBtn(_:)))
    self.navigationItem.setRightBarButton(button2, animated: true)
  }
  
  
  @objc func onTapBackBtn(_ sender: UIBarButtonItem) {
//    dismiss(animated: true, completion: nil)
    let settingsVC = SettingsVC()
    self.navigationController?.pushViewController(settingsVC, animated: false)
  }
  
  
  @objc func onTapNotationBtn(_ sender: UIBarButtonItem) {
    
    let notationVC = NotationVC()
    notationVC.gameNotation = chessboard.gameNotation

    if let navController = self.navigationController {
      UIView.transition(with: navController.view, duration: 0.75, options: .transitionFlipFromLeft, animations: {
        self.navigationController?.pushViewController(notationVC, animated: false)
      }, completion: nil)
    }
    
    
//    let transition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//    transition.type = "flip"
//    transition.subtype = kCATransitionFromLeft
//    self.navigationController?.view.layer.add(transition, forKey: nil)
//    self.navigationController?.pushViewController(notationVC, animated: true)
    
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

