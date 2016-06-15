//
//  servicioMail.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 17/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import Foundation

class servicioMail: XMLParcer
{
    
    override init()
    {
        super.init()
    }
    
    func loginService(nombre:String,email:String,codigo:String,diaNombre:String,dia:String,mes:String,hrin:String,hrfin:String,hriampm:String,hrfampm:String,cancela:Bool,mismocorreo:Bool) ->NSDictionary{
        let parcer:XMLParcer = XMLParcer();
        var oResponse:NSDictionary
        var idapp=""
        var s2=""
        if inmut.prodQa{
            idapp="24"
            s2="@shp1+PTCRAkxeWB%GsqD7snnZ2pEK"
        parcer.sURLService = "http://10.188.17.235:39004/MensajesIusacellService/svMessage"
        }
        else{
            idapp="36"
            s2="jCi5G$OSLC1iAcli+k9exFw0nSpq1Q"
            parcer.sURLService = "http://10.203.24.211:39004/MensajesIusacellService/svMessage"

        }
        var ResCan:String=""
        let key = "=/ihpqN24e15stHl"
        let iv = "=/ihpqN24e15stHl"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmm"
        let date:NSDate=NSDate()
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeZone = timeZone
        let s=dateFormatter.stringFromDate(date)
        let enc = try! s.aesEncrypt(key, iv: iv)
        let enc2 = try! s2.aesEncrypt(key, iv: iv)
        
        var sXMLRequest = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ser='http://services.message.iusacell.com.mx' xmlns:vo='http://vo.message.iusacell.com.mx'><soapenv:Header/>"
        sXMLRequest = sXMLRequest + "<soapenv:Body>"
        sXMLRequest = sXMLRequest + "<ser:enviaMail>"
        sXMLRequest = sXMLRequest + "<ser:in0>=/ihpqN24e15stHlmsm1!olvEm=*</ser:in0>"
        sXMLRequest = sXMLRequest + "<ser:in1>=/ihpqN24e15stHlmsm1!olvEm=*</ser:in1>"
        sXMLRequest = sXMLRequest + "<ser:in2>"+idapp+"</ser:in2>"
        sXMLRequest = sXMLRequest + "<ser:in3>" + enc2 + "</ser:in3>"
        sXMLRequest = sXMLRequest + "<ser:in4>14.14.0.1</ser:in4>"
        sXMLRequest = sXMLRequest + "<ser:in5>"
        
        sXMLRequest = sXMLRequest + "<vo:archivosAdjuntos>"
        sXMLRequest = sXMLRequest + "<vo:ArchivoAdjunto>"
        sXMLRequest = sXMLRequest + "<vo:archivoBase64></vo:archivoBase64>"
        sXMLRequest = sXMLRequest + "<vo:extension></vo:extension>"
        sXMLRequest = sXMLRequest + "<vo:mimeType></vo:mimeType>"
        sXMLRequest = sXMLRequest + "<vo:nombre></vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:ArchivoAdjunto>"
        sXMLRequest = sXMLRequest + "</vo:archivosAdjuntos>"
        
        sXMLRequest = sXMLRequest + "<vo:estilos xsi:nil='true' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'/>"
        
        sXMLRequest = sXMLRequest + "<vo:imagenes>"
        sXMLRequest = sXMLRequest + "<vo:Imagen64VO>"
        sXMLRequest = sXMLRequest + "<vo:imagenBase64></vo:imagenBase64>"
        sXMLRequest = sXMLRequest + "<vo:nombre></vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:Imagen64VO>"
        sXMLRequest = sXMLRequest + "</vo:imagenes>"
        
        sXMLRequest = sXMLRequest + "<vo:mailBody>"
        
        if(!cancela){
            
            ResCan="Sala Reservada"
            sXMLRequest = sXMLRequest + "&lt;div style=\"font-family: sans-serif, Geneva;\">"
            sXMLRequest = sXMLRequest + "&lt;center>"
            sXMLRequest = sXMLRequest + "&lt;table style=\"width:400px;text-align:center;color:#666; font-size: 18px; margin:40px;\" cellspacing=\"0\" cellpadding=\"0\">"
            sXMLRequest = sXMLRequest + "&lt;thead style=\"height:70px;\">"
            sXMLRequest = sXMLRequest + "&lt;tr style=\"height:70px;font-size:26px;font-weight: 100;\">"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\" style=\"background-color:#0099CC;color:#fff;font-family: sans-serif, Geneva;\">"+ResCan+"&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;/thead>"
            sXMLRequest = sXMLRequest + "&lt;tbody style=\"background-color:#F4F4F4;\">"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\"style=\"height:20px;text-align:center;padding:30px;\">"
            sXMLRequest = sXMLRequest + "&lt;p style=\"margin:0;\">"+nombre.componentsSeparatedByString(" ").first!+", gracias por reservar la sala.&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;p style=\"margin:0;\">Estos son los datos de tu reservación:&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td style=\"width:35%; padding:5px;\">"
            sXMLRequest = sXMLRequest + "&lt;p style=\"font-size:22px;margin:0px 0px 10px 0px; color:#0099CC;\">"+diaNombre+" "+dia+" de "+mes+"&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;p style=\"font-size:22px;margin:0px; color:#0099CC;\">"+hrin+" "+hriampm.lowercaseString+" a "+hrfin+" "+hrfampm.lowercaseString+"&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\" style=\"padding:20px;\">Tu código de reserva es:&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\" style=\"font-size:42px;margin:0px; color:#0099CC;\">"+codigo+"&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\" style=\"padding:20px;font-size: 14px;\">"
            sXMLRequest = sXMLRequest + "&lt;i>Consérvalo para futuros cambios.&lt;/i>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;/tbody>"
            sXMLRequest = sXMLRequest + "&lt;/table>"
            sXMLRequest = sXMLRequest + "&lt;/center>"
            sXMLRequest = sXMLRequest + "&lt;/div>"
            
            
        }
        else{
            
            ResCan="Reserva Cancelada"
            sXMLRequest = sXMLRequest + "&lt;div style=\"font-family: sans-serif, Geneva;\">"
            sXMLRequest = sXMLRequest + "&lt;center>"
            sXMLRequest = sXMLRequest + "&lt;table style=\"width:400px;text-align:center;color:#666; font-size: 18px; margin:40px;\" cellspacing=\"0\" cellpadding=\"0\">"
            sXMLRequest = sXMLRequest + "&lt;thead style=\"height:70px;\">"
            sXMLRequest = sXMLRequest + "&lt;tr style=\"height:70px;font-size:26px;font-weight: 100;\">"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\" style=\"background-color:#CC3333;color:#fff;font-family: sans-serif, Geneva;\">"+ResCan+"&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;/thead>"
            sXMLRequest = sXMLRequest + "&lt;tbody style=\"background-color:#F4F4F4;\">"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\"style=\"height:20px;text-align:center;padding:30px;\">"
            sXMLRequest = sXMLRequest + "&lt;p style=\"margin:0;\">"+nombre.componentsSeparatedByString(" ").first!+", la siguiente reservación ha sido cancelada.&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td>"
            sXMLRequest = sXMLRequest + "&lt;p style=\"font-size:22px;margin:0px 0px 10px 0px; color:#CC3333;\">"+diaNombre+" "+dia+" de "+mes+"&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;p style=\"font-size:22px;margin:0px; color:#CC3333;\">"+hrin+" "+hriampm.lowercaseString+" a "+hrfin+" "+hrfampm.lowercaseString+"&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\">"
            sXMLRequest = sXMLRequest + "&lt;p>&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;tr>"
            sXMLRequest = sXMLRequest + "&lt;td colspan=\"2\">"
            sXMLRequest = sXMLRequest + "&lt;p>&lt;/p>"
            sXMLRequest = sXMLRequest + "&lt;/td>"
            sXMLRequest = sXMLRequest + "&lt;/tr>"
            sXMLRequest = sXMLRequest + "&lt;/tbody>"
            sXMLRequest = sXMLRequest + "&lt;/table>"
            sXMLRequest = sXMLRequest + "&lt;/center>"
            sXMLRequest = sXMLRequest + "&lt;/div>"
            
        }
        
        sXMLRequest = sXMLRequest + "</vo:mailBody>"
        
        
        
        
        sXMLRequest = sXMLRequest + "<vo:mailCc>"
        sXMLRequest = sXMLRequest + "<vo:EmailVO>"
        var cop:String=""
        if(!mismocorreo){
            cop=inmut.copiacorreo
        }
        sXMLRequest = sXMLRequest + "<vo:direccion>"+cop+"</vo:direccion>"
        
        sXMLRequest = sXMLRequest + "<vo:nombre>Copia "+ResCan+"</vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:EmailVO>"
        sXMLRequest = sXMLRequest + "</vo:mailCc>"
        
        sXMLRequest = sXMLRequest + "<vo:mailCco>"
        sXMLRequest = sXMLRequest + "<vo:EmailVO>"
        sXMLRequest = sXMLRequest + "<vo:direccion></vo:direccion>"
        sXMLRequest = sXMLRequest + "<vo:nombre></vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:EmailVO>"
        sXMLRequest = sXMLRequest + "</vo:mailCco>"
        
        sXMLRequest = sXMLRequest + "<vo:mailFrom>"
        //PEDIR correo corporativo
        sXMLRequest = sXMLRequest + "<vo:direccion>iquiroz@ATT.com.mx</vo:direccion>"
        sXMLRequest = sXMLRequest + "<vo:nombre>"+ResCan+"</vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:mailFrom>"
        
        sXMLRequest = sXMLRequest + "<vo:mailSubject>at&amp;t - ATT</vo:mailSubject>"
        sXMLRequest = sXMLRequest + "<vo:mailTo>"
        sXMLRequest = sXMLRequest + "<vo:EmailVO>"
        sXMLRequest = sXMLRequest + "<vo:direccion>" + email + "</vo:direccion>"
        //sXMLRequest = sXMLRequest + "<vo:direccion>ide@iusacell.com.mx</vo:direccion>"
        sXMLRequest = sXMLRequest + "<vo:nombre>" + nombre + "</vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:EmailVO>"
        sXMLRequest = sXMLRequest + "</vo:mailTo>"
        
        sXMLRequest = sXMLRequest + "<vo:replyTo>"
        sXMLRequest = sXMLRequest + "<vo:EmailVO>"
        sXMLRequest = sXMLRequest + "<vo:direccion></vo:direccion>"
        sXMLRequest = sXMLRequest + "<vo:nombre></vo:nombre>"
        sXMLRequest = sXMLRequest + "</vo:EmailVO>"
        sXMLRequest = sXMLRequest + "</vo:replyTo>"
        
        sXMLRequest = sXMLRequest + "</ser:in5>"
        sXMLRequest = sXMLRequest + "<ser:in6>" + enc + "</ser:in6>"
        sXMLRequest = sXMLRequest + "</ser:enviaMail>"
        sXMLRequest = sXMLRequest + "</soapenv:Body>"
        sXMLRequest = sXMLRequest + "</soapenv:Envelope>"
        
        oResponse = parcer.callWebService(sXMLRequest) as! NSDictionary
        
        return oResponse
    }
    
}