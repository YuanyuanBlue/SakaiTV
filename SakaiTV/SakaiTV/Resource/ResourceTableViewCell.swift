//
//  ResourceTableViewCell.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/25/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

/* This class is the cell class for resource tableView
 */
class ResourceTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
