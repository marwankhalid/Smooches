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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTabbar()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
        cell.selectionStyle = .none
        cell.descriptionL.numberOfLines = 0
        cell.descriptionL.sizeToFit()
        cell.contentVIeww.layer.cornerRadius = 10.0
        cell.contentVIeww.layer.shadowColor = UIColor.gray.cgColor
        cell.contentVIeww.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.contentVIeww.layer.shadowRadius = 1.0
        cell.contentVIeww.layer.shadowOpacity = 0.7
        return cell
    }
    
    private func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
