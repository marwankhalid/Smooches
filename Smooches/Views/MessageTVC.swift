//
//  MessageTVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 12/7/22.
//

import UIKit

class MessageTVC: UITableViewCell {
    
    @IBOutlet weak var contentVIeww: UIView!
    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var descriptionL: UILabel!
    @IBOutlet weak var editB: UIButton!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var recycleB: UIButton!
    @IBOutlet weak var expirationTextL: UILabel!
    
    @IBAction func recycleB(_ sender: Any) {
        
    }
    
    @IBAction func editB(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
