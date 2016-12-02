//
//  TerminosViewController.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class TerminosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getTerminos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBOutlet weak var textoTerminos: UITextView!
    
    func getTerminos(){
        let Termino = Terminos.currentTermino()
        let texto = Termino?.texto
       
        do {
            let str = try NSAttributedString(data: texto!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            textoTerminos.attributedText = str
            textoTerminos.textAlignment = .Justified
            textoTerminos.userInteractionEnabled = false
           
            
        } catch {
            
        }
        
    }
    

}
