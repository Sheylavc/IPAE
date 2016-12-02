//
//  ListadoViewController.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 28/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class ListadoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let prefs = NSUserDefaults.standardUserDefaults()
    private var registrosSubCategoria: [SubCategoria]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCategoria()

    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableview.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var imagenCategoria: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    func checkSelected(){
        var posA = 0
        if let pos = prefs.stringForKey("poscatAcelera"){
            posA = Int(pos)!
        }
        

        let indexPath:NSIndexPath = NSIndexPath(forRow:  posA, inSection: 0)
        self.tableview.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        
        let cell = self.tableView(self.tableview, cellForRowAtIndexPath: indexPath) as! SubCategoriaCell
        
        cell.nombreSubCat.text = registrosSubCategoria[indexPath.row].nombre_subc
        cell.nombreSubCat.textColor = UIColor(red: 13/255, green: 126/255, blue: 196/255, alpha: 1.0)
        cell.imagenSubCat.image = UIImage(data: registrosSubCategoria[indexPath.row].imagen_subc!)
        
        self.tableView(self.tableview, willSelectRowAtIndexPath: indexPath)

    }
    
    func checkCategoria(){
        self.title = "ACELERA+"
        imagenCategoria.image = UIImage(named:"acelera")!
        registrosSubCategoria = SubCategoria.getSubCategoriasByCategoria(1)
        
        registrosSubCategoria.sortInPlace {(subcat1:SubCategoria, subcat2:SubCategoria) -> Bool in
            subcat1.idSubCategoria?.intValue < subcat2.idSubCategoria?.intValue
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrosSubCategoria?.count == nil ? 0 : registrosSubCategoria.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SubCategoriaACell", forIndexPath: indexPath) as! SubCategoriaCell
        var posA = 0
        if let pos = prefs.stringForKey("poscatAcelera"){
            posA = Int(pos)!
        }
        if(indexPath.row <= posA){
            cell.nombreSubCat.text = registrosSubCategoria[indexPath.row].nombre_subc
            cell.nombreSubCat.textColor = UIColor(red: 13/255, green: 126/255, blue: 196/255, alpha: 1.0)
            cell.imagenSubCat.image = UIImage(data: registrosSubCategoria[indexPath.row].imagen_subc!)
        }else{
            cell.imagenSubCat.image = UIImage(data: registrosSubCategoria[indexPath.row].imagen_subc_negativo!)
            cell.nombreSubCat.text = registrosSubCategoria[indexPath.row].nombre_subc
        }
        
        return cell
            
        
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var posA = 0
        if let pos = prefs.stringForKey("poscatAcelera"){
            posA = Int(pos)!
        }
        if(indexPath.row == posA){
            return indexPath
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showAPregunta", sender: registrosSubCategoria[indexPath.row].idSubCategoria!.stringValue)
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showAPregunta"
        {
            let nav = segue.destinationViewController as! UINavigationController
            let detailViewController = nav.topViewController as! PreguntasViewController
            detailViewController.idSubCategoria = sender as? String
        }
    }
    
    

    

}
