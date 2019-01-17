//
//  headerell.swift
//  SakaiTV
//
//  Created by tong on 11/19/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/* This class is used to display headers int the annoucement tableView
 */
class headercell: UITableViewCell {
    @IBOutlet weak var h1: UILabel!
    
    @IBOutlet weak var h2: UILabel!
    
    @IBOutlet weak var h3: UILabel!
    
    @IBOutlet weak var h4: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
