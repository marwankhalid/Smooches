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
    var pickerView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    var cancel:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(UIColor.link, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    
    var ok:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("ok", for: .normal)
        b.setTitleColor(UIColor.link, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    
    var timePicker:UIDatePicker = {
        let timepicker = UIDatePicker()
        timepicker.translatesAutoresizingMaskIntoConstraints = false
        timepicker.backgroundColor = UIColor.gray
        timepicker.datePickerMode = UIDatePicker.Mode.time
        if #available(iOS 13.4, *) {
            timepicker.preferredDatePickerStyle = .wheels
        }
        return timepicker
    }()
    let dropDown = DropDown()
    
    var dataSource = [Week]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Week.data
        setupTableView()
        setHieghts()
        setupViews()
        setupTextView()
        notification()
        setupDatePicker()
        
    }
    
    private func setupDatePicker(){
        self.contentViewBase.addSubview(self.pickerView)
        self.pickerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.pickerView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        self.pickerView.centerXAnchor.constraint(equalTo: contentViewBase.centerXAnchor).isActive = true
        self.pickerView.centerYAnchor.constraint(equalTo: contentViewBase.centerYAnchor).isActive = true
        
        self.pickerView.addSubview(timePicker)
        timePicker.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 10).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor,constant: 10).isActive = true
        timePicker.topAnchor.constraint(equalTo: pickerView.topAnchor,constant: 10).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        self.pickerView.addSubview(cancel)
        self.pickerView.addSubview(ok)
        
        cancel.topAnchor.constraint(equalTo: timePicker.bottomAnchor,constant: 10).isActive = true
        cancel.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor,constant: 20).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        ok.topAnchor.constraint(equalTo: timePicker.bottomAnchor,constant: 10).isActive = true
        ok.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor,constant: 50).isActive = true
        ok.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ok.heightAnchor.constraint(equalToConstant: 25).isActive = true
        pickerView.layer.cornerRadius = 20
        self.pickerView.alpha = 0
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
        

        // The view to which the drop down will appear on
        dropDown.anchorView = reminderTypeT // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        DropDown.startListeningToKeyboard()

        // Will set a custom width instead of the anchor view width
        
        
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


extension AlertVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
