//
//  Checkbox.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 28/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class Checkbox: UIButton {
    let checked = UIImage(named: "checked-box")! as UIImage
    let unchecked = UIImage(named: "blank-box")! as UIImage
    let prefs = NSUserDefaults.standardUserDefaults()
    //bool property
    //bool propety
    @IBInspectable var isChecked:Bool = false{
        didSet{
            self.updateImage()
        }
    }
    
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(Checkbox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.updateImage()
    }
    
    
    func updateImage() {
        if isChecked == true{
            self.setImage(checked, forState: .Normal)
            prefs.setValue(1, forKey: "checked")
            
        }else{
            self.setImage(unchecked, forState: .Normal)
            prefs.setValue(0, forKey: "checked")
        }
        
    }
    
    func buttonClicked(sender:UIButton) {
        if(sender == self){
            isChecked = !isChecked
        }
    }

}
