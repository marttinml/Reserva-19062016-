//
//  WSEmpleados.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 10/03/16.
//  Copyright © 2016 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import UIKit

    protocol respempleadosProtocolo {
        func dicempleados(dic:NSMutableArray)
    }
    class WSEmpleados: WSReq {
        
        var utils:Utilerias=Utilerias()
        var empleadosDelegate: respempleadosProtocolo?
        var cons:constantes=constantes.sharedInstance
        
        func consultaEmpleados(){
            
            if ReachWS.isConnectedToNetwork() == true {
                
                print("Conexión establecida - Empleados")
                URLSer="http://10.188.17.93:38083/DirectorioService/services/Directorio"
                let sXMLRequest:NSMutableString="\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service.directorio.iusacell.com.mx\">"
                sXMLRequest.appendFormat("\n<soapenv:Header/>")
                sXMLRequest.appendFormat("\n<soapenv:Body>")
                sXMLRequest.appendFormat("\n<ser:consulta>")
                sXMLRequest.appendFormat("\n<ser:in0>%@</ser:in0>","select a.fiempleadoid,a.fcnombrecompleto,a.fcempresa,b.fccorreo from directorioiusacell.TADIREMPLEADOS a left join directorioiusacell.TADIRdatosEMPLEADOS b on a.fiempleadoid=b.fiempleadoid")
                sXMLRequest.appendFormat("\n</ser:consulta>")
                sXMLRequest.appendFormat("\n</soapenv:Body>")
                sXMLRequest.appendFormat("\n</soapenv:Envelope>\n")
                
                llamarWS(sXMLRequest, completion: { objParseado in
                    //if objParseado.count>0{
                        self.parseEmpleados(objParseado)
                    //}
//                    else{
//                        
//                        self.consultaEmpleados()
//                    
//                    }
                    
                })
            } else {
                print("Error de conexión - Empleados")
                let dicVacio: NSDictionary = NSDictionary()
                self.parseEmpleados(dicVacio)
            }
            
        }
        
        
        func parseEmpleados(array:NSDictionary){
            var dicPer:NSDictionary = NSDictionary()
            var permisos:NSMutableArray = NSMutableArray()
            
            if array.count > 0 {
                
                if let valdin = array
                    .objectForKey("soap:Body")?
                    .objectForKey("ns1:consultaResponse")?
                    .objectForKey("ns1:out")
                {
                    dicPer=valdin as! NSDictionary
                    permisos = dicPer["ns1:string"] as! NSMutableArray
                    //MARK: generar plist update empleados
                    //utils.savenuevo(permisos, nombre: "Empleados")
                    cons.terminoEmpleados = true
                }
                
            }
        
            empleadosDelegate?.dicempleados(permisos)
        }
    
}
