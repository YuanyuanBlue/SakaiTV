//
//  DukePersonTableViewCell.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/13/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

let LIGHT_GRAY = UIColor(displayP3Red: 89/255, green: 156/255, blue: 120/255, alpha: 0.7)
let APPLE_GREEN = UIColor(displayP3Red: 109/255, green: 210/255, blue: 149/255, alpha: 1)
//let DUKE = UIColor(displayP3Red: 4/255, green: 61/255, blue: 153/255, alpha: 1)
let DUKE = UIColor(displayP3Red: 0/255, green: 48/255, blue: 135/255, alpha: 1)

/* This class is the cell class for Class tableView
 */

class DukePersonTableViewCell: UITableViewCell {

    @IBOutlet weak var cellimg: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellDes: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.cellDes.isUserInteractionEnabled = false
        self.cellDes.backgroundColor = LIGHT_GRAY
        self.cellLabel.backgroundColor = APPLE_GREEN
       // self.cellLabel.font = UIFont(name: "Chalkduster", size: 20)
        self.cellLabel.textColor = UIColor.white
        self.cellDes.textColor = UIColor.white
        //self.cellDes.font = UIFont(name: "Chalkduster", size: 20)
        self.cellimg.layer.cornerRadius = (self.cellimg.frame.size.width) / 2
        self.cellDes.layer.cornerRadius = 10
        self.cellimg.clipsToBounds = true
        self.cellimg.isHidden = false
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
