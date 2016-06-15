//
//  Reserva.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 14/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import Foundation
import CoreData


class Reserva: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func crearRegistros(moc: NSManagedObjectContext, idreserva: NSNumber, fechainicioS: String,fechainicioD:NSDate,fechafinS: String,fechafinD:NSDate,nombre: String,idempleado: NSNumber,foto:String,color:String,mail:String,hora:NSNumber,motivo:String) -> Reserva {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Reserva", inManagedObjectContext: moc) as! Reserva
        
        newItem.idreserva = idreserva
        newItem.fechainicioS = fechainicioS
        newItem.fechainicioD=fechainicioD
        newItem.fechafinD=fechafinD
        newItem.fechafinS=fechafinS
        newItem.nombre=nombre
        newItem.idempleado=idempleado
        newItem.foto=foto
        newItem.color=color
        newItem.mail=mail
        newItem.hora=hora
        newItem.motivo=motivo
        return newItem
    }
}
