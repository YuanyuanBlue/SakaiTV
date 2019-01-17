//
//  YoutubeData.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/24/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
/* This file contains data used to display Youtube
 */
var videoArray = [YoutubeVideo]()
class YoutubeVideo {
    var token: String
    var title : String
    var url : String
    var author: String
    var date: String
    
    init (title: String, token: String, url: String, author: String, date: String) {
        self.title = title
        self.token = token
        self.url = url
        self.author = author
        self.date = date
    }
}
