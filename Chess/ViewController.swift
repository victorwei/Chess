//
//  ViewController.swift
//  Chess
//
//  Created by Victor Wei on 10/12/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var chessboard: Chessboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        chessboard = Chessboard()
        chessboard.setup(viewController: self)
        setupTapGestures()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func tapSquare(_ sender: UITapGestureRecognizer) {
       
        guard let index = sender.view?.tag else {
            return
        }
        chessboard.selectSquare(index: index)
        
        
    }
    
    func setupTapGestures() {
        chessboard.board.flatMap{$0}.forEach { (square) in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSquare(_:)))
            
            square.interactableView.addGestureRecognizer(tapGesture)
            square.interactableView.isUserInteractionEnabled = true
            
            let arrayNotation = square.boardNotation.returnTapArrayIndex()
            square.interactableView.tag = arrayNotation
        }
    }
    
    func getArrayIndexFromTag(tag: Int)-> (Int, Int) {
        
        let row = tag % 8
        let height = (tag - row) / 8
        return (row, height)
    }


}

