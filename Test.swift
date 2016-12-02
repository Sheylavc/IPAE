//
//  Test.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Test: NSManagedObject {

    class func startTest(viewcontroller : UIViewController, idCategoria: Int){
        let prefs = NSUserDefaults.standardUserDefaults()
        let code = prefs.stringForKey("code")!
        AlertHelper.showLoadingAlert(viewcontroller)
        
        let dateformatter = NSDateFormatter()
        dateformatter.timeZone = NSTimeZone(name: "America/Lima")
        dateformatter.dateFormat = "yyyy-MM-dd h:mm:ss"
        let now = dateformatter.stringFromDate(NSDate())
        
        let periodo = SubCategoria.getPeriodo()
        
        let parameters = "idCategoria="+String(idCategoria as Int)+"&fecha="+String(now)+"&idPeriodo="+String(periodo as! Int)+"&from=IOS&token="+code
        //+"&token=hhdhdhdhd"+"&idPeriodo="+periodo!+"&from=IOS"+"fecha="+now+

        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.startTest)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                    
                    let idTest = dic["id"] as! Int
                    
                    createTest(idCategoria, idPeriodo: periodo as! Int, fecha: String(now), token: "hdhdhdhdhdhdhdhd", idTest: idTest)
                    

                    dispatch_async(dispatch_get_global_queue(qos_class_main(), 0)){
                    dispatch_async(dispatch_get_main_queue(), {
                        AlertHelper.hideLoadingAlert(viewcontroller)
                        if(idCategoria == 1){
                            viewcontroller.performSegueWithIdentifier("loadAcelera", sender: idCategoria)
                        }else{
                            viewcontroller.performSegueWithIdentifier("loadInnova", sender: idCategoria)
                        }
                    })
                        
                    }
                    
                    
                    
                    
                    
                }catch{
                    //AlertHelper.hideLoadingAlert(viewcontroller)
                    AlertHelper.notificationAlert("Actualizacion", message: "No se ha podido crear un Test, intente nuevamente.", viewController: viewcontroller)
                }
                
            }else{
                //AlertHelper.hideLoadingAlert(viewcontroller)
                AlertHelper.notificationAlert("Actualizacion", message: "No se ha podido crear un Test, intente nuevamente.", viewController: viewcontroller)
            }
        }
        task.resume()

    }
    
    class func createTest(idCategoria: Int, idPeriodo: Int, fecha : String, token: String, idTest: Int) {
        
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let newTest = NSEntityDescription.insertNewObjectForEntityForName("Test", inManagedObjectContext: ap.managedObjectContext) as! Test
        //Asignamos los valores
        newTest.idTest =  idTest
        newTest.idCategoria = idCategoria
        newTest.idPeriodo = idPeriodo
        newTest.fecha = fecha
        newTest.token = token
        
        //Guardamos la informacion
        ap.saveContext()
        
        
    }
    class func checkTest(idCategoria: Int)->Bool{
        
        let resquest = NSFetchRequest(entityName: "Test")
        resquest.predicate = NSPredicate(format: "idCategoria = "+String(idCategoria))
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        do{
            let test = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Test]
            if let _ = test.first{
                return true
            }else{
                return false
            }
            
        }catch {
            return false
        }
        
    }
    
    
    
    class func getidTest(idCategoria: Int)->Int?{
        
        let resquest = NSFetchRequest(entityName: "Test")
        resquest.predicate = NSPredicate(format: "idCategoria = "+String(idCategoria))
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        do{
            let test = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Test]
            if let _ = test.first{
                return Int((test.first?.idTest!)!)
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }
    
    class func getTest(idCategoria: Int)->Test?{
        
        let resquest = NSFetchRequest(entityName: "Test")
        resquest.predicate = NSPredicate(format: "idCategoria = "+String(idCategoria))
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        do{
            let test = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Test]
            if let _ = test.first{
                return test.first
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
        
    }
    
    class func updateDataTest(idCategoria: Int, idArea: Int, fullname: String, email: String, telefono: String, cargo: String, razonsocial: String, tenmillons: String){
        
        let resquest = NSFetchRequest(entityName: "Test")
        resquest.predicate = NSPredicate(format: "idCategoria = "+String(idCategoria))
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        do{
            let test = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Test]
            if let test = test.first{
                test.idArea = idArea
                test.fullname = fullname
                test.email = email
                test.telefono = telefono
                test.cargo = cargo
                test.razonsocial = razonsocial
                test.tenmillons = tenmillons
                ap.saveContext()
                //return Int((test.first?.idTest!)!)
            }else{
                //return nil
            }
            
        }catch {
            //return nil
        }
        
    }
    
    class func deleteTest(idCategoria: Int){
        
        let resquest = NSFetchRequest(entityName: "Test")
        resquest.predicate = NSPredicate(format: "idCategoria = "+String(idCategoria))
        let ap = UIApplication.sharedApplication().delegate as! AppDelegate
        
        do{
            let test = try ap.managedObjectContext.executeFetchRequest(resquest) as! [Test]
            if let _ = test.first{
                ap.managedObjectContext.deleteObject(test.first!)
            }else{
                
            }
            
        }catch {
            
        }
        
    }
    
    
    
}
