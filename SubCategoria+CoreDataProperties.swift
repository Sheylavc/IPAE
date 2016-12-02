//
//  SubCategoria+CoreDataProperties.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 1/10/16.
//  Copyright © 2016 ipae. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SubCategoria {

    @NSManaged var idPeriodo: NSNumber?
    @NSManaged var idSubCategoria: NSNumber?
    @NSManaged var imagen_subc: NSData?
    @NSManaged var imagen_subc_negativo: NSData?
    @NSManaged var nombre_subc: String?
    @NSManaged var idCategoria: NSNumber?
    @NSManaged var imagen_subc_app: NSData?

}
