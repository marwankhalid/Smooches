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
    
    var selectContactsCounter = 1
    
    var indexSaved = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneB.setTitle("Done", for: .normal)
        dismissB.setTitle("Reset", for: .normal)
        setupTableView()
    }

    @IBAction func doneB(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func dismissB(_ sender: Any) {
        setupTableView()
        self.selectContactsCounter = 1
        self.indexSaved.removeAll()
        for i in 0...7 {
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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        cell.selectionStyle = .none
        cell.imgI.layer.cornerRadius = cell.imgI.bounds.height / 2
        cell.cardV.backgroundColor = .systemBackground
        cell.nameL.textColor = .label
        cell.phoneL.textColor = .label
        cell.cardV.layer.cornerRadius = 10.0
        cell.cardV.layer.shadowColor = UIColor.gray.cgColor
        cell.cardV.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.cardV.layer.shadowRadius = 1.0
        cell.cardV.layer.shadowOpacity = 0.7
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectContactsCounter <= 5 {
            let cell = tableView.cellForRow(at: indexPath) as! HomeTVC
            if indexSaved.count == 0 {
                print("A")
                let cell = tableView.cellForRow(at: indexPath) as! HomeTVC
                cell.imgI.alpha = 0.6
                self.selectContactsCounter += 1
                self.indexSaved.append(indexPath.row)
            }else if self.indexSaved.count > 0{
                print("B")
                for i in 0..<indexSaved.count {
                    if indexPath.row == indexSaved[i] {
                        print("C")
                        print(indexPath.row)
                        print(i)
                        print(indexSaved[i])
                        cell.imgI.alpha = 1
                        self.selectContactsCounter -= 1
                        self.indexSaved.remove(at: i)
                        break
                    }else {
                        cell.imgI.alpha = 0.6
                        self.selectContactsCounter += 1
                        self.indexSaved.append(indexPath.row)
                        break
                    }
                }
            }
            print(indexSaved)
        }else {
            print("Selection Full")
        }
    }
    
}
