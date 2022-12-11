//
//  DeleteAlertVC.swift
//  Smooches
//
//  Created by Marwan Khalid on 12/8/22.
//

import UIKit
import CoreData
import Toast_Swift

class DeleteAlertVC: UIViewController {
    
    @IBOutlet weak var alertV: UIView!
    @IBOutlet weak var yesB: UIButton!
    @IBOutlet weak var noB: UIButton!
    
    
    var delegate:reloadMessage?
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yesB.layer.cornerRadius = yesB.bounds.height / 2
        alertV.layer.cornerRadius = 10.0
        alertV.layer.shadowColor = UIColor.gray.cgColor
        alertV.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        alertV.layer.shadowRadius = 1.0
        alertV.layer.shadowOpacity = 0.7
        
    }

    @IBAction func yesB(_ sender: Any) {
        deleteData()
        self.dismiss(animated: true)
    }
    
    @IBAction func noB(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func deleteData(){
       
       //As we know that container is set up in the AppDelegates so we need to refer that container.
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       
       //We need to create a context from this container
       let managedContext = appDelegate.persistentContainer.viewContext
       
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlertsSaved")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(self.id ?? "")")
      
       do
       {
           let test = try managedContext.fetch(fetchRequest)
           
           let objectToDelete = test[0] as! NSManagedObject
           managedContext.delete(objectToDelete)
           do{
               try managedContext.save()
               self.view.makeToast("Delete Data")
           }
           catch
           {
               self.view.makeToast("Can't Delete Data")
               print(error)
           }
           
       }
       catch
       {
           self.view.makeToast("Can't Delete Data")
           print(error)
       }
   }
    
    
}
