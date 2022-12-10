//
//  SelectContactsVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit

struct phoneContactAgain {
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
}



class SelectContactsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarV: UIView!
    @IBOutlet weak var doneB: UIButton!
    @IBOutlet weak var selectContactsL: UILabel!
    @IBOutlet weak var dismissB: UIButton!
    @IBOutlet weak var pleaseSelectDescriptionL: UILabel!
    
    var selectContactsCounter = 1
    var phoneContacts = [PhoneContact]()
    var selectedContactsArray = [phoneContactAgain]()
    var contactsAgain = [phoneContactAgain]()
    
    var delegate:selectedContactsTap?
    var indexSaved = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneContacts = UserDefaultsConstants.getDataFromUserDefaults() ?? [PhoneContact]()
        for i in 0..<self.phoneContacts.count {
            let model = phoneContactAgain(name: phoneContacts[i].name, avatarData: phoneContacts[i].avatarData, phoneNumber: phoneContacts[i].phoneNumber, email: phoneContacts[i].email)
            contactsAgain.append(model)
        }
        doneB.setTitle("Done", for: .normal)
        dismissB.setTitle("Reset", for: .normal)
        setupTableView()
    }

    @IBAction func doneB(_ sender: Any) {
        if self.selectedContacts() {
            delegate?.tapContacts(array: selectedContactsArray)
            self.dismiss(animated: true)
        }else if !selectedContacts() {
            print("NIL")
            self.dismiss(animated: true)
        }
        
    }
    
    private func selectedContacts() -> Bool{
        if self.indexSaved.count == 0 {
            return false
        }
        for i in 0..<self.indexSaved.count {
            let model = phoneContactAgain(
                                            name: self.contactsAgain[self.indexSaved[i]].name,
                                            avatarData: self.contactsAgain[self.indexSaved[i]].avatarData,
                                            phoneNumber: self.contactsAgain[self.indexSaved[i]].phoneNumber,
                                            email: self.contactsAgain[self.indexSaved[i]].email)
            
            selectedContactsArray.append(model)
        }
        return true
    }
    
    @IBAction func dismissB(_ sender: Any) {
        setupTableView()
        self.selectContactsCounter = 1
        self.indexSaved.removeAll()
        self.selectedContactsArray.removeAll()
        for i in 0..<self.contactsAgain.count {
            let indexpath = IndexPath(row: i, section: 0)
            let cell = tableView.cellForRow(at: indexpath) as! HomeTVC
            cell.imgI.alpha = 1
        }
        tableView.reloadData()
    }
    
}

extension SelectContactsVC:UITableViewDelegate,UITableViewDataSource {
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsAgain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTVC.identifier, for: indexPath) as! HomeTVC
        cell.selectionStyle = .none
        cell.nameL.text = contactsAgain[indexPath.row].name
        cell.phoneL.text = contactsAgain[indexPath.row].phoneNumber.first?.description
        cell.imgI.layer.cornerRadius = cell.imgI.bounds.height / 2
        cell.cardV.backgroundColor = .systemBackground
        cell.nameL.textColor = .label
        cell.phoneL.textColor = .label
        cell.cardV.layer.cornerRadius = 10.0
        cell.cardV.layer.shadowColor = UIColor.gray.cgColor
        cell.cardV.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.cardV.layer.shadowRadius = 1.0
        cell.cardV.layer.shadowOpacity = 0.7
        
        
        if let _ = indexSaved.firstIndex(of: indexPath.row) {
            cell.accessoryType = .none
        }else {
            cell.accessoryType = .checkmark
        }
        
        
//        for i in 0..<indexSaved.count {
//            if indexPath.row == indexSaved[i] {
//                cell.accessoryType = .checkmark
//                break
//            }else {
//                cell.accessoryType = .none
//                break
//            }
//        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectContactsCounter <= 5 {
            let cell = tableView.cellForRow(at: indexPath) as! HomeTVC
            if indexSaved.count == 0 {
                let cell = tableView.cellForRow(at: indexPath) as! HomeTVC
                cell.accessoryType = .checkmark
                self.selectContactsCounter += 1
                self.indexSaved.append(indexPath.row)
            }else if self.indexSaved.count > 0{
                if let index = indexSaved.firstIndex(of: indexPath.row) {
                    print(index)
                    print("Find")
                    cell.accessoryType = .none
                    self.selectContactsCounter -= 1
                    self.indexSaved.remove(at: index)
                }else {
                    cell.accessoryType = .checkmark
                    self.selectContactsCounter += 1
                    self.indexSaved.append(indexPath.row)
                    print("Not Find")
                }
            }
            print(indexSaved)
        }else {
            print("Selection Full")
        }
    }
    
}
