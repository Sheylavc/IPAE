//
//  FormularioViewController.swift
//  DiagnosticoIPAE
//
//  Created by ucweb on 6/10/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class FormularioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    private let textoArray : [String] = ["Nombres y Apellidos", "Correo", "Teléfono", "Cargo de la Empresa", "Razón Social", "Área de Preocupación"]
    private let placeholderArray : [String] = ["Obligatorio", "correo@example.com", "+51 995563456", "Obligatorio", "Obligatorio","Seleccione"]
    var pickerAreas: UIPickerView!
    
    var txtNombres: UITextField!
    var txtCorreo: UITextField!
    var txtTelefono: UITextField!
    var txtCargo: UITextField!
    var txtRazon: UITextField!
    var txtAreas: UITextField!
    var registrosAreas: [Area]!
    var idArea: Int!
    
    var idCategoria: Int!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrosAreas = Area.getAreasByCategoria(idCategoria)
        pickerAreas = UIPickerView()
        pickerAreas.delegate = self
        //print(idCategoria)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSendFormulario(sender: AnyObject) {
        
        if validarDatosIngresados(){
            notificationAlertwithOptions("", message: "¿Su empresa factura entre 10 millones a más anuales?")
        }else{
            AlertHelper.notificationAlert("Un Momento", message: "Todos los campos son requeridos", viewController: self)
        }
        
    }
    
    func validarDatosIngresados()-> Bool{
        if txtNombres.text!.characters.count > 0 && txtCorreo.text!.characters.count > 0 && txtTelefono.text!.characters.count > 0 && txtCargo.text!.characters.count > 0 && txtRazon.text!.characters.count > 0 && prefs.stringForKey("checked") == "1"{
            return true
        }else{
            return false
        }
    }
    
    func saveData(pregunta: String){
        Test.updateDataTest(idCategoria, idArea: idArea, fullname: txtNombres.text!, email: txtCorreo.text!, telefono: txtTelefono.text!, cargo: txtCargo.text!, razonsocial: txtRazon.text!, tenmillons: pregunta)
        
        
    }
    
    func sendRespuestas(){

        if Reachability.isConnectedToNetwork(){
            AlertHelper.showLoadingAlert(self)

            let idTest = Test.getidTest(idCategoria)
            let respuestas = Respuesta.getRespuestasByTest(idTest!)
            var arrayData : [AnyObject] = []
            let param:NSMutableDictionary = NSMutableDictionary()
        
            for respuesta in respuestas {
                param.setValue(respuesta.idTest!, forKey: "idTest")
                param.setValue(respuesta.idPregunta!, forKey: "idPregunta")
                param.setValue(respuesta.idSubcategoria!, forKey: "subCategoria")
                param.setValue(respuesta.rp!, forKey: "rp")
                let jsonData = try! NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
                arrayData.append(jsonString)
            }
            
            let parameters = "dataRespuestas=\(arrayData)"
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.saveRespuestas)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
                if let _ = responseObject{
                
                    do{
                        let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                        
                        let estado = dic["status"] as! Bool

                        dispatch_async(dispatch_get_main_queue(), {
                            if(estado){
                                
                                self.sendFormulario()
                            
                            }else{
                                AlertHelper.hideLoadingAlert(self)
                                AlertHelper.notificationAlert("Actualizacion", message: "No se ha podido procesar su solicitud, intente nuevamente.", viewController: self)
                            }
                        })
                    
                    }catch{
                    
                        AlertHelper.hideLoadingAlert(self)
                        AlertHelper.notificationAlert("Diagnostico", message: "No se ha podido procesar su solicitud, intente nuevamente.", viewController: self)
                    }
                
                }else{
                    AlertHelper.hideLoadingAlert(self)
                    AlertHelper.notificationAlert("Diagnostico", message: "No se ha podido procesar su solicitud, intente nuevamente.", viewController: self)
                }
            }
            task.resume()
        }else{
            AlertHelper.notificationAlert("DIAGNÓSTICO EMPRESARIAL IPAE", message: "Debe conectarse a internet para enviar sus respuestas", viewController: self)
        }
    
    }
    
    func sendFormulario(){
        //AlertHelper.showLoadingAlert(self)
        if Reachability.isConnectedToNetwork(){
            let test =  Test.getTest(idCategoria)
            let parameters = "idTest="+String(test?.idTest as! Int)+"&txtNombres="+String(test!.fullname!)+"&txtCorreo="+String(test!.email!)+"&txtCargo="+String(test!.cargo!)+"&txtTelefono="+String(test!.telefono!)+"&txtRazonSocial="+String(test!.razonsocial!)+"&cbAreas="+String(test?.idArea as! Int)+"&pregunta="+String(test!.tenmillons!)
        
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: DataURL.GlobalVariables.saveFormulario)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = session.dataTaskWithRequest(request) { (responseObject: NSData?, response: NSURLResponse?, error: NSError?) in
                if let _ = responseObject{
                    do{
                        let dic = try NSJSONSerialization.JSONObjectWithData(responseObject!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                        
                        let estado = dic["status"] as! Bool
                        let mensaje = dic["message"] as! String
                    
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            if(estado){
                                AlertHelper.hideLoadingAlert(self)
                            
                                self.notificationAlertwithOptionsFinal("DIAGNÓSTICO LISTO", message: mensaje)
                           
                            }else{
                                AlertHelper.hideLoadingAlert(self)
                                AlertHelper.notificationAlert("Diagnostico", message: "No se ha podido procesar su solicitud, intente nuevamente.", viewController: self)
                            }
                        
                    })
                    
                    
                    
                    }catch{
                    
                        AlertHelper.hideLoadingAlert(self)
                        AlertHelper.notificationAlert("Diagnostico", message: "No se ha podido procesar su solicitud, intente nuevamente.", viewController: self)
                    }
                
                }else{
                    AlertHelper.hideLoadingAlert(self)
                    AlertHelper.notificationAlert("Diagnostico", message: "No se ha podido procesar su solicitud, intente nuevamente.", viewController: self)
                }
            }
            task.resume()
        }else{
            AlertHelper.notificationAlert("DIAGNÓSTICO EMPRESARIAL IPAE", message: "Debe conectarse a internet para enviar sus respuestas", viewController: self)
        }
    }
   
    
    func notificationAlertwithOptions(title: String, message:String){
        
        //Create alert Controller _> title, message, style
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create button Action -> title, style, action
        let successAction = UIAlertAction(title: "SI", style: UIAlertActionStyle.Default) { action -> Void in
            
            self.saveData("SI")
            self.sendRespuestas()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default) { action -> Void in
            
            self.saveData("NO")
            self.sendRespuestas()
        }
        
        alertController.addAction(successAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    
    func notificationAlertwithOptionsFinal(title: String, message:String){
        
        //Create alert Controller _> title, message, style
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create button Action -> title, style, action
        let successAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default) { action -> Void in
            
            if(self.idCategoria == 1){
                self.prefs.removeObjectForKey("subcatAcelera")
                self.prefs.removeObjectForKey("paginaAcelera")
                self.prefs.removeObjectForKey("poscatAcelera")
                
                let idTest = Test.getTest(self.idCategoria!)?.idTest
                Respuesta.deleteRespuestas(idTest!)
                Test.deleteTest(self.idCategoria!)
                
            }else{
                self.prefs.removeObjectForKey("subcatInnova")
                self.prefs.removeObjectForKey("paginaInnova")
                self.prefs.removeObjectForKey("poscatInnova")
                
                let idTest = Test.getTest(self.idCategoria!)?.idTest
                Respuesta.deleteRespuestas(idTest!)
                Test.deleteTest(self.idCategoria!)
            }
            
            self.presentingViewController!.presentingViewController!.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        alertController.addAction(successAction)

        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textoArray.count + 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioCell", forIndexPath: indexPath) as! FormularioCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.txtLabel.text = textoArray[indexPath.row]
            cell.txtInput.placeholder = placeholderArray[indexPath.row]
            txtNombres = cell.txtInput
            return cell
        }
        else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioCell", forIndexPath: indexPath) as! FormularioCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.txtInput.keyboardType = UIKeyboardType.EmailAddress
            cell.txtLabel.text = textoArray[indexPath.row]
            cell.txtInput.placeholder = placeholderArray[indexPath.row]
            txtCorreo =  cell.txtInput
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioCell", forIndexPath: indexPath) as! FormularioCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.txtInput.keyboardType = UIKeyboardType.NamePhonePad
            cell.txtLabel.text = textoArray[indexPath.row]
            cell.txtInput.placeholder = placeholderArray[indexPath.row]
            txtTelefono =  cell.txtInput
            return cell
        }
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioCell", forIndexPath: indexPath) as! FormularioCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.txtLabel.text = textoArray[indexPath.row]
            cell.txtInput.placeholder = placeholderArray[indexPath.row]
            txtCargo =  cell.txtInput
            return cell
        }
        else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioCell", forIndexPath: indexPath) as! FormularioCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.txtLabel.text = textoArray[indexPath.row]
            cell.txtInput.placeholder = placeholderArray[indexPath.row]
            txtRazon = cell.txtInput
            return cell
        }
        else if(indexPath.row == 5){
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioCell", forIndexPath: indexPath) as! FormularioCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            cell.txtLabel.text = textoArray[indexPath.row]
            cell.txtInput.placeholder = placeholderArray[indexPath.row]
            txtAreas = cell.txtInput
            cell.txtInput.inputView = pickerAreas
            cell.txtInput.inputAccessoryView = toolBarAreaPicker()
            return cell
            
        }
        else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioTCell", forIndexPath: indexPath) as! FormularioTCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FormularioBCell", forIndexPath: indexPath) as! FormularioBCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 7{
            return 70
        }else{
            return 50
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return registrosAreas.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return registrosAreas[row].area
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtAreas.text = registrosAreas![row].area
        idArea = Int(registrosAreas![row].idArea!)
    }
    
    //MARK: UITextField Delegate Methods

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }

    //MARK: Styles Picker ToolBar
    func centerLabel()->UIBarButtonItem{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = "Seleccione"
        label.textAlignment = NSTextAlignment.Center
        
        return UIBarButtonItem(customView: label)
    }
    
    func newToolBar()-> UIToolbar{
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.grayColor()
        return toolBar
    }
    
    func butonItem()->UIBarButtonItem{
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
    }
    
    func toolBarAreaPicker()->UIToolbar{
        
        let toolBar = newToolBar()
        let defaultButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FormularioViewController.tappedToolBarBtnArea))
        let doneButton = UIBarButtonItem(title:"Hecho", style: UIBarButtonItemStyle.Done, target: self, action: #selector(FormularioViewController.donePressedArea))
        toolBar.setItems([defaultButton,butonItem(),centerLabel(),butonItem(),doneButton], animated: true)
        return toolBar
    }
    
    func donePressedArea(sender: UIBarButtonItem) {
        txtAreas.resignFirstResponder()
    }
    
    func tappedToolBarBtnArea(sender: UIBarButtonItem) {
        txtAreas.resignFirstResponder()
        
    }
    
    

    
   

}
