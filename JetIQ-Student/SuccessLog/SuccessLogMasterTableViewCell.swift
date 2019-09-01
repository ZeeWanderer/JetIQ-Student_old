//
//  SuccessLogMaterTableViewCell.swift
//  JetIQ-Student
//
//  Created by Max on 11/10/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class SuccessLogMasterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var t_name: UILabel!
    @IBOutlet weak var mark: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
