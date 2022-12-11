//
//  AlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit
import DropDown
import Fastis
import Toast_Swift


struct AlertModel {
    let id:Int64
    let reminderType:String
    let weekDays:String?
    let timeLimit:String?
    let startTime:String
    let endTime:String
    let selectedContacts:String
    let message1:String
    let message2:String
    let message3:String
    let message4:String
    let message5:String
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
    @IBOutlet weak var closeB: UIButton!
    @IBOutlet weak var contetnViewBaseBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var message2T: UITextView!
    @IBOutlet weak var message3T: UITextView!
    @IBOutlet weak var message4T: UITextView!
    @IBOutlet weak var message5T: UITextView!
    @IBOutlet weak var timeLimitL: UILabel!
    @IBOutlet weak var timeLimitHeightConst: NSLayoutConstraint!
    @IBOutlet weak var selectDateT: UITextField!
    @IBOutlet weak var selectDateHeightConst: NSLayoutConstraint!
    
    
    var currentValue: FastisValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if let rangeValue = self.currentValue as? FastisRange {
                self.selectDateT.text = formatter.string(from: rangeValue.fromDate) + " - " + formatter.string(from: rangeValue.toDate)
            } else if let date = self.currentValue as? Date {
                self.selectDateT.text = formatter.string(from: date)
            } else {
                self.selectDateT.placeholder = "Choose a date"
            }
        }
    }
    
    let dropDown = DropDown()
    var dataSource = [Week]()
    var savedDataSource:AlertModel?
    var savedIndexForSelectedWeeks:[Int] = [Int]()
    var selectedContacts = [phoneContactAgain]()
    var dropDownDataSource = ["Single Day", "Date Range","Monthly"]
    var constantHeight = 1470
    var startTime:Date?
    var endTime:Date?
    var selectedWeekDays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Week.data
        setupTableView()
        setHieghts()
        setupViews()
        setupText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timeLimitL.alpha = 0
        selectDateT.alpha = 0
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
        
        
        //setupTextFields(textField: selectDateT, placeholder: "Date")
        selectDateT.isEnabled = true
        selectDateT.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSelectDate)))
        
        dropDown.anchorView = reminderTypeT
        dropDown.dataSource = dropDownDataSource
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
            if reminderTypeT.text == self.dropDownDataSource[1] || reminderTypeT.text == self.dropDownDataSource[2] {
                scrollViewContentViewHeight.constant += 70
                timeLimitHeightConst.constant = 20
                selectDateHeightConst.constant = 40
                timeLimitL.alpha = 1
                selectDateT.alpha = 1
                self.setupTextFields(textField: selectDateT, placeholder: "Date")
            }
        }
    }
    
    @objc func tapStartTime(){
        let controller = DatePickerAlertVC(startTime: true, endTime: false)
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    @objc func tapEndTime(){
        let controller = DatePickerAlertVC(startTime: false, endTime: true)
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    @objc func tapSelectDate(){
        if reminderTypeT.text == "Monthly" {
            chooseDate()
        }else if reminderTypeT.text == "Date Range" {
            chooseRange()
        }
    }
    
    private func chooseDate(){
        let fastisController = FastisController(mode: .single)
        fastisController.title = "Choose date"
        fastisController.initialValue = self.currentValue as? Date
        fastisController.maximumDate = Date()
        fastisController.shortcuts = [.today, .yesterday, .tomorrow]
        fastisController.doneHandler = { newDate in
            self.currentValue = newDate
        }
        fastisController.present(above: self)
    }
    
    private func chooseRange(){
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        fastisController.initialValue = self.currentValue as? FastisRange
        fastisController.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        fastisController.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.doneHandler = { newValue in
            self.currentValue = newValue
        }
        fastisController.present(above: self)
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
    
    private func setupText(){
        setupTextView(textfield: messageT)
        setupTextView(textfield: message2T)
        setupTextView(textfield: message3T)
        setupTextView(textfield: message4T)
        setupTextView(textfield: message5T)
    }
    
    private func setupTextView(textfield:UITextView){
        textfield.text = "Type Here..."
        textfield.textColor = .link
        textfield.layer.cornerRadius = 20
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.link.cgColor
        textfield.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        textfield.textContainer.lineFragmentPadding = 20
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.layer.cornerRadius = 20
        textfield.isEditable = true
    }
    
    private func setHieghts(){
        // WeekDays TableView Height
        let newHeight = CGFloat((dataSource.count * 80) + 20)
        tableViewHeight.constant = newHeight
        //scrollViewContentViewHeight.constant = (scrollViewContentViewHeight.constant - 150) + newHeight
        scrollViewContentViewHeight.constant = CGFloat(constantHeight - 150) + newHeight
        
        // Selected Contacts TableView Height
        if selectedContacts.count > 0 {
            let addContactsTableViewHeightNewHiehgt = CGFloat((self.selectedContacts.count * 70))
            addContactsTableViewHeight.constant = addContactsTableViewHeightNewHiehgt
            scrollViewContentViewHeight.constant = ((scrollViewContentViewHeight.constant) + addContactsTableViewHeightNewHiehgt)
        }
    }
    
    @IBAction func addB(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: SelectContactsVC.identifier) as! SelectContactsVC
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    @IBAction func submitB(_ sender: Any) {
        if checkStartTime() && checkEndTime() {
            print(savedIndexForSelectedWeeks)
            self.view.makeToast("Success")
        }else {
            self.view.makeToast("Failure")
        }
    }
    
    private func checkStartTime() ->Bool{
        let currentDate = Date()
        if currentDate < self.startTime! {
            return true
        }else {
            return false
        }
    }
    
    private func checkEndTime() ->Bool{
        if self.startTime! < self.endTime! {
            return true
        }else {
            return false
        }
    }
                                  
    private func getWeekDaysString() ->String{
        let converted = savedIndexForSelectedWeeks.map{String($0)}.joined(separator: ",")
        return converted
    }
    
    
}

extension AlertVC:tapTime {
    func tapTime(time: String,startTime: Bool, endTime:Bool,timeDate:Date) {
        if startTime {
            self.startTimeT.text = time
            self.startTime = timeDate
        }
        if endTime {
            self.endTimeT.text = time
            self.endTime = timeDate
        }
    }
}

protocol tapTime {
    func tapTime(time:String,startTime:Bool,endTime:Bool,timeDate:Date)
}

extension AlertVC:selectedContactsTap {
    func tapContacts(array: [phoneContactAgain]) {
        self.selectedContacts = array
        addContactsTableView.reloadData()
        self.setHieghts()
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
        return selectedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: AlertTVC.identifier, for: indexPath) as! AlertTVC
            cell.selectionStyle = .none
            cell.checkB.setTitle("", for: .normal)
            cell.checkB.tintColor = .label
            cell.nameL.text = dataSource[indexPath.row].name
            cell.nameL.textColor = .label
            cell.cardView.backgroundColor = .systemBackground
            cell.cardView.layer.cornerRadius = 10.0
            cell.cardView.layer.shadowColor = UIColor.gray.cgColor
            cell.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.cardView.layer.shadowRadius = 1.0
            cell.cardView.layer.shadowOpacity = 0.7
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTVC.identifier, for: indexPath) as! HomeTVC
        cell.selectionStyle = .none
        cell.nameL.text = selectedContacts[indexPath.row].name
        cell.phoneL.text = selectedContacts[indexPath.row].phoneNumber.first
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
        let cell = tableView.cellForRow(at: indexPath) as! AlertTVC
        if savedIndexForSelectedWeeks.contains(indexPath.row) {
            cell.checkB.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            while savedIndexForSelectedWeeks.contains(indexPath.row) {
                if let itemToRemoveIndex = savedIndexForSelectedWeeks.firstIndex(of: indexPath.row) {
                    savedIndexForSelectedWeeks.remove(at: itemToRemoveIndex)
                }
            }
        }else if !savedIndexForSelectedWeeks.contains(indexPath.row) {
            print(2)
            cell.checkB.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            savedIndexForSelectedWeeks.append(indexPath.row)
        }
    }
}


extension AlertVC:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.contetnViewBaseBottomConstraint.constant = 270
        DispatchQueue.main.async {
            print("ARIAN")
            self.scrollViewS.scrollToBottom(animated: true)
            
        }
        if textView.textColor == .link {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.contetnViewBaseBottomConstraint.constant = 15
        if textView.text.isEmpty {
            textView.text = """
                                    Type Here...
                                    """
            textView.textColor = UIColor.link
        }
    }
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

protocol selectedContactsTap {
    func tapContacts(array:[phoneContactAgain])
}
