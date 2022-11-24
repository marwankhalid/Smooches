//
//  AlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addB(_ sender: Any) {
    }
    
    @IBAction func submitB(_ sender: Any) {
    }
    
}
