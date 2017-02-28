//
//  AperoTableViewCell.swift
//  Rea2017
//
//  Created by MENES SIMEU on 28/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class AperoTableViewCell: UITableViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var PalceLabel: UILabel!
    
    @IBOutlet weak var nbRestantLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
