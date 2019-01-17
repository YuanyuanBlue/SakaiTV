//
//  announcementdata.swift
//  SakaiTV
//
//  Created by tong on 12/6/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation

//var anno_arr : [announcementdata] = []
var cur_body = String()
let time_arr : [String] = ["Nov 6, 2018 9:10 am", "Sep 18, 2018 9:22 am", "Aug 27, 2018 10:39 am"]

class announcementdata {
    var title = String()
    var author = String()
    var date = String()
    var site = String()
    var body = String()
    init(title: String, author: String, date: String, site: String, body: String){
        self.title = title
        self.author = author
        self.date = date
        self.site = site
        self.body = body
    }
}
