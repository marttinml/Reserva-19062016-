//
//  WSparce.swift
//  ApartaSalas
//
//  Created by Ivan Tzicuri De la luz Escalante on 14/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//


import Foundation


class XMLParcer: NSObject,NSURLConnectionDataDelegate,NSXMLParserDelegate
{
    var dataResponse:NSMutableData = NSMutableData()
    var attributeAccepted:Bool = false
    var dictionaryStack = NSMutableArray()
    var error = NSError(domain: "", code: 0, userInfo: nil)
    var textInProgress:String = String()
    let kXMLReaderTextNodeKey = "text"
    var sLog:String = String()
    var sURLService:String = String()
    var iTimeOut:Int = 60
    var parentDict:NSMutableDictionary = NSMutableDictionary()
    
    override init()
    {
        super.init()
        
        self.iTimeOut = GlobalConstants.KTimeOut
        
        if iTimeOut <= 0
        {
            iTimeOut = 60
        }
    }
    
    func callWebService(request: String) -> AnyObject
    {
        if GlobalConstants.KPrintXMLParcerResponse
        {
            print("\n************\n")
            print("SOLICITUD WS")
            print("\n************\n")
            print(request)
        }
        
        var dResponse = NSMutableDictionary ()
        
        
        let url = NSURL(string: self.sURLService)
        
        let data:NSData = (request as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        
        let timeOut:NSTimeInterval = NSTimeInterval(iTimeOut)
        
        let peticion = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: timeOut)
        
        peticion.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        peticion.setValue(String(format: "%i",data.length), forHTTPHeaderField:"Content-Length")
        peticion.HTTPMethod = "POST"
        peticion.HTTPBody = data
        peticion.addValue("14.14.0.1", forHTTPHeaderField: "REMOTE_ADDR")
        peticion.addValue("14.14.0.1", forHTTPHeaderField: "X-Forwarded-For")
        
        print(peticion.allHTTPHeaderFields)
        
        if Utilerias.netStatus() == Reachability.NetworkStatus.NotReachable
        {
            dResponse.setObject(NSLocalizedString("Conexion_a_internet_desconectada", comment: "Mensaje de error por datos"), forKey: GlobalConstants.KErrorSinConexion)
            return dResponse
        }
        
        
        //let connection:NSURLConnection
        //connection = NSURLConnection(request: peticion, delegate: self, startImmediately: true)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(peticion, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")})
        
        task.resume()
        
       // connection.start()
       // CFRunLoopRun()
        
//        let resp:AnyObject = dictionaryStack[0]
//        
//        if resp is NSMutableDictionary
//        {
//            dResponse = resp as! NSMutableDictionary
//            
//            if dResponse.objectForKey("soap:Body") == nil {
//                dResponse.setObject(NSLocalizedString("Error_web_service", comment: "Lo sentimos, la transacción no pudo ser completada"), forKey: GlobalConstants.KErrorWS)
//            }
//        }
//        else
//        {
//            dResponse.setObject(NSLocalizedString("Error_web_service", comment: "Lo sentimos, la transacción no pudo ser completada"), forKey: GlobalConstants.KErrorWS)
//        }
        
        return dResponse
    }
    
    //MARK: -
    //MARK: - Public methods
    
    func dictionaryForPath(path:String,attributeAccepted:Bool, error:NSError) -> NSDictionary
    {
        return dictionaryForPath(path, attributeAccepted: attributeAccepted, error: error)
    }
    
    func dictionaryForXMLString(xmlString:String , attributeAccepted:Bool,error:NSError) -> NSDictionary
    {
        let lines:[AnyObject] = xmlString.componentsSeparatedByString("\n")
        var strData:String = String()
        
        for caracter in lines
        {
            strData += caracter.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        return dictionaryForXMLData(strData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)!, attributeAccepted: attributeAccepted, error: error)
    }
    
    func dictionaryForXMLData(data:NSData,attributeAccepted:Bool,error:NSError) -> NSDictionary
    {
        return objectWithData(data, attributeAccepted: attributeAccepted, error: error)
    }
    
    //MARK: -
    //MARK: - Parsing
    
    func objectWithData(data:NSData, attributeAccepted:Bool, error:NSError?) -> NSDictionary
    {
        let reader:XMLParcer = XMLParcer()
        reader.attributeAccepted = attributeAccepted
        
        let parser:NSXMLParser = NSXMLParser(data: data)
        parser.delegate = reader
        
        if parser.parse()
        {
            return reader.dictionaryStack[0] as! NSDictionary
        }
        
        return NSDictionary()
    }
    //MARK: -
    //MARK: - NSXMLParserDelegate methods
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        dataResponse.length = 0;
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
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
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
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
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        textInProgress += string
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError)
    {
    }
    //MARK: -
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        dataResponse.appendData(data)
    }
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool
    {
        return protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
    }
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge)
    {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
        {
            if challenge.protectionSpace.host == sURLService
            {
                let credentials = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
                challenge.sender!.useCredential(credentials, forAuthenticationChallenge: challenge)
            }
        }
        
        challenge.sender!.continueWithoutCredentialForAuthenticationChallenge(challenge)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        if GlobalConstants.KPrintXMLParcerResponse
        {
            let sResponse:NSString = NSString(data: dataResponse, encoding: NSUTF8StringEncoding)!
            
            print("\n************\n")
            print("RESPUESTA WS")
            print("\n************\n")
            print(sResponse)
        }
        
        
        let parser: NSXMLParser = NSXMLParser(data: dataResponse)
        parser.delegate = self
        parser.shouldResolveExternalEntities = true
        parser.parse()
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        dictionaryStack.removeAllObjects()
        dictionaryStack.addObject(error.localizedDescription)
    }
    
    static func parceaJsonResponse(sResponse:String)->NSDictionary
    {
        var jsonResponse:AnyObject? = nil
        do
        {
            let jsonData: NSData = sResponse.dataUsingEncoding(NSUTF8StringEncoding)!
            
            jsonResponse = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
        }
        catch let error as NSError
        {
            print(error)
        }
        catch
        {
            
        }
        return jsonResponse as! NSDictionary
        
    }
    
    static func generaJson(datos:NSDictionary)->String
    {
        let aLlaves:NSArray = datos.allKeys
        var sJSonFormat:String = "{"
        var iTotal:Int = 0
        
        for llave in aLlaves
        {
            
            let sLlave:String = (llave as! String) as String
            let sValue:String = datos.objectForKey(sLlave) as! String
            
            if (iTotal < (datos.count - 1))
            {
                sJSonFormat = sJSonFormat + "'" + sLlave + "':'" + sValue + "',"
            }
            else
            {
                sJSonFormat = sJSonFormat + "'" + sLlave + "':'" + sValue + "'"
            }
            
            iTotal = iTotal + 1
        }
        
        sJSonFormat = sJSonFormat + "}"
        
        let sTemp = sJSonFormat.stringByReplacingOccurrencesOfString("'{", withString: "{")
        sJSonFormat = sTemp.stringByReplacingOccurrencesOfString("}'", withString: "}")
        
        return sJSonFormat;
    }
}

