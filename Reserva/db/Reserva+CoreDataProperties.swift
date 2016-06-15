//
//  Reserva+CoreDataProperties.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 21/12/15.
//  Copyright © 2015 Ivan Tzicuri De la luz Escalante. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reserva {

    @NSManaged var motivo: String?
    @NSManaged var color: String?
    @NSManaged var fechafinD: NSDate?
    @NSManaged var fechafinS: String?
    @NSManaged var fechainicioD: NSDate?
    @NSManaged var fechainicioS: String?
    @NSManaged var foto: String?
    @NSManaged var idempleado: NSNumber?
    @NSManaged var idreserva: NSNumber?
    @NSManaged var mail: String?
    @NSManaged var nombre: String?
    @NSManaged var hora: NSNumber?

}
