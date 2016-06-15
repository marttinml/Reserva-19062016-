//
//  Utilerias.swift
//  ApartaSalas
//
//  Created by Ivan Tzicuri De la luz Escalante on 14/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

class Utilerias: NSObject {
    
    static func netStatus()-> Reachability.NetworkStatus
    {
        let reachability: Reachability
        var status:Reachability.NetworkStatus! = Reachability.NetworkStatus.NotReachable
        
        do
        {
            reachability = try Reachability.reachabilityForInternetConnection()
            reachability.currentReachabilityStatus
            status = reachability.currentReachabilityStatus
        }
        catch
        {
            status = Reachability.NetworkStatus.ReachableViaWWAN
        }
        
        return status
    }
    
    func savenuevo(newArray:AnyObject,nombre:String) {
        
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(newArray);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as! NSString;
        let path = documentsDirectory.stringByAppendingPathComponent(nombre+".plist");
        print(path)
        saveData.writeToFile(path, atomically: true);
    }
    
    func existeNuevo(nombre:String)->Bool{
        var ex:Bool=true
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent(nombre+".plist")
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path) {
            ex=false
            
        }
        return ex
    }
    
    func leernuevo(nombre:String)->AnyObject {
        
        var scoreArray:AnyObject!
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent(nombre)
        
        if let rawData = NSData(contentsOfFile: path) {
            
            scoreArray = NSKeyedUnarchiver.unarchiveObjectWithData(rawData)!;
            
        }
        
        return scoreArray
    }
}