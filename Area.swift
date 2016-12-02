//
//  Area.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Area: NSManagedObject {

    class func addAreas(json: AnyObject)->[Area]{
        let areas = json as![AnyObject]
        let areaSet = NSMutableSet()
        
        for area in areas {
            areaSet.addObject(Area.createAreas(area))
            
        }
        return areaSet.allObjects as! [Area]
    }
    
    class func createAreas(json: AnyObject)-> Area {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let newArea = NSEntityDescription.insertNewObjectForEntityForName("Area", inManagedObjectContext: ap.managedObjectContext) as! Area
        //Asignamos los valores
        newArea.idArea =  NSNumber(integer: Int((json["idArea"] as! String))!)
        newArea.idCategoria =  NSNumber(integer: Int((json["idCategoria"] as! String))!)
        newArea.area = json["area"] as? String
        
        //Guardamos la informacion
        ap.saveContext()
        return newArea
        
    }
    
    class func getAreasByCategoria(idCategoria: NSNumber)-> [Area]?{
        let resquest = NSFetchRequest(entityName: "Area")
        resquest.predicate = NSPredicate(format: "idCategoria ="+idCategoria.stringValue)
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        let areasSet = NSMutableSet()
        do{
            let areas = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Area]
            for area in areas {
                areasSet.addObject(area)
            }
            
        }catch {
            return nil
        }
        
        return areasSet.allObjects as? [Area]
    }

}
