//
//  ListadoIViewController.swift
//  DiagnosticoIPAE
//
//  Created by ucweb on 5/10/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class ListadoIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let prefs = NSUserDefaults.standardUserDefaults()
    private var registrosSubCategoria: [SubCategoria]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCategoria()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        
        self.tableview.reloadData()
    }
    
    @IBOutlet weak var imagenCategoria: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func checkCategoria(){
        self.title = "INNOVA+"
        imagenCategoria.image = UIImage(named:"innova")!
        registrosSubCategoria = SubCategoria.getSubCategoriasByCategoria(2)
        
        registrosSubCategoria.sortInPlace {(subcat1:SubCategoria, subcat2:SubCategoria) -> Bool in
            subcat1.idSubCategoria?.intValue < subcat2.idSubCategoria?.intValue
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrosSubCategoria?.count == nil ? 0 : registrosSubCategoria.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SubCategoriaICell", forIndexPath: indexPath) as! SubCategoriaICell
        var posA = 0
        if let pos = prefs.stringForKey("poscatInnova"){
            posA = Int(pos)!
        }
        if(indexPath.row <= posA){
            cell.nombreSubCat.text = registrosSubCategoria[indexPath.row].nombre_subc
            cell.nombreSubCat.textColor = UIColor(red: 255/255, green: 161/255, blue: 6/255, alpha: 1.0)
            cell.imagenSubCat.image = UIImage(data: registrosSubCategoria[indexPath.row].imagen_subc!)
        }else{
            cell.imagenSubCat.image = UIImage(data: registrosSubCategoria[indexPath.row].imagen_subc_negativo!)
            cell.nombreSubCat.text = registrosSubCategoria[indexPath.row].nombre_subc
        }
  
        return cell
        
        
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
        self.performSegueWithIdentifier("showIPregunta", sender: registrosSubCategoria[indexPath.row].idSubCategoria!.stringValue)
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        //print(registrosSubCategoria[indexPath.row].idSubCategoria!.stringValue)
        
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        var posA = 0
        if let pos = prefs.stringForKey("poscatInnova"){
            posA = Int(pos)!
        }
        if(indexPath.row == posA){
            return indexPath
        }
        return nil
    }

    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showIPregunta"
        {
            let nav = segue.destinationViewController as! UINavigationController
            let detailViewController = nav.topViewController as! PreguntasIViewController
            detailViewController.idSubCategoria = sender as? String
        }
    }

}
