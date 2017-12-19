//
//  ChoosePieceVC.swift
//  Chess
//
//  Created by Victor Wei on 12/13/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class ChoosePieceVC: UIViewController {
  
  var containerView: UIView!
  var forWhite: Bool!
  weak var delegate: ChoosePieceDelegate!
  
  convenience init(whiteSide: Bool) {
    self.init()
    self.forWhite = whiteSide
  }

  override func viewDidLoad() {
    super.viewDidLoad()
      // Do any additional setup after loading the view.
    
    drawView()
    addImages()
  }
  
  
  
  func drawView() {
    
    containerView = UIView(frame: CGRect(x: 30,
                                             y: self.view.frame.height * 0.4,
                                             width: self.view.frame.width - 60,
                                             height: self.view.frame.height * 0.2))
    containerView.backgroundColor = UIColor.gray
    containerView.layer.cornerRadius = 5.0
    containerView.layer.borderWidth = 3.0
    containerView.layer.borderColor = UIColor.white.cgColor
    
    self.view.addSubview(containerView)
    let label = UILabel(frame: CGRect(x: 0, y: 10, width: containerView.bounds.width, height: 20))
    label.textAlignment = .center
    label.text = "Promote pawn to what piece?"
    containerView.addSubview(label)
  }
  
  
  func addImages() {
    
    
    for width in (0..<4) {
      let btn = UIButton(frame: CGRect(x: CGFloat(width) * (containerView.bounds.width / 4),
                                       y: containerView.bounds.height * 0.25,
                                       width: containerView.bounds.width / 4 ,
                                       height: containerView.bounds.height / 2))
      btn.tag = width
      switch width {
      case 0:
        forWhite ? btn.setImage(UIImage(named: "wn"), for: .normal) : btn.setImage(UIImage(named: "bn"), for: .normal)
      case 1:
        forWhite ? btn.setImage(UIImage(named: "wb"), for: .normal) : btn.setImage(UIImage(named: "bb"), for: .normal)
//        imageView.image = forWhite ?  UIImage(named: "wb") : UIImage(named: "bb")
      case 2:
        forWhite ? btn.setImage(UIImage(named: "wr"), for: .normal) : btn.setImage(UIImage(named: "br"), for: .normal)
//        imageView.image = forWhite ?  UIImage(named: "wr") : UIImage(named: "br")
      case 3:
        forWhite ? btn.setImage(UIImage(named: "wq"), for: .normal) : btn.setImage(UIImage(named: "bq"), for: .normal)
//        imageView.image = forWhite ?  UIImage(named: "wq") : UIImage(named: "bq")
      default:
        break
      }
      containerView.addSubview(btn)
      
      btn.addTarget(self, action: #selector(pieceBtnOnTap(_:)), for: .touchUpInside)
      
    }
    
  }
  
  
  @objc func pieceBtnOnTap(_ sender: UIButton) {
    print("clicked \(sender.tag)")
    var pieceType: PiecesType!
    
    switch sender.tag {
    case 0:
      pieceType = .Knight
    case 1:
      pieceType = .Bishop
    case 2:
      pieceType = .Rook
    case 3:
      pieceType = .Queen
    default:
      break
    }
    delegate.selectedPiece(piece: pieceType)
    dismiss(animated: true, completion: nil)
  }

}

protocol ChoosePieceDelegate: class {
  func selectedPiece(piece: PiecesType)
}
