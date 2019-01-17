//
//  ScoreTableViewCell.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/12/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/* This is the cell class for gradebook TableView
 */
class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var Title: UITextField!
    @IBOutlet weak var Grade: UITextField!
    @IBOutlet weak var Comments: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 30
        // Initialization code
    }
    
}
