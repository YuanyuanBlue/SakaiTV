//
//  ResourceDa.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/16/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
/* This file contains data format used in resource
 */
var resourceArray = [Resource]()
class Resource {
    var numChildren : Int
    var title : String
    var type : String
    var subView = [Resource]()
    var url : String
    
    
    init (numChildren : Int, title: String, type : String, url : String) {
        self.numChildren = numChildren
        self.title = title
        self.type = type
        self.url = url
    }
}

