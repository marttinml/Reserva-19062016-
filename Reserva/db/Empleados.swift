//
//  Empleados.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 06/01/16.
//  Copyright © 2016 Ivan Tzicuri De la luz Escalante. All rights reserved.
//

import Foundation
import CoreData


class Empleados: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    
    class func crearRegistrosEmp(moc: NSManagedObjectContext, idempleado: String, nombre: String,empresa:String,correo: String,updtcorreo:Bool) throws -> Empleados {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Empleados", inManagedObjectContext: moc) as! Empleados
        
        newItem.idempleado = idempleado
        newItem.nombre = nombre
        newItem.empresa=empresa
        newItem.correo=correo
        newItem.updtcorreo=updtcorreo
        
        return newItem
    }
    
    
}
