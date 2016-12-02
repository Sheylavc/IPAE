//
//  PreguntasViewController.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 30/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class PreguntasViewController: UIViewController {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    private var regPregunta: [Pregunta]!
    var idSubCategoria: String!
    var subCategoria: String!
    var pageNum: Int!
    
    var categoria: Int!
    var total_paginas: Int!
    var posAcelera: Int! = 0
    
    var idTest: Int!
    var idPregunta: Int!
    var nSubCategorias: Int!
    
    var buttonNO: UIButton!
    var buttonSI: UIButton!
    var buttonProceso: UIButton!
    var buttonNA: UIButton!
    var labelNO: UILabel!
    var labelSI: UILabel!
    var labelProceso: UILabel!
    var labelNA: UILabel!
    
    
    @IBOutlet weak var txtPregunta: UILabel!
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var imgCabecera: UIImageView!
    @IBOutlet weak var imgSubCat: UIImageView!
    
    @IBOutlet weak var nameSubCat: UILabel!
    @IBOutlet weak var txtNumeracion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTest = Test.getidTest(1)
        nSubCategorias = SubCategoria.getSubCategoriasByCategoria(1)?.count
        createButtons()
        getPregunta()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLeft(sender: AnyObject) {
        
        let pagina = prefs.stringForKey("paginaAcelera")
        if Int(pagina!) > 1{
            prefs.setValue(Int(pagina!)! - 1, forKey: "paginaAcelera")
            getPregunta()
        }
        
    }
    
    @IBAction func btnRight(sender: AnyObject) {
        
        if Respuesta.checkRespuesta(idPregunta){
            setPagina()
        }
        
    }
    
    //Mark: Obtener Pregunta
    func getPregunta(){
        
        if let subCateg = prefs.stringForKey("subcatAcelera"){
            subCategoria = subCateg
        }else{
            subCategoria = idSubCategoria
        }

        let subCat = SubCategoria.getCategoria(subCategoria)!
        
        imgSubCat.image = UIImage(data: subCat.imagen_subc_app!)
        nameSubCat.text = subCat.nombre_subc!
        
        
        regPregunta = Pregunta.getPreguntasBySubCat(subCategoria)
        regPregunta.sortInPlace {(subcat1:Pregunta, subcat2:Pregunta) -> Bool in
            subcat1.idPregunta?.intValue < subcat2.idPregunta?.intValue
        }
        
        total_paginas = regPregunta.count
        
        if let pagina = prefs.stringForKey("paginaAcelera"){
            pageNum = Int(pagina)
        }else{
            pageNum = 1
            prefs.setValue(pageNum , forKey: "paginaAcelera")
        }
        
        if let pos = prefs.stringForKey("poscatAcelera"){
            posAcelera = Int(pos)
        }else{
            posAcelera = 0
            prefs.setValue(0 , forKey: "poscatAcelera")
        }

 
        txtNumeracion.text = String(pageNum)+" de "+String(total_paginas)
    
        let PreguntaSelected =  regPregunta[pageNum - 1]
        let pregunta = PreguntaSelected.pregunta
        
        txtPregunta.text = pregunta
        labelSI.text = PreguntaSelected.rp1
        labelProceso.text = PreguntaSelected.rp2
        labelNO.text = PreguntaSelected.rp3
        labelNA.text = ""
        
        
        if (PreguntaSelected.rp4 == "" || PreguntaSelected.rp4 == nil ){
            put3Buttons()
            
            
        }else{
            put4Buttons()
            
            labelNA.text = PreguntaSelected.rp4
        }
        
        idPregunta = Int(PreguntaSelected.idPregunta!)
        
        checkRespuesta()
        

    }
    
    
    
    //MARK: Actualizar Pagina
    func setPagina(){
        if(pageNum == total_paginas){
            if (nSubCategorias - 1) == Int(prefs.stringForKey("poscatAcelera")!){
                self.performSegueWithIdentifier("showFormAcelera", sender: 1)
            }else{
                prefs.setValue(1, forKey: "paginaAcelera")
                prefs.setValue(Int(subCategoria)! + 1, forKey: "subcatAcelera")
                prefs.setValue(posAcelera + 1, forKey: "poscatAcelera")
                getPregunta()
            }
            

        }else{
            let pagina = prefs.stringForKey("paginaAcelera")
            prefs.setValue(Int(pagina!)! + 1 , forKey: "paginaAcelera")
            getPregunta()
        }

    }
    
    //MARK: Seleccionar boton marcado anteriormente
    func checkRespuesta(){
        if Respuesta.checkRespuesta(idPregunta){
            let rp = Respuesta.getDataRespuesta(idPregunta)
            switch rp {
            case "SI":
                buttonSI.backgroundColor = UIColor.groupTableViewBackgroundColor()
                buttonSI.layer.cornerRadius=22
                buttonNO.backgroundColor = UIColor.clearColor()
                buttonProceso.backgroundColor = UIColor.clearColor()
                buttonNA.backgroundColor = UIColor.clearColor()
                break
            case "NO":
                buttonNO.backgroundColor = UIColor.groupTableViewBackgroundColor()
                buttonNO.layer.cornerRadius=22
                buttonSI.backgroundColor = UIColor.clearColor()
                buttonProceso.backgroundColor = UIColor.clearColor()
                buttonNA.backgroundColor = UIColor.clearColor()
                break
            case "EN PROCESO":
                buttonProceso.backgroundColor = UIColor.groupTableViewBackgroundColor()
                buttonProceso.layer.cornerRadius=22
                buttonSI.backgroundColor = UIColor.clearColor()
                buttonNO.backgroundColor = UIColor.clearColor()
                buttonNA.backgroundColor = UIColor.clearColor()
                break
            case "NO APLICA":
                buttonNA.backgroundColor = UIColor.groupTableViewBackgroundColor()
                buttonNA.layer.cornerRadius=22
                buttonSI.backgroundColor = UIColor.clearColor()
                buttonNO.backgroundColor = UIColor.clearColor()
                buttonProceso.backgroundColor = UIColor.clearColor()
                break
            default:
                break
            }
            
        }else{
            buttonProceso.backgroundColor = UIColor.clearColor()
            buttonSI.backgroundColor = UIColor.clearColor()
            buttonNO.backgroundColor = UIColor.clearColor()
            buttonNA.backgroundColor = UIColor.clearColor()
        }
    }
    
    //MARK: Accion de Botones
    func actionNo(sender:UIButton!) {
        Respuesta.createRespuesta(idTest, idPregunta: idPregunta, idSubCategoria: Int(subCategoria)!, rp: "NO")
        setPagina()
    
    }
    
    func actionProceso(sender:UIButton!) {
        Respuesta.createRespuesta(idTest, idPregunta: idPregunta, idSubCategoria: Int(subCategoria)!, rp: "EN PROCESO")
        setPagina()

    }
    
    func actionSi(sender:UIButton!) {
        Respuesta.createRespuesta(idTest, idPregunta: idPregunta, idSubCategoria: Int(subCategoria)!, rp: "SI")
        setPagina()
    }
    
    func actionNAplica(sender:UIButton!) {
        Respuesta.createRespuesta(idTest, idPregunta: idPregunta, idSubCategoria: Int(subCategoria)!, rp: "NO APLICA")
        setPagina()
    }
    
    //MARK: Creacion de botones
    func createButtons(){
        imgCabecera.image = UIImage(named:"acelera_b")!

        /* Button NO */
        
        let imageNo = UIImage(named: "no") as UIImage?
        buttonNO   = UIButton(type: UIButtonType.Custom) as UIButton
        buttonNO.frame = CGRectMake(0, 0, 100, 100)
        //buttonNO.contentMode = .Center
        buttonNO.setImage(imageNo, forState: .Normal)
        buttonNO.imageView?.contentMode = .ScaleAspectFit
        buttonNO.imageEdgeInsets = UIEdgeInsetsMake(40, 10, 40, 10)
        buttonNO.addTarget(self, action: #selector(PreguntasViewController.actionNo(_:)), forControlEvents: UIControlEvents.TouchDown)
        buttonNO.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonNO)
        
        /* Button PROCESO */
        let imageProceso = UIImage(named: "proceso") as UIImage?
        buttonProceso   = UIButton(type: UIButtonType.Custom) as UIButton
        buttonProceso.frame = CGRectMake(100, 100, 100, 100)
        buttonProceso.setImage(imageProceso, forState: .Normal)
        buttonProceso.imageView?.contentMode = .ScaleAspectFit
        buttonProceso.imageEdgeInsets = UIEdgeInsetsMake(40, 10, 40, 10)
        buttonProceso.addTarget(self, action: #selector(PreguntasViewController.actionProceso(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonProceso.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonProceso)
        
        /* Button SI */
        let imageSi = UIImage(named: "si") as UIImage?
        buttonSI   = UIButton(type: UIButtonType.Custom) as UIButton
        buttonSI.frame = CGRectMake(100, 100, 100, 100)
        buttonSI.setImage(imageSi, forState: .Normal)
        buttonSI.imageView?.contentMode = .ScaleAspectFit
        buttonSI.imageEdgeInsets = UIEdgeInsetsMake(40, 10, 40, 10)
        buttonSI.addTarget(self, action: #selector(PreguntasViewController.actionSi(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonSI.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSI)
        
        /* Button No Aplica */
        let image = UIImage(named: "noaplica") as UIImage?
        buttonNA   = UIButton(type: UIButtonType.Custom) as UIButton
        buttonNA.frame = CGRectMake(100, 100, 100, 100)
        buttonNA.setImage(image, forState: .Normal)
        buttonNA.imageView?.contentMode = .ScaleAspectFit
        buttonNA.imageEdgeInsets = UIEdgeInsetsMake(40, 10, 40, 10)
        buttonNA.addTarget(self, action: #selector(PreguntasViewController.actionNAplica(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        buttonNA.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonNA)
        
        labelSI = UILabel(frame: CGRectMake(0,0,100, 21))
        labelSI.font = labelSI.font.fontWithSize(12)
        labelSI.textColor = UIColor.lightGrayColor()
        labelSI.textAlignment = NSTextAlignment.Center
        labelSI.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelSI)

        
        labelNO = UILabel(frame: CGRectMake(0,0,100, 21))
        labelNO.font = labelNO.font.fontWithSize(12)
        labelNO.textColor = UIColor.lightGrayColor()
        labelNO.textAlignment = NSTextAlignment.Center
        labelNO.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelNO)
        
        labelProceso = UILabel(frame: CGRectMake(0,0,100, 21))
        labelProceso.font = labelProceso.font.fontWithSize(12)
        labelProceso.textColor = UIColor.lightGrayColor()
        labelProceso.textAlignment = NSTextAlignment.Center
        labelProceso.numberOfLines = 0
        labelProceso.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelProceso)
        
        labelNA = UILabel(frame: CGRectMake(0,0,100, 21))
        labelNA.font = labelNA.font.fontWithSize(12)
        labelNA.textColor = UIColor.lightGrayColor()
        labelNA.textAlignment = NSTextAlignment.Center
        labelNA.numberOfLines = 0
        labelNA.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelNA)
        
    }
    
    //MARK: Establecer Botones
    func put3Buttons(){
        
        imgCircle.image = UIImage(named:"circle_a")!
        
        buttonNO.hidden = false
        buttonSI.hidden = false
        buttonProceso.hidden = false
        buttonNA.hidden = true
        
        labelNO.hidden = false
        labelSI.hidden = false
        labelProceso.hidden = false
        labelNA.hidden = true
 
        putButtonNoConstrains("3")
        putButtonProcesoConstrains("3")
        putButtonSiConstrains("3")
    }
    
    func put4Buttons(){
        
        imgCircle.image = UIImage(named:"circle2_a")!
        
        buttonNO.hidden = false
        buttonSI.hidden = false
        buttonProceso.hidden = false
        buttonNA.hidden = false
        
        labelNO.hidden = false
        labelSI.hidden = false
        labelProceso.hidden = false
        labelNA.hidden = false
        
        putButtonNoConstrains("4")
        putButtonProcesoConstrains("4")
        putButtonSiConstrains("4")
        putButtonNoAplicaConstrains()
        
    }
    
    //MARK: Constraints
    func putButtonNoConstrains(tipo: String){
        var removeConstraintsNO : [NSLayoutConstraint] = []
        var removeConstraintsLNO : [NSLayoutConstraint] = []
        for constraintB in self.view.constraints
        {
            if constraintB.firstItem === self.buttonNO
            {
                removeConstraintsNO.append(constraintB)
            }
            if constraintB.firstItem === self.labelNO
            {
                removeConstraintsLNO.append(constraintB)
            }
        }
        
        self.view.removeConstraints(removeConstraintsNO)
        self.view.removeConstraints(removeConstraintsLNO)
        self.buttonNO.removeConstraints(self.buttonNO.constraints)
        self.buttonNO.translatesAutoresizingMaskIntoConstraints = false
        self.labelNO.removeConstraints(self.labelNO.constraints)
        self.labelNO.translatesAutoresizingMaskIntoConstraints = false
        
        let view = self.view
        
        /* Constrains Button NO */
        /* Height */
        let heightConstraint = NSLayoutConstraint(
            item: self.buttonNO,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        /* Width */
        let widthConstraint = NSLayoutConstraint(
            item: self.buttonNO,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        let n: CGFloat!
        let nL: CGFloat!
        let L: CGFloat!
        let Lb: CGFloat!
        if (tipo == "3") { n = -40; L = 35; nL = -20; Lb = 35 }else{ n = -20; L = 20; nL = -8; Lb = 20 }
        /* Bottom */
        let bottomConstraint = NSLayoutConstraint(
            item: self.buttonNO,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: n
        )
        /* Left */
        let leftConstraint = NSLayoutConstraint(
            item: self.buttonNO,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: L
        )
        
        /* Constrains Label NO */
        let heightLConstraint = NSLayoutConstraint(
            item: self.labelNO,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 15
        )
        /* Width */
        let widthLConstraint = NSLayoutConstraint(
            item: self.labelNO,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        let bottomLConstraint = NSLayoutConstraint(
            item: self.labelNO,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: nL
        )
        /* Left */
        let leftLConstraint = NSLayoutConstraint(
            item: self.labelNO,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: Lb
        )
        
        
            
        view.addConstraint(heightConstraint)
        view.addConstraint(widthConstraint)
        view.addConstraint(bottomConstraint)
        view.addConstraint(leftConstraint)
        
        view.addConstraint(heightLConstraint)
        view.addConstraint(widthLConstraint)
        view.addConstraint(bottomLConstraint)
        view.addConstraint(leftLConstraint)
    }
    func putButtonSiConstrains(tipo : String){
        var removeConstraintsSI : [NSLayoutConstraint] = []
        var removeConstraintsLSI : [NSLayoutConstraint] = []
        for constraintB in self.view.constraints
        {
            if constraintB.firstItem === self.buttonSI
            {
                removeConstraintsSI.append(constraintB)
            }
            if constraintB.firstItem === self.labelSI
            {
                removeConstraintsLSI.append(constraintB)
            }
        }
        
        self.view.removeConstraints(removeConstraintsSI)
        self.view.removeConstraints(removeConstraintsLSI)
        self.buttonSI.removeConstraints(self.buttonSI.constraints)
        self.buttonSI.translatesAutoresizingMaskIntoConstraints = false
        self.labelSI.removeConstraints(self.labelSI.constraints)
        self.labelSI.translatesAutoresizingMaskIntoConstraints = false
        
        let view = self.view
        
        /* Constrains Button SI */
        /* Height */
        let heightConstraint = NSLayoutConstraint(
            item: self.buttonSI,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        /* Width */
        let widthConstraint = NSLayoutConstraint(
            item: self.buttonSI,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        
        let n: CGFloat!
        let nL: CGFloat!
        let L: CGFloat!
        let Lb: CGFloat!
        
        if (tipo == "3") { n = -40; L = -35;  nL = -20 ; Lb = -35}else{ n = -20; L = -20; nL = -8; Lb = -20 }
        /* Bottom */
        let bottomConstraint = NSLayoutConstraint(
            item: self.buttonSI,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: n
        )
        /* Rigth */
        let rigthConstraint = NSLayoutConstraint(
            item: self.buttonSI,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: L
        )
        
        /* Constrains Label SI */
        let heightLConstraint = NSLayoutConstraint(
            item: self.labelSI,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 15
        )
        /* Width */
        let widthLConstraint = NSLayoutConstraint(
            item: self.labelSI,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        let bottomLConstraint = NSLayoutConstraint(
            item: self.labelSI,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: nL
        )
        /* Right */
        let rigthLConstraint = NSLayoutConstraint(
            item: self.labelSI,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: Lb
        )
        
        
        view.addConstraint(heightConstraint)
        view.addConstraint(widthConstraint)
        view.addConstraint(bottomConstraint)
        view.addConstraint(rigthConstraint)
        
        view.addConstraint(heightLConstraint)
        view.addConstraint(widthLConstraint)
        view.addConstraint(bottomLConstraint)
        view.addConstraint(rigthLConstraint)
    }
    
    func putButtonProcesoConstrains(tipo: String){
        var removeConstraintsB : [NSLayoutConstraint] = []
        var removeConstraintsL : [NSLayoutConstraint] = []
        for constraintB in self.view.constraints
        {
            if constraintB.firstItem === self.buttonProceso
            {
                removeConstraintsB.append(constraintB)
            }
            if constraintB.firstItem === self.labelProceso
            {
                removeConstraintsL.append(constraintB)
            }
        }
        
        self.view.removeConstraints(removeConstraintsB)
        self.view.removeConstraints(removeConstraintsL)
        self.buttonProceso.removeConstraints(self.buttonProceso.constraints)
        self.buttonProceso.translatesAutoresizingMaskIntoConstraints = false
        self.labelProceso.removeConstraints(self.labelProceso.constraints)
        self.labelProceso.translatesAutoresizingMaskIntoConstraints = false
        
        
        let view = self.view

        /* Constrains Button Proceso */
        /* Height */
        let heightConstraint = NSLayoutConstraint(
            item: self.buttonProceso,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        /* Width */
        let widthConstraint = NSLayoutConstraint(
            item: self.buttonProceso,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        
        if (tipo == "3") {
            /* Center X */
            let centerXConstraint = NSLayoutConstraint(
                item: self.buttonProceso,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0
            )
            /* Bottom */
            let bottomXConstraint = NSLayoutConstraint(
                item: self.buttonProceso,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: -98
            )
            view.addConstraint(centerXConstraint)
            view.addConstraint(bottomXConstraint)
            
            let centerLXConstraint = NSLayoutConstraint(
                item: self.labelProceso,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0
            )
            /* Bottom */
            let bottomLConstraint = NSLayoutConstraint(
                item: self.labelProceso,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: -73
            )
            
            view.addConstraint(centerLXConstraint)
            view.addConstraint(bottomLConstraint)
            
        }else{
            /* Bottom */
            let bottomConstraint = NSLayoutConstraint(
                item: self.buttonProceso,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: -90
            )
            /* Left */
            let leftConstraint = NSLayoutConstraint(
                item: self.buttonProceso,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1.0,
                constant: 90
            )
            view.addConstraint(bottomConstraint)
            view.addConstraint(leftConstraint)
            
            /* Bottom */
            let bottomLConstraint = NSLayoutConstraint(
                item: self.labelProceso,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: -65
            )
            /* Left */
            let leftLConstraint = NSLayoutConstraint(
                item: self.labelProceso,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1.0,
                constant: 65
            )
            view.addConstraint(bottomLConstraint)
            view.addConstraint(leftLConstraint)
            
        }
        
        /* Constrains Label Proceso */
        let heightLConstraint = NSLayoutConstraint(
            item: self.labelProceso,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 30
        )
        /* Width */
        let widthLConstraint = NSLayoutConstraint(
            item: self.labelProceso,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 100
        )
        
        
        view.addConstraint(heightConstraint)
        view.addConstraint(widthConstraint)
        
        view.addConstraint(heightLConstraint)
        view.addConstraint(widthLConstraint)

    }
    
    
    
    func putButtonNoAplicaConstrains(){
        
        let view = self.view

        /* Constrains Button NO Aplica */
        /* Height */
        let heightConstraint = NSLayoutConstraint(
            item: self.buttonNA,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        /* Width */
        let widthConstraint = NSLayoutConstraint(
            item: self.buttonNA,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 50
        )
        /* Bottom */
        let bottomConstraint = NSLayoutConstraint(
            item: self.buttonNA,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: -90
        )
        /* Rigth */
        let rigthConstraint = NSLayoutConstraint(
            item: self.buttonNA,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: -100
        )
        
        /* Constrains Label NO Aplica */
        /* Height */
        let heightLConstraint = NSLayoutConstraint(
            item: self.labelNA,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 30
        )
        /* Width */
        let widthLConstraint = NSLayoutConstraint(
            item: self.labelNA,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 70
        )
        /* Bottom */
        let bottomLConstraint = NSLayoutConstraint(
            item: self.labelNA,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: -65
        )
        /* Rigth */
        let rigthLConstraint = NSLayoutConstraint(
            item: self.labelNA,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: -80
        )
        
        view.addConstraint(heightConstraint)
        view.addConstraint(widthConstraint)
        view.addConstraint(bottomConstraint)
        view.addConstraint(rigthConstraint)
        
        view.addConstraint(heightLConstraint)
        view.addConstraint(widthLConstraint)
        view.addConstraint(bottomLConstraint)
        view.addConstraint(rigthLConstraint)
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showFormAcelera"
        {
            let nav = segue.destinationViewController as! UINavigationController
            let detailViewController = nav.topViewController as! FormularioViewController
            detailViewController.idCategoria = sender as? Int
        }
    }
    

}
