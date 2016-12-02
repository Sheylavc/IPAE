//
//  Pregunta.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Pregunta: NSManagedObject {
    
    class func addPreguntas(json: AnyObject)->[Pregunta]{
        let preguntas = json as![AnyObject]
        let preguntaSet = NSMutableSet()
        
        for pregunta in preguntas {
            preguntaSet.addObject(Pregunta.createPregunta(pregunta))
            
        }
        return preguntaSet.allObjects as! [Pregunta]
    }
    
    class func createPregunta(json: AnyObject)-> Pregunta {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let newPregunta = NSEntityDescription.insertNewObjectForEntityForName("Pregunta", inManagedObjectContext: ap.managedObjectContext) as! Pregunta
        //Asignamos los valores
        newPregunta.idPregunta =  NSNumber(integer: Int((json["idPregunta"] as! String))!)
        newPregunta.pregunta = json["pregunta"] as? String
        newPregunta.rp1 = json["rp1"] as? String
        newPregunta.rp2 = json["rp2"] as? String
        newPregunta.rp3 = json["rp3"] as? String
        newPregunta.rp4 = json["rp4"] as? String
        newPregunta.idSubCategoria = NSNumber(integer: Int((json["idSubCategoria"] as! String))!)
        
        //Guardamos la informacion
        ap.saveContext()
        return newPregunta
        
    }
    
    class func getPreguntasBySubCat(subcat: String)->[Pregunta]?{
        let resquest = NSFetchRequest(entityName: "Pregunta")
        resquest.predicate = NSPredicate(format: "idSubCategoria ="+subcat)
        //resquest.sortDescriptors = [NSSortDescriptor(key: "idSubCategoria", ascending: true)]
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        let preguntasSet = NSMutableSet()
        do{
            let preguntas = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Pregunta]
            for pregunta in preguntas {
                preguntasSet.addObject(pregunta)
            }
            
        }catch {
            return nil
        }
        
        return preguntasSet.allObjects as? [Pregunta]
    }
    
    class func updatePregunta(json: AnyObject)->String?{
        var idSubCategoria = ""
        let preguntas = json as![AnyObject]
        for pregunta in preguntas {
            idSubCategoria = saveUpdatePregunta(pregunta)!
        }
        return idSubCategoria
        
        
    }
    
    class func saveUpdatePregunta(json: AnyObject)-> String?{
       //print(json["idPregunta"]!)
        let idPregunta = json["idPregunta"] as? String
        let resquest = NSFetchRequest(entityName: "Pregunta")
        resquest.predicate = NSPredicate(format: "idPregunta = "+idPregunta!)
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
    
        do{
            let preg = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Pregunta]
            if let preg = preg.first{
                preg.pregunta = json["pregunta"] as? String
                preg.rp1 = json["rp1"] as? String
                preg.rp2 = json["rp2"] as? String
                preg.rp3 = json["rp3"] as? String
                preg.rp4 = json["rp4"] as? String
                ap.saveContext()
                //print(json["idSubCategoria"] as? String)
                return json["idSubCategoria"] as? String
    
            }else{
                return nil
            }
    
        }catch {
            return nil
        }
    }
    

}
