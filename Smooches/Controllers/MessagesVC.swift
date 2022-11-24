//
//  MessagesVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit

class MessagesVC: UIViewController {

    @IBOutlet weak var newMessageB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func newMessageB(_ sender: Any) {
        let cont = storyboard?.instantiateViewController(withIdentifier: "AlertVC") as! AlertVC
        cont.isModalInPresentation = true
        cont.modalPresentationStyle = .automatic
        self.present(cont, animated: true)
    }
}
