//
//  GradeData.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/17/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
/* This file contains data structure used in gradebook
 */
class Grade {
    var item: String
    var grade: String
    var point: Int
    var comments: String
    init (item: String, grade: String, point: Int, comments: String) {
        self.item = item
        self.grade = grade
        self.point = point
        self.comments = comments
    }
}

var currGrade = [Grade]()

