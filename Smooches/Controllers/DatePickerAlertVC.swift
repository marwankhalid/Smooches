//
//  DatePickerAlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 12/8/22.
//

import UIKit

class DatePickerAlertVC: UIViewController {

    var pickerView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBackground
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
        timepicker.backgroundColor = .black
        timepicker.datePickerMode = UIDatePicker.Mode.time
        if #available(iOS 13.4, *) {
            timepicker.preferredDatePickerStyle = .wheels
        }
        return timepicker
    }()
    
    var delegate:tapTime?
    let startTime:Bool?
    let endTime:Bool?
    
    init(startTime: Bool?, endTime: Bool?) {
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.35)
        setupDatePicker()
        
    }
    
    private func setupDatePicker(){
        self.view.addSubview(self.pickerView)
        self.pickerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.pickerView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        self.pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
        ok.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: -30).isActive = true
        ok.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ok.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        cancel.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        ok.addTarget(self, action: #selector(tapOk), for: .touchUpInside)
        
        pickerView.layer.cornerRadius = 20
        //self.pickerView.alpha = 0
    }
    
    @objc func tapCancel(){
        self.dismiss(animated: true)
    }
    
    @objc func tapOk(){
        delegate?.tapTime(time: "", startTime: startTime! ? true :false, endTime: endTime! ? true :false)
        print("Hello")
        self.getDate(date: timePicker.date)
//        let picker = UIDatePicker()
//        picker.datePickerMode = .time
//
//        let date = picker.date
//        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//        let hour = components.hour!
//        let minute = components.minute!
    }

    func getDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: date)
        print(time)
    }
}
