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
        nameT.backgroundColor = .secondarySystemBackground
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
        emailT.backgroundColor = .secondarySystemBackground
        emailT.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        emailT.setLeftPaddingPoints(20)
        emailT.setRightPaddingPoints(20)
        
        messageT.text = ""
        messageT.backgroundColor = .secondarySystemBackground
        messageT.layer.borderWidth = 1.0
        messageT.layer.borderColor = UIColor.link.cgColor
        messageT.layer.cornerRadius = messageT.bounds.height / 2
        messageT.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        messageT.textContainer.lineFragmentPadding = 20
        messageT.textColor = UIColor.black
        messageT.font = UIFont.systemFont(ofSize: 16)
        messageT.returnKeyType = .done
        messageT.delegate = self
        messageT.autocorrectionType = .no
        messageT.autocapitalizationType = .none
        messageT.layer.cornerRadius = 20
        messageT.isEditable = true
        
        
        submitB.layer.cornerRadius = submitB.bounds.height / 2
        
    }
    
    
    @IBAction func submitB(_ sender: Any) {
        
    }
    
}

extension ContactUsVC:UITextFieldDelegate, UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameT {
            emailT.becomeFirstResponder()
        }else if textField == emailT {
            messageT.becomeFirstResponder()
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return false
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
