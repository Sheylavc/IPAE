//
//  SugerenciaViewController.swift
//  DIGE
//
//  Created by ucweb on 10/10/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class SugerenciaViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    @IBOutlet weak var txtNombres: UITextField!
    
    @IBOutlet weak var txtCorreo: UITextField!
    
    @IBOutlet weak var txtConsulta: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        txtConsulta.layer.borderWidth = 1;
        txtConsulta.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func btnSendSugerencia(sender: AnyObject) {
        
        if checkDatos(){
            sendSugerencia()
            
        }else{
             AlertHelper.notificationAlert("SUGERENCIA", message: "Todos los campos son requeridos", viewController: self)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }

    func checkDatos()->Bool{
        if txtNombres.text!.characters.count > 0 && txtCorreo.text!.characters.count > 0 && txtConsulta.text!.characters.count > 0 {
            return true
        }else{
            return false
        }
    }
    
    func sendSugerencia(){
        AlertHelper.showLoadingAlert(self)
        let parameters = "nombrecompleto="+String(txtNombres.text!)+"&correo="+String(txtCorreo.text!)+"&consulta="+String(txtConsulta.text)
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.saveSugerencia)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                    
                    AlertHelper.hideLoadingAlert(self)
                    AlertHelper.notificationAlert("SUGERENCIA", message: "Se ha enviado su sugerencia. Gracias", viewController: self)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                    
                }catch{
                    AlertHelper.hideLoadingAlert(self)
                    AlertHelper.notificationAlert("Actualizacion", message: "No se ha podido enviar tu sugerencia, intente nuevamente.", viewController: self)
                }
                
            }else{
                AlertHelper.hideLoadingAlert(self)
                AlertHelper.notificationAlert("Actualizacion", message: "No se ha podido enviar tu sugerencia, intente nuevamente.", viewController: self)
            }
        }
        task.resume()
    }


}
