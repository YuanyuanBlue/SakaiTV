//
//  membershipCollectionViewCell.swift
//  SakaiTV
//
//  Created by tong on 11/18/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

/* This class is the cell class for membership collectionView
 */
class membershipCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var membershipimg : UIImageView!
    @IBOutlet weak var membershiptitle : UILabel!
    @IBOutlet weak var membershipinsrtuctor : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func congigurecell(course: course) {
        membershipimg.image = UIImage(named: "courseicon.png")
        membershiptitle.text = course.title
        membershipinsrtuctor.text = course.instructor
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextFoc = context.nextFocusedView as? membershipCollectionViewCell{
            nextFoc.backgroundColor = UIColor.lightGray
            
        }
        
        if let prevFocus = context.previouslyFocusedView as? membershipCollectionViewCell{
            
            prevFocus.backgroundColor = UIColor.clear
            
        }
    }
}
