//
//  NSObjectExtends.swift
//  ApartaSalas
//
//  Created by Ivan Tzicuri De la luz Escalante on 14/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import Foundation

struct GlobalConstants
{
    static let KURLRegistro = "https://movil.nextel.com.mx/OSBP_myATTMX_Services/AP_IusacellService/MD_IusacellService/proxy/PX_IusacellService"
    static let KURLLogin = "https://movil.nextel.com.mx/OSBP_myATTMX_Services/AP_LoginService/MD_LoginService/proxy/PX_LoginService"

	static let KServiceHeader = "<soapenv:Header><wsse:Security xmlns:wsse='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd' mustUnderstand='1'><wsse:UsernameToken xmlns:wsu='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd' wsu:Id='UsernameToken-EvwlT8IliF86JsLmerQQJA22'><wsse:Username>appMyATTMX</wsse:Username><wsse:Password Type='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'>w3bAp.MyAT&amp;TMX</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header>"

//    static let KURLRegistro = "http://14.128.92.113:7001/myATTMX_Services/IusacellService"
//    static let KURLLogin = "http://14.128.92.113:7001/myATTMX_Services/LoginService"
    
    static let KTimeOut:Int = 60
    static let KErrorWS:String = "error"
	static let KErrorSinConexion:String = "errorSinConexion"
    static let KProduccion:Bool = true


    static let KPrintXMLParcerResponse = true
}

typealias BloqueGenerico = () -> Void

extension NSObject
{
    func ejecutaSegundoPlano(bloqueSegundoPlano:BloqueGenerico, bloquePrimerPlano:BloqueGenerico)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
                bloqueSegundoPlano()
                
                dispatch_async(dispatch_get_main_queue(),
                    {
                        bloquePrimerPlano()
                });
        });
    }
}
extension NSDate
{
	func formatDate(formato:String, fecha:String) -> NSDate
	{
		let usLocale:NSLocale = NSLocale(localeIdentifier: "es_ES")

		let dateStringFormatter = NSDateFormatter()
		dateStringFormatter.locale = usLocale
		dateStringFormatter.dateFormat = formato
		let dateValue:NSDate? = dateStringFormatter.dateFromString(fecha)!

		return dateValue!
	}
	
}