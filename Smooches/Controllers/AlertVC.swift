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
        setupTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //scrollViewS.scrollToBottom(animated: true)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    private func setupViews(){
        submitB.layer.cornerRadius = submitB.bounds.height / 2
        addB.backgroundColor = .link
        addB.layer.shadowColor = UIColor.gray.cgColor
        addB.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        addB.layer.shadowRadius = 1.0
        addB.layer.shadowOpacity = 0.7
        addB.titleLabel?.textColor = .white
        addB.layer.cornerRadius = addB.bounds.height / 2
        contentViewBase.layer.cornerRadius = 20
        scrollViewS.layer.cornerRadius = 20
        
    }
    
    private func setupTextView(){
        messageT.text = """
                                Type Message Here
                                """
        messageT.layer.cornerRadius = 20
        messageT.layer.borderWidth = 1
        messageT.layer.borderColor = UIColor.link.cgColor
        messageT.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        messageT.textContainer.lineFragmentPadding = 20
        messageT.textColor = UIColor.lightGray
        messageT.font = UIFont.systemFont(ofSize: 16)
        messageT.returnKeyType = .done
        messageT.delegate = self
        messageT.autocorrectionType = .no
        messageT.autocapitalizationType = .none
        messageT.layer.cornerRadius = 20
        messageT.isEditable = true
    }
    
    private func setHieghts(){
        let newHeight = CGFloat((dataSource.count * 80) + 20)
        tableViewHeight.constant = newHeight
        scrollViewContentViewHeight.constant = (scrollViewContentViewHeight.constant - 150) + newHeight
        
        let addContactsTableViewHeightNewHiehgt = CGFloat((3 * 70))
        
        addContactsTableViewHeight.constant = addContactsTableViewHeightNewHiehgt
        scrollViewContentViewHeight.constant = (scrollViewContentViewHeight.constant + addContactsTableViewHeightNewHiehgt)
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
        addContactsTableView.delegate = self
        addContactsTableView.dataSource = self
        addContactsTableView.rowHeight = 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return dataSource.count
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTVC", for: indexPath) as! AlertTVC
            cell.checkB.setTitle("", for: .normal)
            cell.nameL.textColor = .label
            cell.cardView.backgroundColor = .systemBackground
            cell.cardView.layer.cornerRadius = 10.0
            cell.cardView.layer.shadowColor = UIColor.gray.cgColor
            cell.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.cardView.layer.shadowRadius = 1.0
            cell.cardView.layer.shadowOpacity = 0.7
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
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
}


extension AlertVC:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        //return textView.text.count + (text.count - range.length) <= maxLenghth
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //wordCounterL.text = "\(textView.text.count)/300"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = """
                                    Type Message Here
                                    """
            textView.textColor = UIColor.lightGray
        }
    }
    
//
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        if textView.hasText {
//            finishB.isEnabled = true
//            finishB.titleLabel?.textColor = UIColor.link
//        }
//
//        if !textView.hasText {
//            finishB.isEnabled = false
//            finishB.titleLabel?.textColor = UIColor.lightGray
//        }
//    }
    
}

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}
