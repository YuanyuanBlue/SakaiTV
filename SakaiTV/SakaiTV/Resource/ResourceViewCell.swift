//
//  ResourceViewCell.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/16/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/* This class is the cell class for resource tableView
 */
class ResourceViewCell: UICollectionViewCell {
    @IBOutlet weak var Title: UITextField!
    @IBOutlet weak var RType: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.cellDes.isUserInteractionEnabled = false
        // Initialization code
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextFoc = context.nextFocusedView as? ResourceViewCell{
            
            nextFoc.backgroundColor = UIColor.yellow
            
        }
        
        if let prevFocus = context.previouslyFocusedView as? ResourceViewCell{
            
            prevFocus.backgroundColor = UIColor.orange
            
        }
    }
    
}
