//
//  AlertHelper.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    
    //MARK: Simple Notification Alert
    class func notificationAlert(title: String, message:String, viewController : UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let successAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //NSLog("OK Pressed")
        }
        
        alertController.addAction(successAction)
        
        viewController.presentViewController(alertController, animated: true, completion:nil)
    }
    //MARK: Notification Alert with Options
    class func notificationAlertwithOptions(title: String, message:String, viewController : UIViewController){
        
        //Create alert Controller _> title, message, style
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create button Action -> title, style, action
        let successAction = UIAlertAction(title: "SI", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        
        alertController.addAction(successAction)
        alertController.addAction(cancelAction)
        
        viewController.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    //MARK: Loading Notification Alert
    
    class func showLoadingAlert(viewController : UIViewController){
        let alert = UIAlertController(title: nil, message: "Espere un momento...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func hideLoadingAlert(viewController : UIViewController){
        
        viewController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK: Alert Helper to Full Update
    class func notificationAlertUpdate(viewController : UIViewController){
        
        //Create alert Controller _> title, message, style
        let alertController = UIAlertController(title: "ACTUALIZACIÓN DIGE IPAE", message: "IPAE tiene una actualización de preguntas, si acepta se reiniciarán todas las preguntas, ¿está de acuerdo?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create button Action -> title, style, action
        let successAction = UIAlertAction(title: "SI", style: UIAlertActionStyle.Default) { action -> Void in
            
            
            ModelHelper.getRegistros(viewController)
            
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default) { action -> Void in
            
            
        }
        
        alertController.addAction(successAction)
        alertController.addAction(cancelAction)
        
        viewController.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    
}
