//
//  ViewController.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let chessboard = Chessboard()
        chessboard.setup(view: self.view)
//        let horizontalPadding: CGFloat = 15.0
//
//        //original view dimensions
//        let width = view.frame.width
//        let height = view.frame.height
//
//        // get 8x8 frame with 15 frame
//        let availableWidth = width - (2 * horizontalPadding)
//
//        let chessboardView = UIView()
//        chessboardView.backgroundColor = UIColor.lightGray
//        view.addSubview(chessboardView)
//        let widthLayout = NSLayoutConstraint(item: chessboardView, attribute: .width,
//                                             relatedBy: .equal, toItem: nil,
//                                             attribute: .notAnAttribute, multiplier: 1.0,
//                                             constant: availableWidth)
//
//        let heightLayout = NSLayoutConstraint(item: chessboardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: availableWidth)
//        let xCenterLayout = NSLayoutConstraint(item: chessboardView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 1.0)
//        let YCenterLayout = NSLayoutConstraint(item: chessboardView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 1.0)
//        NSLayoutConstraint.activate([widthLayout, heightLayout, xCenterLayout, YCenterLayout])
//
//        chessboardView.translatesAutoresizingMaskIntoConstraints = false
//
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

