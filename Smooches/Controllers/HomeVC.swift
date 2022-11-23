//
//  HomeVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/23/22.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    @IBAction func refreshB(_ sender: Any) {
        
    }
    
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        cell.imgI.layer.cornerRadius = cell.imgI.bounds.height / 2
        return cell
    }
}
