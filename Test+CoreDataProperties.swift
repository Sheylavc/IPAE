//
//  Test+CoreDataProperties.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 30/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Test {

    @NSManaged var cargo: String?
    @NSManaged var email: String?
    @NSManaged var estado: String?
    @NSManaged var fecha: String?
    @NSManaged var from: String?
    @NSManaged var fullname: String?
    @NSManaged var idArea: NSNumber?
    @NSManaged var idCategoria: NSNumber?
    @NSManaged var idPeriodo: NSNumber?
    @NSManaged var idTest: NSNumber?
    @NSManaged var razonsocial: String?
    @NSManaged var telefono: String?
    @NSManaged var tenmillons: String?
    @NSManaged var token: String?

}
