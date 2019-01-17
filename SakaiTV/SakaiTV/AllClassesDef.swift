//
//  AllClassesDef.swift
//  SakaiTV
//
//  Created by tong on 11/3/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation

var gradeitems: [String] = ["Membership", "Syllabus", "Annoucement", "Class", "Assignment", "Resource","Lesson", "Gradebook","Youtube"]

enum terms : String {
    case F17 = "2017 Fall Term"
    case Sp18 = "2018 Spring Term"
    case F18 = "2018 Fall Term"
    case Sp19 = "2019 Spring Term"
    case F19 = "2019 Fall Term"
    case Sp20 = "2020 Spring Term"
    case NA = "Not Applicable"
}





class announcement {
    var subject : String
    var savedby: String
    var modifieddate : String
    var site : String
    init(subject: String, savedby: String, modifieddate: String, site: String) {
        self.subject = subject
        self.savedby = savedby
        self.modifieddate = modifieddate
        self.site = site
    }
}

class course {
    var title: String
    var term: terms
    var siteID: String?
    var instructor: String?
    init(title: String, term: terms, siteid: String, instructor: String?) {
        self.title = title
        self.term = term
        self.siteID = siteid
        self.instructor = instructor ?? "Not Applicable"
    }
}


var c_564 = course(title: "ECE.564.01.F18", term: .F18, siteid: "00", instructor: "Ric Telford")
var c_551 = course(title: "ECE.551D.002.F17", term: .F17, siteid: "01", instructor: "Andrew Hilton")
var c_650 = course(title: "ECE.650.01.Sp18", term: .Sp18, siteid: "10", instructor: "Brain Rogers")

var courselist : [course] = [c_564, c_551, c_650]

var a1 = announcement(subject: "things to do to prepare for the class", savedby: "Ric Telford", modifieddate: "Aug 27, 2018 10:39 am", site: "site")

var annolist : [announcement] = []

var memberStr: String?

//var cur_courses : [course] =
