//
//  Identifiers.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/28/22.
//

import UIKit

extension UIViewController {
    static var identifier:String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier:String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier:String {
        return String(describing: self)
    }
}


