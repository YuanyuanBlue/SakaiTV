//
//  annoucell.swift
//  SakaiTV
//
//  Created by tong on 11/19/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/*This class is the cell class for annoucenment tableView
 */
class annocell: UITableViewCell {
    @IBOutlet weak var subject: UILabel!
    
    @IBOutlet weak var savedby: UILabel!
    
    @IBOutlet weak var modifieddate: UILabel!
    
    @IBOutlet weak var site: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
