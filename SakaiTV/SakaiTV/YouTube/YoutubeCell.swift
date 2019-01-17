//
//  YoutubeCell.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/24/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/* This class is the cell class for Youtube tableView
 */
class YoutubeCell: UITableViewCell {

    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var title: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
