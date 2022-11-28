//
//  HomeVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/23/22.
//

import UIKit
import ContactsUI

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshB: UIButton!
    
    var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    var filter: ContactsFilter = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViews()
        getContacts()
        
    }
    
    private func getContacts(){
        
        let blag = PhoneContacts()
        
        self.loadContacts(filter: filter) // Calling loadContacts methods

        
          for contact in phoneContacts {
              print("Name -> \(contact.name)")
              print("Email -> \(contact.email)")
              print("Phone Number -> \(contact.phoneNumber)")
            }
            let arrayCode  = self.phoneNumberWithContryCode()
            for codes in arrayCode {
              print(codes)
            }
             DispatchQueue.main.async {
               self.tableView.reloadData() // update your tableView having phoneContacts array
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
        refreshB.backgroundColor = .white
        refreshB.layer.shadowColor = UIColor.gray.cgColor
        refreshB.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        refreshB.layer.shadowRadius = 1.0
        refreshB.layer.shadowOpacity = 0.7
        refreshB.layer.cornerRadius = refreshB.bounds.height / 2
    }

    @IBAction func refreshB(_ sender: Any) {
        getContacts()
    }
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        cell.selectionStyle = .none
        cell.nameL.text = phoneContacts[indexPath.row].name
        cell.phoneL.text = phoneContacts[indexPath.row].phoneNumber.first?.description
        cell.imgI.layer.cornerRadius = cell.imgI.bounds.height / 2
        cell.cardV.backgroundColor = .systemBackground
        cell.cardV.layer.cornerRadius = 10.0
        cell.cardV.layer.shadowColor = UIColor.gray.cgColor
        cell.cardV.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.cardV.layer.shadowRadius = 1.0
        cell.cardV.layer.shadowOpacity = 0.7
        return cell
    }
}
