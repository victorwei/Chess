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
  var shouldDismiss: Bool = false
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navBarSetup()
    addNavigationBtns()
    chessboard = Chessboard()
    chessboard.setup(viewController: self)
    chessboard.delegate = self
    setupTapGesturesForChessboard()
  }
  
  func addNavigationBtns() {
    addBackBtn()
    addNotationBtn()
  }
  
  
  
  private func addBackBtn() {
    guard let navController = self.navigationController else {
      return
    }
    
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "return_regular"), for: .normal)
    button.setImage(#imageLiteral(resourceName: "return_highlighted"), for: .highlighted)
    button.imageView?.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(onTapBackBtn(_:)), for: .touchUpInside)
    let barButton = barBtnItemWithView(view: button, rect: CGRect(x: 0,
                                                                    y: 0,
                                                                    width: navController.navigationBar.frame.height * 0.8,
                                                                    height: navController.navigationBar.frame.height * 0.8))
    self.navigationItem.setLeftBarButton(barButton, animated: true)
  }
  
  
  private func addNotationBtn() {
    
    guard let navController = self.navigationController else {
      return
    }

    let button2 = UIButton()
    button2.setImage(#imageLiteral(resourceName: "notepad_regular"), for: .normal)
    button2.setImage(#imageLiteral(resourceName: "notepad_highlighted"), for: .highlighted)
    button2.imageView?.contentMode = .scaleAspectFit
    button2.addTarget(self, action: #selector(onTapNotationBtn(_:)), for: .touchUpInside)
    let barButton2 = barBtnItemWithView(view: button2, rect: CGRect(x: 0,
                                                                    y: 0,
                                                                    width: navController.navigationBar.frame.height * 0.8 + 5,
                                                                    height: navController.navigationBar.frame.height * 0.8))
    self.navigationItem.setRightBarButton(barButton2, animated: true)
  }
  
  func barBtnItemWithView(view: UIView, rect: CGRect) -> UIBarButtonItem {
    let container = UIView(frame: rect)
    container.addSubview(view)
    view.frame = rect
    return UIBarButtonItem(customView: container)
  }
  
  @objc func onTapBackBtn(_ sender: UIBarButtonItem) {
    
    showAlert(forCheckMate: false, whiteWin: nil)
    
    // idea for bg
    // radial blur/gradient in corner of the screen
    
  }
  
  
  
  private func showAlert(forCheckMate: Bool, whiteWin: Bool?) {
    
    let optionsAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomAlertVC") as! CustomAlertVC
    optionsAlert.providesPresentationContextTransitionStyle = true
    optionsAlert.definesPresentationContext = true
    optionsAlert.modalPresentationStyle = .overCurrentContext
    optionsAlert.modalTransitionStyle = .crossDissolve
    optionsAlert.delegate = self
    optionsAlert.checkmateAlert = forCheckMate
    if forCheckMate {
      optionsAlert.whiteWin = whiteWin!
    }
    self.present(optionsAlert, animated: true, completion: nil)
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

extension GameVC: CustomAlertDelegate {
  func restartBtnTapped() {
    chessboard.resetGame()
  }
  func mainMenuBtnTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  func optionsBtnTapped() {
    let settingsVC = SettingsVC()
    self.navigationController?.pushViewController(settingsVC, animated: false)
  }
}


extension GameVC: ChessboardDelegate {
  func showCheckMateAlert(whiteWins: Bool) {
    showAlert(forCheckMate: true, whiteWin: whiteWins)
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

