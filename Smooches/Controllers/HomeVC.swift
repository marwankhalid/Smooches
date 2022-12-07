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
        //getContacts()
        self.phoneContacts = UserDefaultsConstants.getDataFromUserDefaults() ?? [PhoneContact]()
        tableView.reloadData()
        self.navigationController?.navigationBar.isHidden = true
        setupTabbar()
    }
    
    public func setupTabbar(){
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
           
            self.tabBarController?.tabBar.standardAppearance = appearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
        }
    }
    
    
    private func setupViews(){
        refreshB.backgroundColor = .link
        refreshB.layer.shadowColor = UIColor.gray.cgColor
        refreshB.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        refreshB.layer.shadowRadius = 1.0
        refreshB.layer.shadowOpacity = 0.7
        refreshB.layer.cornerRadius = refreshB.bounds.height / 2
    }

    @IBAction func refreshB(_ sender: Any) {
        //getContacts()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTVC.identifier, for: indexPath) as! HomeTVC
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
