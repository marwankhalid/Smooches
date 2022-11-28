//
//  ViewController.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/21/22.
//

import UIKit
import Contacts

class AddContactsVC: UIViewController {

    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var secondCircle: UIView!
    @IBOutlet weak var nextB: UIButton!
    
    
    var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    var filter: ContactsFilter = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGesture()
        
        
    }
    
    private func getContacts(){
        
        let blag = PhoneContacts()
        
        self.loadContacts(filter: filter) // Calling loadContacts methods

        
          for contact in phoneContacts {
              print("Name -> \(String(describing: contact.name))")
              print("Email -> \(contact.email)")
              print("Phone Number -> \(contact.phoneNumber)")
            }
            let arrayCode  = self.phoneNumberWithContryCode()
            for codes in arrayCode {
              print(codes)
            }
             DispatchQueue.main.async {
                 let contoller = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                 contoller.modalPresentationStyle = .fullScreen
                 self.present(contoller, animated: true)
               //self.tableView.reloadData() // update your tableView having phoneContacts array
            }
    }
    
    fileprivate func loadContacts(filter: ContactsFilter) {
        phoneContacts.removeAll()
        var allContacts = [PhoneContact]()
        for contact in PhoneContacts.getContacts(filter: filter) {
            allContacts.append(PhoneContact(contact: contact))
        }
    
        var filterdArray = [PhoneContact]()
        if self.filter == .mail {
            filterdArray = allContacts.filter({ $0.email.count > 0 }) // getting all email
        } else if self.filter == .message {
            filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
        } else {
            filterdArray = allContacts
        }
        phoneContacts.append(contentsOf: filterdArray)
        UserDefaultsConstants.savedDataToUserDefaults(model: self.phoneContacts, key: UserDefaultsConstants.contacts)
        UserDefaults.standard.set(true, forKey: UserDefaultsConstants.contactsFlag)
        
    }
    
    func phoneNumberWithContryCode() -> [String] {

        let contacts = PhoneContacts.getContacts() // here calling the getContacts methods
        var arrPhoneNumbers = [String]()
        for contact in contacts {
            for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
                if let fulMobNumVar  = ContctNumVar.value as? CNPhoneNumber {
                    //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
                       if let MccNamVar = fulMobNumVar.value(forKey: "digits") as? String {
                            arrPhoneNumbers.append(MccNamVar)
                    }
                }
            }
        }
        return arrPhoneNumbers // here array has all contact numbers.
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
        self.getContacts()
        
    }
    
}

