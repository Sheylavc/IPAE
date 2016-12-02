//
//  MenuViewController.swift
//  DIGE
//
//  Created by ucweb on 10/10/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    var MenuArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuArray = ["", "Inicio", "Acerca de IPAE", "Sugerencias"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
            
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("menu1Cell", forIndexPath: indexPath)
            
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("menu2Cell", forIndexPath: indexPath)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("menu3Cell", forIndexPath: indexPath) 
            
            return cell
        }
        
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            
        }
        else if indexPath.row == 1{
            self.performSegueWithIdentifier("mainView", sender: nil)
            //self.navigationController?.popToRootViewControllerAnimated(true)
            //self.revealViewController().pushFrontViewController(true)
            //self.revealViewController().pushFrontViewController(vc, animated: true)
        }
        else if indexPath.row == 2{
            self.performSegueWithIdentifier("infoView", sender: nil)
        }
        else{
            self.performSegueWithIdentifier("loadSugerencia", sender: nil)
        }
    }*/
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
   
}
