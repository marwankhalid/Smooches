//
//  ContactUsVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 12/7/22.
//

import UIKit

class ContactUsVC: UIViewController {

    @IBOutlet weak var nameT: UITextField!
    @IBOutlet weak var emailT: UITextField!
    @IBOutlet weak var messageT: UITextView!
    @IBOutlet weak var submitB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    private func setupViews(){
        nameT.delegate = self
        nameT.borderStyle = .none
        nameT.layer.borderWidth = 1.0
        nameT.layer.borderColor = UIColor.link.cgColor
        nameT.layer.cornerRadius = nameT.bounds.height / 2
        nameT.backgroundColor = .white
        nameT.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        nameT.setLeftPaddingPoints(20)
        nameT.setRightPaddingPoints(20)
        
        emailT.delegate = self
        emailT.borderStyle = .none
        emailT.layer.borderWidth = 1.0
        emailT.layer.borderColor = UIColor.link.cgColor
        emailT.layer.cornerRadius = emailT.bounds.height / 2
        emailT.backgroundColor = .white
        emailT.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        emailT.setLeftPaddingPoints(20)
        emailT.setRightPaddingPoints(20)
        
        
    }
    
    
    @IBAction func submitB(_ sender: Any) {
        
    }
    
}

extension ContactUsVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
