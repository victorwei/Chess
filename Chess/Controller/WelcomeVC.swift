//
//  WelcomeVC.swift
//  Chess
//
//  Created by Victor Wei on 11/10/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit
import CoreData


class WelcomeVC: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var btn1: UIButton!
  @IBOutlet weak var btn2: UIButton!
  
  var resumeOldGame: (Bool, Bool) = (false, false)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTitleShdadow()
    setGradientBackground()
    navBarSetup()
    
    
//    deleteAllRecords()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
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
//    presentNewGame()
    checkForOldGame()

    if resumeOldGame.0 == true {
      displayGameAlert()
    } else {
      presentNewGame()
    }
  }
  
  
  
  @IBAction func onClickBtn2(_ sender: Any) {
    
    let settingsVC = SettingsVC()
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    self.navigationController?.view.layer.add(transition, forKey: nil)
    self.navigationController?.pushViewController(settingsVC, animated: false)
  }
  
  
  func displayGameAlert() {
    
    let gameAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameAlertVC") as! GameAlertVC
    gameAlert.providesPresentationContextTransitionStyle = true
    gameAlert.definesPresentationContext = true
    gameAlert.modalPresentationStyle = .overCurrentContext
    gameAlert.modalTransitionStyle = .crossDissolve
    gameAlert.delegate = self
    
    self.present(gameAlert, animated: true, completion: nil)
    
  }
  
  func presentNewGame() {
    if let presented = self.presentedViewController {
      presented.removeFromParentViewController()
    }
    let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameVC") as! GameVC
    let gameNC = UINavigationController(rootViewController: gameVC)
    present(gameNC, animated: true, completion: nil)
  }
  
  func presentOldGame() {
    if let presented = self.presentedViewController {
      presented.removeFromParentViewController()
    }
    
    let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameVC") as! GameVC
    let gameNC = UINavigationController(rootViewController: gameVC)
    gameVC.resumeOldGame = self.resumeOldGame
    present(gameNC, animated: true, completion: nil)
  }
}



// MARK: - CoreData Retrieval

extension WelcomeVC {
  
  private func checkForOldGame() {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataGameKeys.entity)
    
    do {
      let managedObjects = try managedContext.fetch(fetchRequest)
      resumePreviousGameForWhiteSide(managedObject: managedObjects)
      
      // Delete the record
      for managedObject in managedObjects {
        managedContext.delete(managedObject)
      }
      try managedContext.save()

    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  private func resumePreviousGameForWhiteSide(managedObject: [NSManagedObject]){
    
    if managedObject.count != 1 {
      return
    }
    let resumeGame = managedObject[0].value(forKey: CoreDataGameKeys.resumeGame) as! Bool
    let whitesTurn = managedObject[0].value(forKey: CoreDataGameKeys.whiteTurn) as! Bool
    
    self.resumeOldGame = (resumeGame, whitesTurn)
  }
  
  private func clearCoreDataGame() {
    //delete all data
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataGameKeys.entity)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
    do {
      try context.execute(deleteRequest)
      try context.save()
    } catch {
      print ("There was an error")
    }
  }
  
}


extension WelcomeVC: GamerAlertDelegate {
  func startNewGame() {
    presentNewGame()
  }
  
  func resumeGame() {
    presentOldGame()
  }
}


