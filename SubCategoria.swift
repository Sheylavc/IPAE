//
//  SubCategoria.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SubCategoria: NSManagedObject {

    class func addSubCategorias(json: AnyObject)->[SubCategoria]{
        let subcategorias = json as![AnyObject]
        let subcategoriaSet = NSMutableSet()
        
        for subcategoria in subcategorias {
            subcategoriaSet.addObject(SubCategoria.createSubCategoria(subcategoria))
            
        }
        return subcategoriaSet.allObjects as! [SubCategoria]
    }
    
    class func createSubCategoria(json: AnyObject)-> SubCategoria {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let newSubCategoria = NSEntityDescription.insertNewObjectForEntityForName("SubCategoria", inManagedObjectContext: ap.managedObjectContext) as! SubCategoria
        //Asignamos los valores
        newSubCategoria.idSubCategoria =  NSNumber(integer: Int((json["idSubCategoria"] as! String))!)
        newSubCategoria.idPeriodo =   NSNumber(integer: Int((json["idPeriodo"] as! String))!)
        newSubCategoria.idCategoria =   NSNumber(integer: Int((json["idCategoria"] as! String))!)
        newSubCategoria.nombre_subc = json["nombre_subc"] as? String
        let imagen = SubCategoria.saveImage((json["imagen_subc_principal"] as? String)!)
        let imagennegativo = SubCategoria.saveImage((json["imagen_subc_negativo"] as? String)!)
        let imagenapp = SubCategoria.saveImage((json["imagen_subc"] as? String)!)
        newSubCategoria.imagen_subc = UIImagePNGRepresentation(imagen)
        newSubCategoria.imagen_subc_negativo = UIImagePNGRepresentation(imagennegativo)
        newSubCategoria.imagen_subc_app = UIImagePNGRepresentation(imagenapp)
        //Guardamos la informacion
        ap.saveContext()
        return newSubCategoria
        
    }
    
    class func saveImage(urlImagen: String)->UIImage{
        let url = NSURL(string: urlImagen)
        let data = NSData(contentsOfURL: url!)
        return  UIImage(data: data!)!
    }
    
    class func getSubCategoriasByCategoria(idCategoria: NSNumber)-> [SubCategoria]?{
        //let resquest = NSFetchRequest(entityName: "SubCategoria")
        let resquest = NSFetchRequest(entityName: "SubCategoria")
        resquest.predicate = NSPredicate(format: "idCategoria ="+idCategoria.stringValue)
        //resquest.sortDescriptors = [NSSortDescriptor(key: "idSubCategoria", ascending: true)]
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        let subcatSet = NSMutableSet()
        do{
            let subcats = try ap.managedObjectContext.executeFetchRequest(resquest) as! [SubCategoria]
            for subcat in subcats {
                //if(subcat.idCategoria == idCategoria){
                    subcatSet.addObject(subcat)
                //print(subcat.idSubCategoria)
                //}
            }
            
        }catch {
            return nil
        }
        
        return subcatSet.allObjects as? [SubCategoria]
    }
    
    
    
    class func getPeriodo()->NSNumber?{
        let resquest = NSFetchRequest(entityName: "SubCategoria")
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        do{
            let subcat = try ap.managedObjectContext.executeFetchRequest(resquest) as! [SubCategoria]
            if let _ = subcat.first{
                return subcat.first?.idPeriodo
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }
    
    class func getCategoria(idSubCategoria : String)->SubCategoria?{
        let resquest = NSFetchRequest(entityName: "SubCategoria")
        resquest.predicate = NSPredicate(format: "idSubCategoria ="+idSubCategoria)
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        do{
            let subcat = try ap.managedObjectContext.executeFetchRequest(resquest) as! [SubCategoria]
            if let _ = subcat.first{
                return subcat.first
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }

}
