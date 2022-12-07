//
//  DeleteAlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 12/8/22.
//

import UIKit

class DeleteAlertVC: UIViewController {
    
    @IBOutlet weak var alertV: UIView!
    @IBOutlet weak var yesB: UIButton!
    @IBOutlet weak var noB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yesB.layer.cornerRadius = yesB.bounds.height / 2
        
        alertV.layer.cornerRadius = 10.0
        alertV.layer.shadowColor = UIColor.gray.cgColor
        alertV.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        alertV.layer.shadowRadius = 1.0
        alertV.layer.shadowOpacity = 0.7
        
    }

    @IBAction func yesB(_ sender: Any) {
        
    }
    
    @IBAction func noB(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
