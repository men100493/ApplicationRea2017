//
//  HomeTableViewCell.swift
//  Rea2017
//
//  Created by MENES SIMEU on 24/02/2017.
//  Copyright © 2017 MenesS. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var TitleLabel: UILabel!

    @IBOutlet weak var bgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
