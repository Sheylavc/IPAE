//
//  MainViewController.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 27/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

class MainViewController: UIViewController {

    let prefs = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        

        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(checkNotification), name: UIApplicationDidBecomeActiveNotification , object: nil)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func checkNotification(notification: NSNotification){

        
        if prefs.boolForKey("Notification"){
            
            if Reachability.isConnectedToNetwork(){
                let type = prefs.integerForKey("TypeN")
                switch type {
                case 1:
                    AlertHelper.notificationAlertUpdate(self)
                    break
                case 2:
                    ModelHelper.updateAreas(self)
                    break
                case 3:
                    ModelHelper.updateTerminos(self)
                    break
                case 4:
                    let id = prefs.stringForKey("identifierN")
                    notificationAlertQuestionUpdate(self, identifier: id!)
                    
                    break
                default:
                    break
                }
            }else{
                AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "Debe conectarse a internet para actualizar la información", viewController: self)
            }
            
           
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

    
    @IBAction func btnAcelera(sender: AnyObject) {
        checkTest(1)
    }

    
    @IBAction func btnInnova(sender: AnyObject) {
        checkTest(2)
    }
    
    func checkTest(idCategoria: Int){
        if Test.checkTest(idCategoria) {
            if(idCategoria == 1){
                self.performSegueWithIdentifier("loadAcelera", sender: idCategoria)
            }else{
                self.performSegueWithIdentifier("loadInnova", sender: idCategoria)
            }
            
            
        }else{
            Test.startTest(self, idCategoria: idCategoria)
            
        }
        
    }
    
    func loadData(){
        if ( checkData() ){
            
            //self.performSegueWithIdentifier("principal", sender: nil)
            
        }else{
            if Reachability.isConnectedToNetwork(){
                ModelHelper.getRegistros(self)

            }else{
                AlertHelper.notificationAlert("DIAGNÓSTICO EMPRESARIAL IPAE", message: "Debe conectarse a internet para actualizar la información antes de empezar", viewController: self)
            }
            
        }
    }
    func checkData()-> Bool{
        return Categoria.getCategorias() != nil ? true : false
    }
    
    
    //MARK: Alert Helper to Question Update
    func notificationAlertQuestionUpdate(viewController : UIViewController, identifier :String){
        
        //Create alert Controller _> title, message, style
        let alertController = UIAlertController(title: "ACTUALIZACIÓN DIGE IPAE", message: "IPAE tiene una actualización de pregunta, ir a la pregunta actualizada", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create button Action -> title, style, action
        let successAction = UIAlertAction(title: "SI", style: UIAlertActionStyle.Default) { action -> Void in
            self.updatePregunta(viewController, id: identifier)
            
            
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default) { action -> Void in
            
            
        }
        
        alertController.addAction(successAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    func updatePregunta(viewcontroller : UIViewController , id: String){
        
        let prefs = NSUserDefaults.standardUserDefaults()

        let parameters = "idPregunta=\(id)"
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.updatePregunta)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
            if let _ = responseObject{
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
    
                    let data = dic["data"]

                    //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)){
                    dispatch_async(dispatch_get_main_queue()) {
                        let idsubcat =  Pregunta.updatePregunta(data!)
                        
                        let subcat = SubCategoria.getCategoria(idsubcat!)
                        
                        let categoria = subcat?.idCategoria!
                        
                        let numPreg: Int = Pregunta.getPreguntasBySubCat(idsubcat!)!.count
                        let pagina:Int?
                        let pos:Int?
                        
                        prefs.setValue(false, forKey: "Notification")
                        
                        
                        if Test.checkTest(subcat!.idCategoria!.integerValue){
                            
                            if(categoria == 1){
                                if(Int(id) > numPreg){
                                    pagina = Int(id)! % numPreg
                                    pos = Int(id)! / numPreg
                                }else{
                                    pagina = Int(id)!
                                    pos = 0
                                }
                                
                                prefs.setValue(pagina, forKey: "paginaAcelera")
                                prefs.setValue(idsubcat, forKey: "subcatAcelera")
                                prefs.setValue(pos, forKey: "poscatAcelera")
                                self.performSegueWithIdentifier("showPreguntaA", sender: idsubcat)
                            }else if(categoria == 2){
                                if(Int(id) > numPreg){
                                    pagina = Int(id)! % numPreg
                                    pos = Int(id)! / numPreg
                                }else{
                                    pagina = Int(id)!
                                    pos = 0
                                }
                                prefs.setValue(pagina, forKey: "paginaInnova")
                                prefs.setValue(idsubcat, forKey: "subcatInnova")
                                prefs.setValue(pos, forKey: "poscatInnova")
                                self.performSegueWithIdentifier("showPreguntaI", sender: idsubcat)
                            }
                        }
                        
                        
                        
                        
                    }
                    //}
                    
                    
                    
                    
                }catch{
                    AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "No se ha podido actualizar la información", viewController: viewcontroller)
                   
                }
                
            }else{

                AlertHelper.notificationAlert("ACTUALIZACIÓN DIGE IPAE ", message: "No se ha podido actualizar la información", viewController: viewcontroller)
            }
        }
        task.resume()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "loadInnova" {

        }
        if segue.identifier == "loadAcelera" {
        }
        if segue.identifier == "showPreguntaI" {
        }
        if segue.identifier == "showPreguntaA" {
        }
    }


}
