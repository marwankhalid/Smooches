//
//  ViewController.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/21/22.
//

import UIKit

class AddContactsVC: UIViewController {

    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var secondCircle: UIView!
    @IBOutlet weak var nextB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGesture()
        
    }
    
    private func setupViews(){
        firstCircle.layer.cornerRadius = firstCircle.bounds.height / 2
        secondCircle.layer.cornerRadius = secondCircle.bounds.height / 2
        nextB.layer.cornerRadius = nextB.bounds.height / 2
        
    }
    
    private func setupGesture(){
        firstCircle.isUserInteractionEnabled = true
        secondCircle.isUserInteractionEnabled = true
        firstCircle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCircle)))
        secondCircle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCircle)))
    }
    
    @objc func tapCircle(){
        print(123)
    }

    @IBAction func nextB(_ sender: Any) {
        
    }
    
}

