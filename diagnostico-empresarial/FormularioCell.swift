//
//  FormularioCell.swift
//  DiagnosticoIPAE
//
//  Created by ucweb on 6/10/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class FormularioCell: UITableViewCell {

    
    @IBOutlet weak var txtLabel: UILabel!
    
    @IBOutlet weak var txtInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
