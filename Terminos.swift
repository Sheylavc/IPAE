//
//  Terminos.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Terminos: NSManagedObject {
    
    class func addTerminos(json: AnyObject)->[Terminos]{
        let terminos = json as![AnyObject]
        let terminoSet = NSMutableSet()
        
        for termino in terminos {
            terminoSet.addObject(Terminos.createAreas(termino))
            
        }
        return terminoSet.allObjects as! [Terminos]
    }
    
    class func createAreas(json: AnyObject)-> Terminos {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let newTermino = NSEntityDescription.insertNewObjectForEntityForName("Terminos", inManagedObjectContext: ap.managedObjectContext) as! Terminos
        //Asignamos los valores
        newTermino.idTermino =  NSNumber(integer: Int((json["idTermino"] as! String))!)
        newTermino.texto = json["texto"] as? String
       
        //Guardamos la informacion
        ap.saveContext()
        return newTermino
        
    }
    class func currentTermino()->Terminos?{
        let resquest = NSFetchRequest(entityName: "Terminos")
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        do{
            let termino = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Terminos]
            if let _ = termino.first{
                return termino.first
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }
}
