//
//  AlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit
import DropDown

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
    @IBOutlet weak var closeB: UIButton!
    @IBOutlet weak var contetnViewBaseBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var message2T: UITextView!
    @IBOutlet weak var message3T: UITextView!
    @IBOutlet weak var message4T: UITextView!
    @IBOutlet weak var message5T: UITextView!
    
    let dropDown = DropDown()
    var dataSource = [Week]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Week.data
        setupTableView()
        setHieghts()
        setupViews()
        setupTextView()
        //notification()
        messageT.textColor = .label
        
    }
    
    private func notification(){
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
    
    @IBAction func closeB(_ sender: Any) {
        self.dismiss(animated: true)
    }
    private func setupViews(){
        submitB.layer.cornerRadius = submitB.bounds.height / 2
        addB.backgroundColor = .link
        addB.layer.shadowColor = UIColor.gray.cgColor
        addB.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        addB.layer.shadowRadius = 1.0
        addB.layer.shadowOpacity = 0.7
        addB.layer.cornerRadius = addB.bounds.height / 2
        contentViewBase.layer.cornerRadius = 20
        scrollViewS.layer.cornerRadius = 20
        //closeB.layer.cornerRadius = 20
        closeB.setTitle("", for: .normal)
        
        
        setupTextFields(textField: startTimeT, placeholder: "Start Time")
        startTimeT.isUserInteractionEnabled = true
        startTimeT.isEnabled = true
        startTimeT.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapStartTime)))
        setupTextFields(textField: endTimeT, placeholder: "End Time")
        endTimeT.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEndTime)))
        endTimeT.isEnabled = true
        setupTextFields(textField: reminderTypeT, placeholder: "")
        reminderTypeT.isEnabled = true
        reminderTypeT.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapReminderType)))
        
        dropDown.anchorView = reminderTypeT
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        DropDown.startListeningToKeyboard()
        dropDown.backgroundColor = .systemBackground
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                print("Dark mode")
                dropDown.separatorColor = .lightText
                
            } else {
                print("Light mode")
                dropDown.separatorColor = .black
            }
        }
        dropDown.selectionBackgroundColor = .secondarySystemBackground
        dropDown.textColor = .label
    }
    
    @objc func tapReminderType(){
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            reminderTypeT.text = item
        }
    }
    
    @objc func tapStartTime(){
        let controller = DatePickerAlertVC()
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true)
    }
    
    @objc func tapEndTime(){
        let controller = DatePickerAlertVC()
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true)
    }
    
    private func setupTextFields(textField:UITextField,placeholder:String){
        textField.delegate = self
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.link.cgColor
        textField.layer.cornerRadius = textField.bounds.height / 2
        textField.backgroundColor = .secondarySystemBackground
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
    }
    
    private func setupTextView(){
        setupTextField(textfield: messageT)
        setupTextField(textfield: message2T)
        setupTextField(textfield: message3T)
        setupTextField(textfield: message4T)
        setupTextField(textfield: message5T)
    }
    
    private func setupTextField(textfield:UITextView){
        textfield.layer.cornerRadius = 20
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.link.cgColor
        textfield.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        textfield.textContainer.lineFragmentPadding = 20
        textfield.textColor = UIColor.label
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.layer.cornerRadius = 20
        textfield.isEditable = true
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
        tableView.separatorStyle = .none
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
            cell.selectionStyle = .none
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
        self.contetnViewBaseBottomConstraint.constant = 270
        DispatchQueue.main.async {
            print("ARIAN")
            self.scrollViewS.scrollToBottom(animated: true)
            
        }
        if textView.textColor == .label {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.contetnViewBaseBottomConstraint.constant = 15
        if textView.text.isEmpty {
            textView.text = """
                                    Type Message Here
                                    """
            textView.textColor = UIColor.lightGray
        }
    }
    
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


extension AlertVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

