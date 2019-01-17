//
//  syllabusData.swift
//  SakaiTV
//
//  Created by tong on 12/6/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation

class celldata {
    var opened = Bool()
    var title = String()
    var detail = String()
    init(opened: Bool, title: String, detail: String) {
        self.opened = opened
        self.title = title
        self.detail = detail
    }
}
