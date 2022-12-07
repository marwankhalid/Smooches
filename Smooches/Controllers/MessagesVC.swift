//
//  MessagesVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/24/22.
//

import UIKit

class MessagesVC: UIViewController {

    @IBOutlet weak var newMessageB: UIButton!
    @IBOutlet weak var firstCircleV: UIView!
    @IBOutlet weak var secondCircleV: UIView!
    @IBOutlet weak var postsV: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var cell:MessageTVC?
    var index:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTabbar()
        setupTableView()
        
    }
    
    private func setupViews(){
        firstCircleV.layer.cornerRadius = firstCircleV.bounds.height / 2
        secondCircleV.layer.cornerRadius = secondCircleV.bounds.height / 2
        newMessageB.layer.cornerRadius = newMessageB.bounds.height / 2
        
    }
    
    public func setupTabbar(){
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
           
            self.tabBarController?.tabBar.standardAppearance = appearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
        }
    }

    @IBAction func newMessageB(_ sender: Any) {
        let cont = storyboard?.instantiateViewController(withIdentifier: "AlertVC") as! AlertVC
        cont.isModalInPresentation = true
        cont.modalPresentationStyle = .automatic
        self.present(cont, animated: true)
    }
}


extension MessagesVC:UITableViewDelegate,UITableViewDataSource {
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
        cell.selectionStyle = .none
        cell.editB.setTitle("", for: .normal)
        cell.recycleB.setTitle("", for: .normal)
        cell = self.setupExpirationLabel(cell: cell, indexpath: indexPath) as! MessageTVC
        //cell = self.setupDescriptionLabel(cell: cell, indexpath: indexPath) as! MessageTVC
        let more = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        cell.descriptionL.text = more
        cell.descriptionL.numberOfLines = 2
        cell.descriptionL.isUserInteractionEnabled = true
        let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 14)
        let readmoreFontColor = UIColor.orange
        DispatchQueue.main.async {
            cell.descriptionL.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
            cell.descriptionL.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapDescriptionLabel(gesture:))))
        }
        cell.contentVIeww.layer.cornerRadius = 10.0
        cell.contentVIeww.layer.shadowColor = UIColor.gray.cgColor
        cell.contentVIeww.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.contentVIeww.layer.shadowRadius = 1.0
        cell.contentVIeww.layer.shadowOpacity = 0.7
        return cell
    }
    
    private func setupDescriptionLabel(cell:MessageTVC,indexpath:IndexPath) -> UITableViewCell {
        cell.descriptionL.numberOfLines = 2
        cell.descriptionL.sizeToFit()
        cell.descriptionL.text = ""
        cell.descriptionL.textAlignment = .left
        let more = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. more"
        let less = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. less"
        let more1 = "more"
        let less1 = "less"
        cell.expirationTextL.textColor =  UIColor.white
        let underlineAttriString = NSMutableAttributedString(string: more)
        let range1 = (more as NSString).range(of: more1)
             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: range1)
        cell.descriptionL.attributedText = underlineAttriString
        cell.descriptionL.isUserInteractionEnabled = true
        cell.descriptionL.lineBreakMode = .byTruncatingMiddle

        cell.descriptionL.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapDescriptionLabel(gesture:))))
        self.index = indexpath.row
        return cell
    }
    
    @objc func tapDescriptionLabel(gesture:UITapGestureRecognizer) {
        //let cell = tableView.cellForRow(at: IndexPath(row: self.index!, section: 0)) as! MessageTVC
        let more = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Readmore"
        let termsRange = (more as NSString).range(of: "Readmore")
        let cell = tableView.cellForRow(at: IndexPath(row: self.index!, section: 0)) as! MessageTVC
        if gesture.didTapAttributedTextInLabel(label: cell.descriptionL, inRange: termsRange) {
            print("Tapped terms")
        }else {
            print("None")
        }
    }
    
    private func setupExpirationLabel(cell:MessageTVC,indexpath:IndexPath) -> UITableViewCell{
        let text = "This message will expire on 21 Nov 2022"
        let date = "21 Nov 2022"
        cell.expirationTextL.textColor =  UIColor.white
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: date)
             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range1)
        cell.expirationTextL.attributedText = underlineAttriString
        cell.expirationTextL.isUserInteractionEnabled = true
        cell.expirationTextL.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        self.index = indexpath.row
        return cell
    }
    
    
    @objc func tapLabel(gesture:UITapGestureRecognizer) {
        let text = "This message will expire on 21 Nov 2022"
        let termsRange = (text as NSString).range(of: "21 Nov 2022")
        let cell = tableView.cellForRow(at: IndexPath(row: self.index!, section: 0)) as! MessageTVC
        if gesture.didTapAttributedTextInLabel(label: cell.expirationTextL, inRange: termsRange) {
            print("Tapped terms")
        }
    }
    
    private func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}


extension UILabel {

        func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
            let readMoreText: String = trailingText + moreText

            let lengthForVisibleString: Int = self.vissibleTextLength
            let mutableString: String = self.text!
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
            let readMoreLength: Int = (readMoreText.count)
            let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }

        var vissibleTextLength: Int {
            let font: UIFont = self.font
            let mode: NSLineBreakMode = self.lineBreakMode
            let labelWidth: CGFloat = self.frame.size.width
            let labelHeight: CGFloat = self.frame.size.height
            let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                    }
                } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
            return self.text!.count
        }
}
