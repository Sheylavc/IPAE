//
//  Pregunta+CoreDataProperties.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pregunta {

    @NSManaged var estado: String?
    @NSManaged var idPregunta: NSNumber?
    @NSManaged var pregunta: String?
    @NSManaged var rp1: String?
    @NSManaged var rp2: String?
    @NSManaged var rp3: String?
    @NSManaged var rp4: String?
    @NSManaged var idSubCategoria: NSNumber?

}
