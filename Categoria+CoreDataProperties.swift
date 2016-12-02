//
//  Categoria+CoreDataProperties.swift
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

extension Categoria {

    @NSManaged var descripcion_cat: String?
    @NSManaged var idCategoria: NSNumber?
    @NSManaged var imagen_cat: NSData?
    @NSManaged var nombre_cat: String?

}
