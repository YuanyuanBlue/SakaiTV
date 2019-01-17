//
//  AssignmentData.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/15/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation

/* This file contains data structure used for assignment
 */
class Assignment {
    var assignmentTitle: String
    var status: String
    var due: String
    var scale: String
    var instructions: String
    var dueTime: Int64
    var open: String
    var openTime: Int64
    init (assignmentTitle: String, status: String, due: String, scale: String, instructions: String, dueTime: Int64, open: String, openTime: Int64) {
        self.assignmentTitle = assignmentTitle
        self.status = status
        self.due = due
        self.scale = scale
        self.instructions = instructions
        self.dueTime = dueTime
        self.openTime = openTime
        self.open = open
    }
}

