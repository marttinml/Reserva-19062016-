//
//  Empleados+CoreDataProperties.swift
//  Reserva
//
//  Created by Ivan Tzicuri De la luz Escalante on 28/03/16.
//  Copyright © 2016 Ivan Tzicuri De la luz Escalante. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Empleados {

    @NSManaged var correo: String?
    @NSManaged var empresa: String?
    @NSManaged var idempleado: String?
    @NSManaged var nombre: String?
    @NSManaged var updtcorreo: NSNumber?

}
