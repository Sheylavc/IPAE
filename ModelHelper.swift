//
//  ModelHelper.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit
import CoreData

class ModelHelper: NSObject {
    
    
    class func getRegistros(viewcontroller : UIViewController){
        
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.getAllData)!)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                    
                    let data = dic["data"] as! [String: AnyObject]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if(Categoria.getCategorias() != nil){
                            ModelHelper.deleteData()
                        }
                        Categoria.addCategorias(data["dataCategorias"]!)
                        SubCategoria.addSubCategorias(data["dataSubcategorias"]!)
                        Pregunta.addPreguntas(data["dataPreguntas"]!)
                        Terminos.addTerminos(data["dataTerminos"]!)
                        Area.addAreas(data["dataArea"]!)
                       
                        
                    })
                    
                    
                    
                }catch{
                    AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "No se ha podido actualizar la información", viewController: viewcontroller)
                  
                }
                
            }else{
                AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "No se ha podido actualizar la información", viewController: viewcontroller)
            }
        }
        task.resume()
    }
    
    class func updateTerminos(viewcontroller : UIViewController){
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.getTerminos)!)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                    //print(dic)
                    let data = dic["data"] as! [String: AnyObject]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        deleteTerminos()
                        Terminos.addTerminos(data["dataTerminos"]!)
                        prefs.setValue(false, forKey: "Notification")
                        AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE", message: "Se ha actualizado la información correctamente.", viewController: viewcontroller)
                        
                        
                    })
                    
                    
                    
                }catch{
                    
                    AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "No se ha podido actualizar la información", viewController: viewcontroller)
                }
                
            }else{
                AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "No se ha podido actualizar la información", viewController: viewcontroller)
            }
        }
        task.resume()
    }
    
    class func updateAreas(viewcontroller : UIViewController){
        
        let prefs = NSUserDefaults.standardUserDefaults()
        //AlertHelper.showLoadingAlert(viewcontroller)
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.getAreas)!)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                    
                    let data = dic["data"] as! [String: AnyObject]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        deleteAreas()
                        Area.addAreas(data["dataArea"]!)
                        prefs.setValue(false, forKey: "Notification")
                        
                        AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE", message: "Se ha actualizado la información correctamente.", viewController: viewcontroller)
                        
                    })
                    
                    
                    
                }catch{
                    
                    //AlertHelper.hideLoadingAlert(viewcontroller)
                    AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE", message: "No se ha podido actualizar la información, intente nuevamente.", viewController: viewcontroller)
                }
                
            }else{
                //AlertHelper.hideLoadingAlert(viewcontroller)
                AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE", message: "No se ha podido actualizar la información, intente nuevamente.", viewController: viewcontroller)
            }
        }
        task.resume()
    }
    
    
    class func updateToken(token: String, idTest: Int){
        let parameters = "idTest=\(idTest)&token=\(token)"
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.updateToken)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                    print(dic)
                   
                }catch{
                }
            }else{
            }
        }
        task.resume()
    }
    
    
    
    
    class func deleteData(){
        deletePreguntas()
        deleteSubCategorias()
        deleteRespuestas()
        deleteAreas()
        deleteTerminos()
        deleteTest()
        
    }
    
    
    class func deletePreguntas() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let coord = app.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Pregunta")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    class func deleteSubCategorias() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let coord = app.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "SubCategoria")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    class func deleteRespuestas() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let coord = app.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Respuesta")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    class func deleteTest() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let coord = app.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Test")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    class func deleteTerminos() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let coord = app.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Terminos")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    class func deleteAreas() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let coord = app.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Area")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    
    
}
