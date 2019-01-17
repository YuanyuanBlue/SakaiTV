//
//  Utilities.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/12/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
/* This class is used as tools to change frame easily
 */
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
