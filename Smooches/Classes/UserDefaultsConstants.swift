//
//  UserDefaultsConstans.swift
//  Smooches
//
//  Created by Marwan Khalid on 11/28/22.
//

import UIKit

class UserDefaultsConstants {
    static public var contacts = "contacts"
    static public var contactsFlag = "contactsFlag"
    
    static public func getDataFromUserDefaults() -> [PhoneContact]?{
        if let savedPerson = UserDefaults.standard.object(forKey: UserDefaultsConstants.contacts) as? Data {
            let decoder = JSONDecoder()
            let model = try? decoder.decode([PhoneContact].self, from: savedPerson)
            return model
        }
        return nil
    }
    
    static public func savedDataToUserDefaults(model:[PhoneContact],key:String){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    
}

