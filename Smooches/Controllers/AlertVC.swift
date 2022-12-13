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
import CoreData


struct AlertModel {
    let id:Int64
    let reminderType:String
    let weekDays:String?
    let timeLimit:String?
    let startTime:String
    let endTime:String
    let time:String
    let date:String
    let selectedContacts:String
    let message1:String
    let message2:String
    let message3:String
    let message4:String
    let message5:String
    let randomMessage:String
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
    var delegate:reloadMessage?
    var editDataSource:AlertModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Week.data
        setupTableView()
        setHieghts()
        setupViews()
        setupText()
        editOrNewMessage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timeLimitL.alpha = 0
        selectDateT.alpha = 0
    }
    
    private func editOrNewMessage(){
        if !UserDefaults.standard.bool(forKey: "newMessage") {
            startTimeT.text = editDataSource?.startTime
            endTimeT.text = editDataSource?.endTime
            reminderTypeT.text = editDataSource?.reminderType
            messageT.text = editDataSource?.message1
            message2T.text = editDataSource?.message2
            message3T.text = editDataSource?.message3
            message4T.text = editDataSource?.message4
            message5T.text = editDataSource?.message5
            messageT.textColor = .label
            message2T.textColor = .label
            message3T.textColor = .label
            message4T.textColor = .label
            message5T.textColor = .label
            setSelectContacts()
        }
    }
    
    private func decodeSelectWeeks() ->[String]{
        if editDataSource?.weekDays == "" {
            return [String]()
        }
        let data = editDataSource?.weekDays!.components(separatedBy: ",")
        return data!
    }
    
    private func setSelectWeeks(){
        dataSource = [Week]()
        let arr =  decodeSelectWeeks()
    }
    
    private func decodeSelectContacts() ->[String]{
        if editDataSource?.selectedContacts == "" {
            return [String]()
        }
        let data = editDataSource?.selectedContacts.components(separatedBy: ",")
        return data!
    }
    
    private func setSelectContacts(){
        selectedContacts = [phoneContactAgain]()
        let arr =  decodeSelectContacts()
        for i in 0..<arr.count {
            let name = arr[i].components(separatedBy: "-")
            selectedContacts.append(phoneContactAgain(name: name[0], avatarData: nil, phoneNumber: [name[1]], email: [String]()))
        }
        addContactsTableView.reloadData()
        
        setHieghts()
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
        controller.selectContactsCounter = selectedContacts.count
        controller.editCheck = selectedContacts
        self.present(controller, animated: true)
    }
    
    @IBAction func submitB(_ sender: Any) {
        if checkStartTime() && checkEndTime() && (getSelectedContactsString() == "" ? false:true) && getMessages1() && getMessages2() && getMessages3() && getMessages4() && getMessages5() {
            print(getId())
            print(getWeekDaysString())
            print(startTimeT.text!)
            print(endTimeT.text!)
            print(reminderTypeT.text!)
            print(getTimeLimit())
            print(getSelectedContactsString())
            print(messageT.text!)
            print(message2T.text!)
            print(message3T.text!)
            print(message4T.text!)
            print(message5T.text!)
            let today = Date()
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "d MMM y"
            print(formatter3.string(from: today))
            let model = AlertModel(id: Int64(getId()), reminderType: reminderTypeT.text ?? "", weekDays: getWeekDaysString(), timeLimit: getTimeLimit(), startTime: startTimeT.text ?? "", endTime: endTimeT.text ?? "", time: Date.randomBetween(start: startTimeT.text ?? "", end: endTimeT.text ?? ""), date: formatter3.string(from: today) ,selectedContacts: getSelectedContactsString(), message1: messageT.text ?? "", message2: message2T.text ?? "", message3: message3T.text ?? "", message4: message4T.text ?? "", message5: message5T.text ?? "", randomMessage: chooseRandomlyFromMessagesOfArray())
            if UserDefaults.standard.bool(forKey: "newMessage") {
                createData(model: model)
            }else {
                updateData(model: model)
            }
            print(chooseRandomlyFromMessagesOfArray())
            self.dismiss(animated: true)
        }else {
            self.view.makeToast("Fill All ")
        }
    }
    
    func updateData(model:AlertModel){
    
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "AlertsSaved")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", editDataSource!.id.description)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let user = test[0] as! NSManagedObject
            user.setValue(model.id, forKeyPath: "id")
            user.setValue(model.startTime, forKey: "startTime")
            user.setValue(model.endTime, forKey: "endTime")
            user.setValue(model.time, forKey: "time")
            user.setValue(model.selectedContacts, forKey: "selectedContacts")
            user.setValue(model.date, forKey: "date")
            user.setValue(model.message1, forKey: "message1")
            user.setValue(model.message2, forKey: "message2")
            user.setValue(model.message3, forKey: "message3")
            user.setValue(model.message4, forKey: "message4")
            user.setValue(model.message5, forKey: "message5")
            user.setValue(model.timeLimit, forKey: "timeLimit")
            user.setValue(model.weekDays, forKey: "weekDays")
            user.setValue(model.reminderType, forKey: "reminderType")
            user.setValue(model.randomMessage, forKey: "randomMessage")
            
                do{
                    try managedContext.save()
                    self.delegate?.refresh(status: true)
                }
                catch
                {
                    self.view.makeToast("Error: Could Not Save")
                    print(error)
                }
            }
        catch
        {
            self.view.makeToast("Error: Could Not Save")
            print(error)
        }
   
    }
    
    private func addMessagesToArray() ->[String]{
        var data = [String]()
        data.append(messageT.text ?? "")
        data.append(message2T.text ?? "")
        data.append(message3T.text ?? "")
        data.append(message4T.text ?? "")
        data.append(message5T.text ?? "")
        return data
    }
    
    private func chooseRandomlyFromMessagesOfArray() ->String{
        return addMessagesToArray().randomElement() ?? ""
    }
    
    func createData(model:AlertModel){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "AlertsSaved", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(model.id, forKeyPath: "id")
        user.setValue(model.startTime, forKey: "startTime")
        user.setValue(model.endTime, forKey: "endTime")
        user.setValue(model.time, forKey: "time")
        user.setValue(model.selectedContacts, forKey: "selectedContacts")
        user.setValue(model.date, forKey: "date")
        user.setValue(model.message1, forKey: "message1")
        user.setValue(model.message2, forKey: "message2")
        user.setValue(model.message3, forKey: "message3")
        user.setValue(model.message4, forKey: "message4")
        user.setValue(model.message5, forKey: "message5")
        user.setValue(model.timeLimit, forKey: "timeLimit")
        user.setValue(model.weekDays, forKey: "weekDays")
        user.setValue(model.reminderType, forKey: "reminderType")
        user.setValue(model.randomMessage, forKey: "randomMessage")
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            self.delegate?.refresh(status: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            self.view.makeToast("Could not save.")
        }
    }
    
    private func getId() ->Int{
        var id = UserDefaults.standard.integer(forKey: "id")
        id += 1
        UserDefaults.standard.set(id, forKey: "id")
        return id
    }
    
    private func checkStartTime() ->Bool{
        let currentDate = Date()
        if self.startTime == nil {
            return false
        }
        if currentDate < self.startTime! {
            return true
        }else {
            return false
        }
    }
    
    private func checkEndTime() ->Bool{
        if self.endTime == nil  {
            return false
        }
        if self.startTime == nil {
            return false
        }
        if self.startTime! < self.endTime! {
            return true
        }else {
            return false
        }
    }
                                  
    private func getWeekDaysString() ->String{
        if self.savedIndexForSelectedWeeks.count == 0 {
            return ""
        }
        let converted = savedIndexForSelectedWeeks.map{String($0)}.joined(separator: ",")
        return converted
    }
    
    private func getTimeLimit() ->String{
        if reminderTypeT.text == dropDownDataSource[1] {
            return self.selectDateT.text!
        }
        
        if reminderTypeT.text == dropDownDataSource[2] {
            return self.selectDateT.text!
        }
        return ""
    }
    
    private func getSelectedContactsString() ->String{
        var result = ""
        if selectedContacts.count == 0 {
            return result
        }else {
            for i in 0..<selectedContacts.count {
                result.append("\(selectedContacts[i].name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No Name")-\(selectedContacts[i].phoneNumber.first?.trimmingCharacters(in: .whitespaces) ?? "No Phone Number")\(i == selectedContacts.count - 1 ? "":",")")
            }
            return result
        }
    }
    
    private func getMessages1() -> Bool{
        if messageT.text == "Type Here..." {
            messageT.layer.borderColor = UIColor.red.cgColor
            return false
        }else if messageT.text == "" {
            messageT.layer.borderColor = UIColor.red.cgColor
            return false
        }else {
            messageT.layer.borderColor = UIColor.link.cgColor
            return true
        }
    }
    
    private func getMessages2() -> Bool{
        if message2T.text == "Type Here..." {
            message2T.layer.borderColor = UIColor.red.cgColor
            return false
        }else if message2T.text == "" {
            message2T.layer.borderColor = UIColor.red.cgColor
            return false
        }else {
            message2T.layer.borderColor = UIColor.link.cgColor
            return true
        }
    }
    
    private func getMessages3() -> Bool{
        if message3T.text == "Type Here..." {
            message3T.layer.borderColor = UIColor.red.cgColor
            return false
        }else if message3T.text == "" {
            message3T.layer.borderColor = UIColor.red.cgColor
            return false
        }else {
            message3T.layer.borderColor = UIColor.link.cgColor
            return true
        }
    }
    
    private func getMessages4() -> Bool{
        if message4T.text == "Type Here..." {
            message4T.layer.borderColor = UIColor.red.cgColor
            return false
        }else if message4T.text == "" {
            message4T.layer.borderColor = UIColor.red.cgColor
            return false
        }else {
            message4T.layer.borderColor = UIColor.link.cgColor
            return true
        }
    }
    
    private func getMessages5() -> Bool{
        if message5T.text == "Type Here..." {
            message5T.layer.borderColor = UIColor.red.cgColor
            return false
        }else if message5T.text == "" {
            message5T.layer.borderColor = UIColor.red.cgColor
            return false
        }else {
            message5T.layer.borderColor = UIColor.link.cgColor
            return true
        }
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
            
            if decodeSelectWeeks().contains(where: {$0 == indexPath.row.description}) {
                cell.checkB.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            }else {
                cell.checkB.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            
            
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
