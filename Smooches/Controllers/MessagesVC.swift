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
