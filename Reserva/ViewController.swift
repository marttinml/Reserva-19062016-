//
//  ViewController.swift
//  ApartaSalas
//
//  Created by Ivan Tzicuri De la luz Escalante on 14/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedContext:NSManagedObjectContext!
    var logItems = [Reserva]()
    @IBOutlet weak var btnEliminar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
//        let items = [
//            ("Best Animal", "Dog"),
//            ("Best Language","Swift"),
//            ("Worst Animal","Cthulu"),
//            ("Worst Language","LOLCODE")
//        ]
        
//        //for (itemTitle, itemText) in items {
//        for(var i:Int=0;i<50;++i)
//        {
//            let currentDateTime = NSDate()
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'z'"
//            //dateFormatter.timeZone = NSTimeZone(name: "UTC")
//            let date = dateFormatter.stringFromDate(currentDateTime)
//            
//            //Reserva.crearRegistros(managedContext, title:date , text: date)
//        }
        
        
        //let newItem = NSEntityDescription.insertNewObjectForEntityForName("Donas", inManagedObjectContext: managedContext) as! Donas
        
        //newItem.jesus="testerman 1"
        //newItem.pelas="testerman 2"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        obtener()
        var d:Int=0
        for logItem in logItems
        {
            print(d)
            if let constantName = logItem.fechainicioS {
                print(constantName)
            }
            if let constantName2 = logItem.fechafinS {
                print(constantName2)
            }
            d++
        }
        
    }
    
    
    //    override func viewDidAppear(animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        let fetchRequest = NSFetchRequest(entityName: "Donas")
    //        do{
    //            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [Donas] {
    //
    //
    //                let alert = UIAlertController(title: fetchResults[0].jesus,
    //                    message: fetchResults[0].pelas,
    //                    preferredStyle: .Alert)
    //
    //
    //                self.presentViewController(alert,
    //                    animated: true,
    //                    completion: nil)
    //            }
    //        }
    //        catch{
    //        }
    //
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func obtener() {
        let fetchRequest = NSFetchRequest(entityName: "Reserva")
        
        //let predicate = NSPredicate(format: "pelas contains %@", "Best")
        
        
        
        //let firstPredicate = NSPredicate(format: "pelas == %@", "Best Language")
        
        //let thPredicate = NSPredicate(format: "pelas contains %@", "Worst")
        
        //let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [firstPredicate, thPredicate])
        
        //fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "idreserva", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Reserva] {
                logItems = fetchResults
            }
        }
        catch{
        }
        
    }
    
    
    @IBAction func eliminar(sender: AnyObject) {
        
        managedContext.deleteObject(logItems[0])
        
    }
    
    
}

