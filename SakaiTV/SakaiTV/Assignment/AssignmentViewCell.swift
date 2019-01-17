//
//  AssignmentViewCell.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/14/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/* This class is the cell class used in assignment collectionView
 */
class AssignmentViewCell: UICollectionViewCell {
    
    @IBOutlet weak var AssignmentTitle: UITextField!
    @IBOutlet weak var AssignmentStatus: UITextField!
    @IBOutlet weak var AssignmentOpen: UITextField!
    @IBOutlet weak var AssignmentDue: UITextField!
    @IBOutlet weak var AssignmentScale: UITextField!
    @IBOutlet weak var AssignmentInstruction: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.cellDes.isUserInteractionEnabled = false
        // Initialization code
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextFoc = context.nextFocusedView as? AssignmentViewCell{
            nextFoc.backgroundColor = UIColor.yellow
            
        }
        
        if let prevFocus = context.previouslyFocusedView as? AssignmentViewCell{
            
            prevFocus.backgroundColor = UIColor.orange
            
        }
    }
}
