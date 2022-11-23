//
//  HomeTVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/23/22.
//

import UIKit

class HomeTVC: UITableViewCell {

    @IBOutlet weak var cardV: UIView!
    @IBOutlet weak var imgI: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var phoneL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
