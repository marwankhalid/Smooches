//
//  SelectContactsVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit

class SelectContactsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarV: UIView!
    @IBOutlet weak var doneB: UIButton!
    @IBOutlet weak var selectContactsL: UILabel!
    @IBOutlet weak var dismissB: UIButton!
    @IBOutlet weak var pleaseSelectDescriptionL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneB.setTitle("", for: .normal)
        dismissB.setTitle("", for: .normal)
        setupTableView()
    }

    @IBAction func doneB(_ sender: Any) {
        
    }
    
    @IBAction func dismissB(_ sender: Any) {
        self.dismiss(animated: true)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        cell.imgI.layer.cornerRadius = cell.imgI.bounds.height / 2
        cell.cardV.backgroundColor = .white
        cell.cardV.layer.cornerRadius = 10.0
        cell.cardV.layer.shadowColor = UIColor.gray.cgColor
        cell.cardV.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.cardV.layer.shadowRadius = 1.0
        cell.cardV.layer.shadowOpacity = 0.7
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(123)
    }
    
}
