//
//  Respuesta.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Respuesta: NSManagedObject {

    class func createRespuesta(idTest: Int, idPregunta: Int, idSubCategoria: Int, rp: String) {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let resquest = NSFetchRequest(entityName: "Respuesta")
        resquest.predicate = NSPredicate(format: "idPregunta ="+String(idPregunta))
        
        do{
            let respuesta = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Respuesta]
            if let rpta = respuesta.first{
                
                //respuesta.first?.rp = rp
                rpta.rp = rp
                ap.saveContext()
                
            }else{
                let newRespuesta = NSEntityDescription.insertNewObjectForEntityForName("Respuesta", inManagedObjectContext: ap.managedObjectContext) as! Respuesta
                //Asignamos los valores
                newRespuesta.idTest =  NSNumber(integer: Int(idTest))
                newRespuesta.idPregunta = NSNumber(integer: Int(idPregunta))
                newRespuesta.idSubcategoria = NSNumber(integer: Int(idSubCategoria))
                newRespuesta.rp = rp
                
                //Guardamos la informacion
                ap.saveContext()
            }
            
        }catch {
            
        }
        
    
        
        
        
    }
    
    class func checkRespuesta(idPregunta: Int)->Bool {
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let resquest = NSFetchRequest(entityName: "Respuesta")
        resquest.predicate = NSPredicate(format: "idPregunta ="+String(idPregunta))
        
        do{
            let respuesta = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Respuesta]
            if let _ = respuesta.first{
                return true
                
            }else{
                return false
            }
            
        }catch {
            return false
        }
        
    }
    
    class func getDataRespuesta(idPregunta: Int)->String! {
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let resquest = NSFetchRequest(entityName: "Respuesta")
        resquest.predicate = NSPredicate(format: "idPregunta ="+String(idPregunta))
        
        do{
            let respuesta = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Respuesta]
            if let _ = respuesta.first{
                return respuesta.first?.rp
                
            }else{
                return ""
            }
            
        }catch {
            return ""
        }
        
    }
    
    class func getRespuestasByTest(idTest: Int)->[Respuesta]! {
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let resquest = NSFetchRequest(entityName: "Respuesta")
        resquest.predicate = NSPredicate(format: "idTest ="+String(idTest))
        
        do{
            let respuesta = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Respuesta]
            if let _ = respuesta.first{
                return respuesta
                
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }
    
    class func deleteRespuestas(idTest: NSNumber){
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let resquest = NSFetchRequest(entityName: "Respuesta")
        resquest.predicate = NSPredicate(format: "idTest = "+idTest.stringValue)
        
        // Initialize Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: resquest)
        
        // Configure Batch Update Request
        batchDeleteRequest.resultType = .ResultTypeCount
        
        
        do{
            try ap.managedObjectContext.executeRequest(batchDeleteRequest) as! NSBatchDeleteResult
            //try fetchedResultsController.performFetch()
            //let respuestas = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Respuesta]
            
            
        }catch {
            
        }
        
    }

}
