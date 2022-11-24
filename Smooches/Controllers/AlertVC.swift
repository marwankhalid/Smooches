//
//  AlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit

struct Week {
    var name:String
}
extension Week {
    static let data:[Week] = [Week(name: "Monday"),Week(name: "Tuesday"),Week(name: "Wednesday"),Week(name: "Thursday"),Week(name: "Friday"),Week(name: "Saturday"),Week(name: "Sunday")]
}

class AlertVC: UIViewController {
    
    @IBOutlet weak var contentViewBase: UIView!
    @IBOutlet weak var scrollViewS: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var scrollViewContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var startTimeT: UITextField!
    @IBOutlet weak var endTimeT: UITextField!
    @IBOutlet weak var reminderTypeT: UITextField!
    @IBOutlet weak var addB: UIButton!
    @IBOutlet weak var addContactsTableView: UITableView!
    @IBOutlet weak var addContactsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageT: UITextView!
    @IBOutlet weak var submitB: UIButton!
    
    
    var dataSource = [Week]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataSource = Week.data
        setupTableView()
        setHieghts()
        setupViews()
        
    }
    
    private func setupViews(){
        submitB.layer.cornerRadius = submitB.bounds.height / 2
        addB.backgroundColor = .white
        addB.layer.shadowColor = UIColor.gray.cgColor
        addB.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        addB.layer.shadowRadius = 1.0
        addB.layer.shadowOpacity = 0.7
        addB.layer.cornerRadius = addB.bounds.height / 2
        contentViewBase.layer.cornerRadius = 20
        scrollViewS.layer.cornerRadius = 20
    }
    
    private func setHieghts(){
        let newHeight = CGFloat((dataSource.count * 80) + 20)
        tableViewHeight.constant = newHeight
        scrollViewContentViewHeight.constant = (scrollViewContentViewHeight.constant - 150) + newHeight
    }
    
    @IBAction func addB(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SelectContactsVC") as! SelectContactsVC
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @IBAction func submitB(_ sender: Any) {
        
    }
    
}

extension AlertVC:UITableViewDelegate,UITableViewDataSource {
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTVC", for: indexPath) as! AlertTVC
        cell.checkB.setTitle("", for: .normal)
        cell.cardView.backgroundColor = .white
        cell.cardView.layer.cornerRadius = 10.0
        cell.cardView.layer.shadowColor = UIColor.gray.cgColor
        cell.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.cardView.layer.shadowRadius = 1.0
        cell.cardView.layer.shadowOpacity = 0.7
        return cell
    }
    
}
