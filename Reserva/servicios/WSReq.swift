//
//  WSReq.swift
//  miAT&TWeb
//
//  Created by Ivan Tzicuri De la luz Escalante on 24/02/16.
//  Copyright © 2016 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import UIKit

class WSReq:NSObject,NSXMLParserDelegate {
    
    var elementValue: String?
    var success = false
    var dicMut:NSMutableArray=NSMutableArray()
    var recordingElementValue:Bool=false
    var dictionaryStack = NSMutableArray()
    var textInProgress:String = String()
    let kXMLReaderTextNodeKey = "text"
    var URLSer: String = "https://www.services.iusacell.com.mx/miIusacell/services/miIusacellService"
    var text=""
    
    var currentTask:NSURLSessionTask?
    
    func llamarWS(soapReq:NSString,completion: (NSDictionary) -> ()) {
        
            dictionaryStack=NSMutableArray()

            let lobj_Request = NSMutableURLRequest(URL: NSURL(string: URLSer)!)
            lobj_Request.HTTPMethod = "POST"
            lobj_Request.HTTPBody = soapReq.dataUsingEncoding(NSUTF8StringEncoding)
            lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            lobj_Request.addValue(String(soapReq.length), forHTTPHeaderField: "Content-Length")
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.timeoutIntervalForRequest = inmut.timeOut
            //config.timeoutIntervalForResource = inmut.timeOut
            
            let session = NSURLSession(configuration: config)
            //let session = NSURLSession.sharedSession()
        
        
        
            self.currentTask = session.dataTaskWithRequest(
                lobj_Request,
                completionHandler: { data, response, error -> Void in
                    
                    if inmut.imprime {
                        print("Request:")
                        print(soapReq)
                        print("Response: \(response)")
                        
                    }
                    
                    if data != nil{
                        if inmut.imprime{
                        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print(strData)
                        }
                        let parser = NSXMLParser(data:data!)
                        parser.delegate = self
                        parser.parse()
                    }
                    else{
                        let dicFake:NSDictionary=NSDictionary()
                        completion(dicFake)
                    }
                    if error != nil {
                        //print("error=\(error)")
                        //return
                        let temdicg:NSDictionary=NSDictionary()
                        completion(temdicg)
                    } else {
                        completion(self.dictionaryStack[0] as! NSDictionary)
                    }
            })
            self.currentTask!.resume()

    }
    
    func cancelarLlamadaWS() {
        self.currentTask?.cancel()
    }
    
    func generaTokenSeguridadWSParaDN(dn:NSString)->NSString{
        
        var sToken:NSString=NSString()
        
        sToken=NSString(format: "%@%@", getStringFromNowDateWithFormat("ddMMyyyyHHmm"),dn)
        
        return sToken
        
    }
    
    func getStringFromNowDateWithFormat(formato:NSString)->NSString{
        
        var fecha:NSString=NSString()
        let loc:NSLocale=NSLocale(localeIdentifier: "es_ES")
        let dateFormatter:NSDateFormatter=NSDateFormatter()
        let timeZone:NSTimeZone=NSTimeZone(name: "UTC")!
        dateFormatter.timeZone=timeZone
        dateFormatter.dateFormat=formato as String
        dateFormatter.locale=loc
        fecha=dateFormatter.stringFromDate(NSDate())
        return fecha
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        let parentDict: NSMutableDictionary? = dictionaryStack.lastObject as? NSMutableDictionary
        let childDict:NSMutableDictionary = NSMutableDictionary()
        
        let existingValue: AnyObject? = parentDict?.objectForKey(elementName)
        
        if (existingValue != nil)
        {
            var array = NSMutableArray()
            if existingValue is NSMutableArray
            {
                array = existingValue as! NSMutableArray
            }
            else
            {
                array.addObject(existingValue!)
                parentDict?.setObject(array, forKey: elementName)
            }
            
            array.addObject(childDict)
        }
        else
        {
            parentDict?.setObject(childDict, forKey: elementName)
        }
        
        dictionaryStack.addObject(childDict)
        
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        textInProgress += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        let dictInProgress: NSMutableDictionary? = dictionaryStack.lastObject as? NSMutableDictionary
        if dictionaryStack.count > 1
        {
            dictionaryStack.removeLastObject()
        }
        if textInProgress.characters.count > 0
        {
            if dictInProgress?.count > 0
            {
                dictInProgress?.setObject(textInProgress, forKey: kXMLReaderTextNodeKey)
            }
            else
            {
                let parentDict: NSMutableDictionary? = dictionaryStack.lastObject as? NSMutableDictionary
                
                let parentObject:AnyObject? = parentDict?.objectForKey(elementName)
                
                if parentObject is NSArray
                {
                    parentObject?.removeLastObject()
                    parentObject?.addObject(textInProgress)
                }
                else
                {
                    parentDict?.removeObjectForKey(elementName)
                    parentDict?.setObject(textInProgress, forKey: elementName)
                }
            }
            textInProgress = String()
        }
        else if dictInProgress?.count == 0
        {
            let parentDict: NSMutableDictionary? = dictionaryStack.lastObject as? NSMutableDictionary
            parentDict?.removeObjectForKey(elementName)
        }
        
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("Error: \(parseError)")
    }
    
    
    
}
