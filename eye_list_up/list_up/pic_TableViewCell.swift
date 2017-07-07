//
//  pic_TableViewCell.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import UIKit


class pic_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var pic_imageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
