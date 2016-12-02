//
//  Categoria.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Categoria: NSManagedObject {

    class func addCategorias(json: AnyObject)->[Categoria]{
        let categorias = json as![AnyObject]
        let categoriaSet = NSMutableSet()
        
        for categoria in categorias {
            categoriaSet.addObject(Categoria.createCategoria(categoria))
            
        }
        return categoriaSet.allObjects as! [Categoria]
    }
    
    class func createCategoria(json: AnyObject)-> Categoria {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let newCategoria = NSEntityDescription.insertNewObjectForEntityForName("Categoria", inManagedObjectContext: ap.managedObjectContext) as! Categoria
        //Asignamos los valores
        newCategoria.idCategoria =  NSNumber(integer: Int((json["idCategoria"] as! String))!)
        newCategoria.nombre_cat = json["nombre_cat"] as? String
        newCategoria.descripcion_cat = json["descripcion_cat"] as? String
        
        //Guardamos la informacion
        ap.saveContext()
        return newCategoria
        
    }
    class func getCategorias()->[Categoria]?{
        let resquest = NSFetchRequest(entityName: "Categoria")
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        do{
            let categoria = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Categoria]
            if let _ = categoria.first{
                return categoria
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }
    
    

}
