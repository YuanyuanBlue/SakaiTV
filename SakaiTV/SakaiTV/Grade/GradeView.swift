//
//  GradeView.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/12/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

class GradeView: UIView {
    
    var mainView: UIView!
    
    @IBOutlet var GradeTable: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "GradeTable", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(GradeTable)
        GradeTable.frame = self.bounds
    }
    


}


