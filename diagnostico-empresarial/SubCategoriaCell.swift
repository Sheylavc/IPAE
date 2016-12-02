//
//  SubCategoriaCell.swift
//  diagnostico-empresarial
//
//  Created by ucweb on 29/09/16.
//  Copyright © 2016 ipae. All rights reserved.
//

import UIKit

class SubCategoriaCell: UITableViewCell {

    
    @IBOutlet weak var imagenSubCat: UIImageView!
    @IBOutlet weak var nombreSubCat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
