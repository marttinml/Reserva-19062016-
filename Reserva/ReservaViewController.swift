//
//  ReservaViewController.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 14/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import UIKit
import CoreData

class ReservaViewController: UIViewController ,UIWebViewDelegate,respempleadosProtocolo{
    
    var managedContext:NSManagedObjectContext!
    var coord:NSPersistentStoreCoordinator!
    var logItems = [Reserva]()
    var EmpItems = [Empleados]()
    var servEmp:WSEmpleados=WSEmpleados()
    var cons:constantes=constantes.sharedInstance
    var servMail:servicioMail=servicioMail()
    @IBOutlet weak var tewb: UIWebView!
    var jsonGlobal: NSDictionary=NSDictionary()
    let utils:Utilerias=Utilerias()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        coord=appDelegate.persistentStoreCoordinator
        let url = NSBundle.mainBundle().pathForResource("index", ofType: "html", inDirectory: "sala")
        let requestURL = NSURL(string:url!)
        let request = NSURLRequest(URL: requestURL!)
        tewb?.delegate=self
        tewb?.scrollView.bounces=false
        tewb!.loadRequest(request)
        tewb.keyboardDisplayRequiresUserAction = false
        cons.primeravez=true
        //        let startOfToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        //        let formatter = NSDateFormatter()
        //        formatter.dateFormat="yyyy-MM-dd"
        //        print(formatter.stringFromDate(startOfToday))
        servEmp.empleadosDelegate=self
        NSTimer.scheduledTimerWithTimeInterval(3600, target: self, selector: "actualizarEmp", userInfo: nil, repeats: true)
        //crearempPrimeraView()
        //leerJSON()
        //createCoredata()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        if(request.URL?.absoluteString.rangeOfString("cargarres:") != nil){
            obtener()
            cargaRes("todos")
            return false
        }
        if(request.URL?.absoluteString.rangeOfString("cargarresxdia:") != nil){
            let fdsa:NSString=((request.URL?.absoluteString)?.componentsSeparatedByString("cargarresxdia:").last)!.stringByRemovingPercentEncoding!
            obtenerResxDia(fdsa as String)
            
            if(cons.primeravez){
                dispatch_async(dispatch_get_main_queue()) {
                    self.tewb?.stringByEvaluatingJavaScriptFromString("openspin('\(inmut.textoActualizando)')")
                }
                getEmpleados()
                cons.primeravez=false
            }
            else{
                dispatch_async(dispatch_get_main_queue()) {
                    self.tewb?.stringByEvaluatingJavaScriptFromString("closespin()")
                }
            }
            
            return false
        }
        if(request.URL?.absoluteString.rangeOfString("eliminarres:") != nil){
            let fdsa:NSString=((request.URL?.absoluteString)?.componentsSeparatedByString("eliminarres:").last)!.stringByRemovingPercentEncoding!
            eliminar(fdsa as String)
            return false
        }
        if(request.URL?.absoluteString.rangeOfString("predictivo:") != nil){
            let fdsa:NSString=((request.URL?.absoluteString)?.componentsSeparatedByString("predictivo:").last)!.stringByRemovingPercentEncoding!
            predicEmp(fdsa as String)
            return false
        }
        if(request.URL?.absoluteString.rangeOfString("datoscancelar:") != nil){
            
            let fdsa:NSString = ((request.URL?.absoluteString)?
                .componentsSeparatedByString("datoscancelar:").last)!
                .stringByRemovingPercentEncoding!
            
            obtenerResxID(fdsa as String)
            return false
        }
        if(request.URL?.absoluteString.rangeOfString("cargarresxrango:") != nil){
            let fdsa:NSString=((request.URL?.absoluteString)?.componentsSeparatedByString("cargarresxrango:").last)!.stringByRemovingPercentEncoding!
            
            obtenerResxRango(fdsa.componentsSeparatedByString(",").first!, fechafin: fdsa.componentsSeparatedByString(",").last!)
            return false
        }
        if(request.URL?.absoluteString.rangeOfString("reservac:") != nil){
            let fdsa:NSString=((request.URL?.absoluteString)?.componentsSeparatedByString("reservac:").last)!.stringByRemovingPercentEncoding!
            
            let arr:NSMutableArray = parseodelJson(fdsa as String)["reserva"] as! NSMutableArray
            var rsid:Int=Int()
            var tinicio:String=String()
            var tfin:String=String()
            var nom:String=String()
            var idemp:Int=Int()
            var foto:String=String()
            var color:String=String()
            var mail:String=String()
            var hora:Int=Int()
            var motivo:String=String()
            
            var date:NSDate=NSDate()
            var date2:NSDate=NSDate()
            var hrinicio:String=String()
            var hrfin:String=String()
            var mtarr:NSArray=NSArray()
            
            for(var i:Int=0;i<arr.count;++i){
                
                rsid=Int(arr[i]["reservaId"] as! String)!
                tinicio=arr[i]["timeStart"] as! String
                tfin=arr[i]["timeEnd"] as! String
                nom=arr[i]["reservedBy"] as! String
                idemp=Int(arr[i]["employeeId"] as! String)!
                foto=arr[i]["picture"] as! String
                color=arr[i]["color"] as! String
                mail=arr[i]["mail"] as! String
                hora=Int(arr[i]["hora"] as! String)!
                //motivo
                motivo=arr[i]["motivo"] as! String
                
                //
                
                
                
                
                date = obtenerFechaFormatead(arr[i]["timeStart"] as! String)
                date2 = obtenerFechaFormatead(arr[i]["timeEnd"] as! String)
                
                if (i == 0){
                    mtarr = obtenerDiasF(date)
                    hrinicio=obternerHrs(arr[i]["timeStart"] as! String)
                }
                if(i==arr.count-1){
                    hrfin=obternerHrs(arr[i]["timeEnd"] as! String)
                }
                
                print("horas-------------------->>>>>>>>>>>>>>>>>>>>")
                print(tinicio)
                print(tfin)
                print("Parcer------------------->>>>>>>>>>>>>>>>>>>>>");
                print(hrinicio)
                print(hrfin)
                
                
                Reserva.crearRegistros(managedContext, idreserva: NSNumber(integer:rsid), fechainicioS: tinicio,fechainicioD:date, fechafinS: tfin,fechafinD:date2, nombre: nom, idempleado: NSNumber(integer:idemp), foto: foto,color:color,mail:mail,hora:NSNumber(integer:hora),motivo: motivo)
                
            }
            
            
            let fetchRequest = NSFetchRequest(entityName: "Empleados")
            
            let predicate = NSPredicate(format: "idempleado == %@",String(idemp))
            
            fetchRequest.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            var temempactmail=[Empleados]()
            do{
                if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Empleados] {
                    temempactmail = fetchResults
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            let ctem=temempactmail.first?.correo
            
            if(ctem != mail){
                temempactmail.first?.correo=mail
            }
            temempactmail.first?.updtcorreo=false
            
            persisGuardar()
            
            var mismocorreo:Bool=false
            if(mail.uppercaseString==inmut.copiacorreo.uppercaseString){
                mismocorreo=true
            }
            
            
            //if(mail != ""){
            let mens:String=String(rsid)
            
            servMail.loginService(nom, email: mail, codigo: mens, diaNombre: mtarr[0] as! String, dia: mtarr[1] as! String, mes: mtarr[2] as! String, hrin: hrinicio.componentsSeparatedByString(",").first!, hrfin: hrfin.componentsSeparatedByString(",").first!, hriampm: hrinicio.componentsSeparatedByString(",").last!, hrfampm: hrfin.componentsSeparatedByString(",").last!, cancela: false,mismocorreo: mismocorreo)
            
            
            //}
            
            
            
            return false
        }
        
        return true
        
    }
    
    func obtenerFechaFormatead(fec:String)->NSDate{
        var fechaf:NSDate=NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        fechaf=dateFormatter.dateFromString((fec).componentsSeparatedByString("T").first!)!
        return fechaf
        
    }
    
    func obternerHrs(hrs:String)->String{
        var retstr:String=String()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'z'"
        
        if let date = dateFormatter.dateFromString(hrs) {
            dateFormatter.dateFormat = "h:mm,a"
            retstr = dateFormatter.stringFromDate(date)
            
        }
        
        return retstr
    }
    
    func persisGuardar(){
        do{
            try managedContext.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func leerJSON(){
        if let path = NSBundle.mainBundle().pathForResource("empleados", ofType: "txt"){
            
            
            var jsonData:NSData=NSData()
            do
            {
                jsonData = try NSData(contentsOfFile: path,options: NSDataReadingOptions.DataReadingMapped)
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            do
            {
                if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                {
                    jsonGlobal=jsonResult
                    
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func predicEmp(filt:String){
        let arrnew:NSMutableArray=NSMutableArray()
        var allInfoRawSwift = ["filtrados": arrnew]
        
        //        var fullNames:AnyObject!
        
        //        if let empleados : NSArray = jsonGlobal["empleados"] as? NSArray
        //        {
        //            let resultPredicate = NSPredicate(format: "FCNOMBRECOMPLETO contains %@ OR FIEMPLEADOID contains %@", filt.uppercaseString,filt.uppercaseString)
        //            let filtrados = empleados.filteredArrayUsingPredicate(resultPredicate) as NSArray
        //            arrnew = (filtrados.mutableCopy() as! NSMutableArray)
        //            fullNames = arrnew.map({ ["employeeId" :($0["FIEMPLEADOID"] as? String)!, "reservedBy": ($0["FCNOMBRECOMPLETO"] as? String)!,"mail" :($0["FCCORREO"] as? String)!] })
        //            let g:NSMutableArray=fullNames.mutableCopy() as! NSMutableArray
        //            //let sortDescriptor = NSSortDescriptor(key: "reservedBy", ascending: true)
        //            //g.sortedArrayUsingDescriptors([sortDescriptor])
        //            allInfoRawSwift = ["filtrados": g]
        //        }
        
        if (filt.characters.count>=3){
            let fetchRequest = NSFetchRequest(entityName: "Empleados")
            
            var predicate = NSPredicate()
            
            if isNumeric(filt){
                predicate = NSPredicate(format: "idempleado BEGINSWITH %@",filt)
            }
                
            else{
                predicate = NSPredicate(format: "nombre Contains[cd] %@", filt.uppercaseString)
            }
            
            fetchRequest.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do{
                if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Empleados] {
                    EmpItems = fetchResults
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            var arrtemp:NSMutableDictionary!
            var empnumero:String=String()
            for(var i:Int=0;i<EmpItems.count;++i){
                arrtemp=NSMutableDictionary()
                empnumero=String(EmpItems[i].idempleado!)
                arrtemp["employeeId"]=empnumero
                arrtemp["reservedBy"]=EmpItems[i].nombre
                let up=EmpItems[i].updtcorreo
                if(up==0){
                    arrtemp["mail"]=EmpItems[i].correo
                }
                else{
                    arrtemp["mail"]=""
                }
                if(empnumero=="393451"){
                
                    arrtemp["motivo"]=inmut.motivoGlob
                    
                }
                
                arrnew.addObject(arrtemp)
            }
            
            allInfoRawSwift = ["filtrados": arrnew]
        }
        
        tewb?.stringByEvaluatingJavaScriptFromString("resultEmployee('\(serializaJSON(allInfoRawSwift))')")
    }
    
    func parseodelJson(fdsa:String)->NSDictionary{
        let data = (fdsa as String).dataUsingEncoding(NSUTF8StringEncoding)
        var sentData:NSDictionary=NSDictionary()
        do
        {
            sentData = try (NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return sentData
    }
    
    func serializaJSON(obj:AnyObject)->NSString
    {
        
        var allInfoJSONString:NSString!
        do {
            let allInfoJSON = try NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions(rawValue: 0))
            allInfoJSONString = NSString(data: allInfoJSON, encoding: NSUTF8StringEncoding)!
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        return allInfoJSONString
        
    }
    
    func cargaRes(accion:String){
        
        let arrnew:NSMutableArray=NSMutableArray()
        
        var arrtemp:NSMutableDictionary!
        for(var i:Int=0;i<logItems.count;++i){
            arrtemp=NSMutableDictionary()
            
            arrtemp["reservaId"]=String(logItems[i].idreserva!)
            arrtemp["timeStart"]=logItems[i].fechainicioS
            arrtemp["timeEnd"]=logItems[i].fechafinS
            arrtemp["reservedBy"]=logItems[i].nombre
            arrtemp["employeeId"]=String(logItems[i].idempleado!)
            arrtemp["picture"]=logItems[i].foto
            arrtemp["color"]=logItems[i].color
            arrtemp["mail"]=logItems[i].mail
            arrtemp["hora"]=String(logItems[i].hora)
            arrtemp["motivo"]=logItems[i].motivo
            
            arrnew.addObject(arrtemp)
        }
        
        let allInfoRawSwift = ["reservas": arrnew]
        
        if(accion=="todos"){
            tewb?.stringByEvaluatingJavaScriptFromString("cargres('\(serializaJSON(allInfoRawSwift))')")
        }
        if(accion=="dia"){
            tewb?.stringByEvaluatingJavaScriptFromString("cargresdia('\(serializaJSON(allInfoRawSwift))')")
        }
        
        if(accion=="rango"){
            tewb?.stringByEvaluatingJavaScriptFromString("cargresrango('\(serializaJSON(allInfoRawSwift))')")
        }
    }
    
    
    func obtener() {
        let fetchRequest = NSFetchRequest(entityName: "Reserva")
        
        let sortDescriptor = NSSortDescriptor(key: "fechainicioD", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Reserva] {
                logItems = fetchResults
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    func obtenerResxID(id:String){
        
        let fetchRequest = NSFetchRequest(entityName: "Reserva")
        
        let predicate = NSPredicate(format: "idreserva == %@",id)
        
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "fechainicioD", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Reserva] {
                logItems = fetchResults
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        cargaresxID()
    }
    
    func cargaresxID(){
        
        
        let arrtemp:NSMutableDictionary=NSMutableDictionary()
        
        if logItems.count>0{
            arrtemp["reservaId"]=String(logItems[0].idreserva!)
            arrtemp["timeStart"]=logItems[0].fechainicioS
            arrtemp["timeEnd"]=logItems[0].fechafinS
            arrtemp["reservedBy"]=logItems[0].nombre
            arrtemp["employeeId"]=String(logItems[0].idempleado!)
            arrtemp["picture"]=logItems[0].foto
            arrtemp["color"]=logItems[0].color
            arrtemp["mail"]=logItems[0].mail
            arrtemp["hora"]=String(logItems[0].hora)
            arrtemp["motivo"]=logItems[0].motivo
        }
        tewb?.stringByEvaluatingJavaScriptFromString("front.reserva.cargresid('\(serializaJSON(arrtemp))')")
        
    }
    
    
    func obtenerResxDia(var fecha:String){
        
        let fetchRequest = NSFetchRequest(entityName: "Reserva")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(fecha)
        
        
        let predicate = NSPredicate(format: "fechainicioD == %@",date!)
        
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "fechainicioD", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Reserva] {
                logItems = fetchResults
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        cargaRes("dia")
    }
    
    func obtenerResxRango(fechaini:String,fechafin:String){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(fechaini)
        let date2 = dateFormatter.dateFromString(fechafin)
        
        
        let fetchRequest = NSFetchRequest(entityName: "Reserva")
        
        let predicate = NSPredicate(format: "fechainicioD >= %@ && fechafinD <= %@ ",date!,date2!)
        
        
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "fechainicioD", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            if let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Reserva] {
                logItems = fetchResults
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        cargaRes("rango")
    }
    
    func eliminar(elim:String){
        
        let d:NSNumber=NSNumber(integer:(Int(elim))!)
        
        var idemp:String=String()
        var nom:String=String()
        var mail:String=String()
        var mens:String=String()
        var fg:Bool=false
        
        var hrinicio:String=String()
        var hrfin:String=String()
        var mtarr:NSArray=NSArray()
        
        var esta:Bool=false
        var date:NSDate=NSDate()
        obtener()
        
        for (var i:Int=0;i<logItems.count;++i){
            if logItems[i].idreserva==d {
                
                if (!esta){
                    date = obtenerFechaFormatead(logItems[i].fechainicioS!)
                    mtarr = obtenerDiasF(date)
                    hrinicio=obternerHrs(logItems[i].fechainicioS!)
                    esta=true
                }
                hrfin=obternerHrs(logItems[i].fechafinS!)
                
                nom=logItems[i].nombre!
                mail=logItems[i].mail!
                idemp=String(logItems[i].idempleado!)
                if let g:String = String(logItems[i].idreserva!){
                    mens=g
                }
                fg=true
                managedContext.deleteObject(logItems[i])
                
            }
        }
        //if(mail != "" && fg){
        
        mens=mens.stringByReplacingOccurrencesOfString("Optional(", withString: "")
        mens=mens.stringByReplacingOccurrencesOfString(")", withString: "")
        
        var mismocorreo:Bool=false
        if(mail.uppercaseString==inmut.copiacorreo.uppercaseString){
            mismocorreo=true
        }
        
        servMail.loginService(nom, email: mail, codigo: mens, diaNombre: mtarr[0] as! String, dia: mtarr[1] as! String, mes: mtarr[2] as! String, hrin: hrinicio.componentsSeparatedByString(",").first!, hrfin: hrfin.componentsSeparatedByString(",").first!, hriampm: hrinicio.componentsSeparatedByString(",").last!, hrfampm: hrfin.componentsSeparatedByString(",").last!, cancela: true,mismocorreo: mismocorreo)
        //}
        persisGuardar()
    }
    
    func obtenerDiasF(fechaConvertir:NSDate)->NSArray{
        
        let retarr:NSMutableArray=NSMutableArray()
        let datF:NSDateFormatter=NSDateFormatter()
        let locales = NSLocale(localeIdentifier: "es_MX")
        datF.locale=locales
        datF.dateFormat="EEEE"
        var nsname:NSString=datF.stringFromDate(fechaConvertir)
        retarr[0]=nsname
        
        
        datF.dateFormat="dd"
        nsname=datF.stringFromDate(fechaConvertir)
        retarr[1]=nsname
        
        
        datF.dateFormat="MMMM"
        nsname=datF.stringFromDate(fechaConvertir)
        retarr[2]=nsname
        
        
        return retarr
    }
    
    
    func createCoredata(){
        
        if let empleados : NSArray = jsonGlobal["empleados"] as? NSArray
        {
            for(var i:Int=0;i<empleados.count;++i){
                
                do{
                    try Empleados.crearRegistrosEmp(managedContext, idempleado:(empleados[i]["FIEMPLEADOID"] as? String)! , nombre: (empleados[i]["FCNOMBRECOMPLETO"] as? String)!, empresa: (empleados[i]["FCEMPRESA"] as? String)!, correo: (empleados[i]["FCCORREO"] as? String)!,updtcorreo: true)
                }
                catch let error as NSError {
                    NSLog("%@",error.localizedDescription)
                    
                }
            }
            
            persisGuardar()
            
        }
        
    }
    
    func isNumeric(a: String) -> Bool {
        return Double(a) != nil
    }
    
    //MARK: get Drive
    func obtenerDrive() {
        NSLog("%@","drive----------------------------->>>>>>>>>>>>>>>>")
        var arr:NSMutableArray=NSMutableArray()
        
            let url = NSURL(string: inmut.urldrive)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!) { data, response, error in
                
                if data != nil{
                    arr=NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSMutableArray
                    self.dicempleados(arr)
                }
                else{
                    self.dicempleados(arr)
                }
            }
            task.resume()
        
        
    }
    
    func getEmpleados(){
        let arr:NSMutableArray=NSMutableArray()
        if ReachWS.isConnectedToNetwork() == true {
        if(inmut.drive){
            
            obtenerDrive()
            
        }
        else{
            servEmp.consultaEmpleados()
        }
        }
        else{
            self.dicempleados(arr)
            let alertController = UIAlertController(title: "Sin conexión", message:
                "No se puede actualizar el directorio", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    func dicempleados(dic: NSMutableArray){
        NSLog("%i",dic.count)
        NSLog("%@","1")
        if(dic.count>0){
            NSLog("%@","2")
            print(dic.count)
            NSLog("%@","3")
            let fetchRequest = NSFetchRequest(entityName: "Empleados")
            NSLog("%@","4")
            let error:NSErrorPointer = nil
            NSLog("%@","5")
            var fetchresult=managedContext.countForFetchRequest(fetchRequest, error: error)
            NSLog("%@","6")
            print(fetchresult)
            NSLog("%@","7")
            var update:Bool=false
            NSLog("%@","8")
            if(dic.count>fetchresult){
                NSLog("%@","9")
                update=true
                NSLog("%@","10")
            }
            else{
                NSLog("%@","11")
                let dif=fetchresult-dic.count
                NSLog("%@","12")
                if(dif<=1000){
                    NSLog("%@","13")
                    update=true
                    NSLog("%@","14")
                }
            }
            
            if(update){
                NSLog("%@","15")
                
                
                
                let fetchRequest2 = NSFetchRequest(entityName: "Empleados")
                NSLog("%@","16")
                let sortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
                NSLog("%@","17")
                let predicate = NSPredicate(format: "updtcorreo == %@",NSNumber(bool: false))
                NSLog("%@","18")
                fetchRequest2.predicate = predicate
                NSLog("%@","19")
                fetchRequest2.sortDescriptors = [sortDescriptor]
                NSLog("%@","20")
                var temempactmail=[Empleados]()
                NSLog("%@","21")
                do{
                    NSLog("%@","22")
                    if let fetchResults2 = try managedContext!.executeFetchRequest(fetchRequest2) as? [Empleados] {
                        NSLog("%@","23")
                        temempactmail = fetchResults2
                    }
                }
                catch let error as NSError {
                    NSLog("%@","24")
                    NSLog("%@",error.localizedDescription)
                    print(error.localizedDescription)
                }
                NSLog("%@","temempactmail")
                print("temempactmail")
                NSLog("%@","25")
                print(temempactmail.count)
                NSLog("%@","26")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                NSLog("%@","27")
                do {
                    NSLog("%@","28")
                    try coord.executeRequest(deleteRequest, withContext: managedContext)
                } catch let error as NSError {
                    NSLog("%@","29")
                    NSLog("%@",error.localizedDescription)
                    print(error)
                }
                NSLog("%@","30")
                let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
                privateMOC.parentContext = managedContext
                
                for(var i:Int=0;i<dic.count;++i){
                    
                    var myStringArr = dic[i].componentsSeparatedByString("||")
                    privateMOC.performBlockAndWait {
                        do{
                            try Empleados.crearRegistrosEmp(privateMOC, idempleado:myStringArr[1] , nombre: (myStringArr[2] as String).uppercaseString, empresa: myStringArr[3] , correo: myStringArr[4],updtcorreo: true )
                        }
                        catch let error as NSError {
                            NSLog("%@",error.localizedDescription)
                            
                        }
                    }
                }
                privateMOC.performBlockAndWait {
                    do {
                        try privateMOC.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                NSLog("%@","31")
                //persisGuardar()
                if(temempactmail.count>0){
                    NSLog("%@","32")
                    var nom:String=String()
                    var idemp:String=String()
                    var correo:String=String()
                    var empresa:String=String()
                    
                    NSLog("%@","33")
                    let fetchRequest3 = NSFetchRequest(entityName: "Empleados")
                    let sortDescriptor3 = NSSortDescriptor(key: "nombre", ascending: true)
                    var predicate3=NSPredicate()
                    
                    fetchRequest3.sortDescriptors = [sortDescriptor3]
                    
                    for(var io:Int=0;io<temempactmail.count;++io){
                        
                        nom=temempactmail[io].nombre!
                        idemp=temempactmail[io].idempleado!
                        correo=temempactmail[io].correo!
                        empresa=temempactmail[io].empresa!
                        predicate3 = NSPredicate(format: "idempleado == %@",idemp)
                        fetchRequest3.predicate = predicate3
                        var actuemp=[Empleados]()
                        do{
                            if let fetchResults3 = try managedContext!.executeFetchRequest(fetchRequest3) as? [Empleados] {
                                actuemp = fetchResults3
                            }
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                        
                        if(actuemp.count>0){
                            //actuemp.first?.nombre=nom
                            actuemp.first?.correo=correo
                            //actuemp.first?.empresa=empresa
                            actuemp.first?.updtcorreo=false
                        }
                        else{
                            do{
                                try Empleados.crearRegistrosEmp(privateMOC, idempleado:idemp , nombre: nom.uppercaseString, empresa: empresa , correo: correo,updtcorreo: false )
                            }
                            catch let error as NSError {
                                NSLog("%@",error.localizedDescription)
                                
                            }
                        }
                        
                        
                    }
                    NSLog("%@","34")
                }
                NSLog("%@","35")
                //persisGuardar()
                privateMOC.performBlockAndWait {
                    do {
                        try privateMOC.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                NSLog("%@","36")
                print("termino")
                fetchresult=managedContext.countForFetchRequest(fetchRequest, error: error)
                NSLog("%@","37")
                print(fetchresult)
                NSLog("%@","38")
                crearTarea()
                NSLog("%@","39")
            }
            
            
        }
        
        NSLog("%@","40")
        dispatch_async(dispatch_get_main_queue()) {
            self.tewb?.stringByEvaluatingJavaScriptFromString("closespin()")
            NSLog("%@","41")
        }
        
    }
    
    func crearempPrimeraView(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tewb?.stringByEvaluatingJavaScriptFromString("openspin()")
        }
        //    getEmpleados()
        
    }
    
    func crearTarea(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let formatter = NSDateFormatter()
        formatter.dateFormat="yyyy-MM-dd"
        print(formatter.stringFromDate(NSDate()))
        print(hour)
        let fred:NSMutableDictionary=NSMutableDictionary()
        fred["hr"]=hour
        fred["fec"]=formatter.stringFromDate(NSDate())
        utils.savenuevo(fred, nombre: "fecha")
        let jh=utils.leernuevo("fecha.plist")
        print(jh["fec"])
    }
    
    
    func actualizarEmp(){
        if !utils.existeNuevo("fecha"){
            crearTarea()
        }
        let jh=utils.leernuevo("fecha.plist")
        print(jh["fec"] as! String)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat="yyyy-MM-dd"
        let sahora=formatter.stringFromDate(NSDate())
        let dahora=formatter.dateFromString(sahora)
        let dcompara=formatter.dateFromString(jh["fec"] as! String)
        
        if(dahora!.isGreaterThanDate(dcompara!)) {
            if (jh["hr"] as! Int>=inmut.hrUpdate){
                dispatch_async(dispatch_get_main_queue()) {
                    self.tewb?.stringByEvaluatingJavaScriptFromString("openspin('\(inmut.textoActualizando)')")
                }
                getEmpleados()
            }
        }
        
    }
    
    
    
}
