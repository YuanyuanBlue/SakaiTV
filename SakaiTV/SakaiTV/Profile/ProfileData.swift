//
//  ProfileData.swift
//  SakaiTV
//
//  Created by 荣欣 on 12/7/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation

var studentsInPro:[String:String] = [
    "Nickname":"Charles", "Birthday":"19950101", "Personal Summary":"I am a good student",
    "Email":"charles@duke.edu", "Home page URL":"www.charles.com", "Work phone":"9190000000", "Home phone":"9190000000", "Mobile phone":"9190000000", "Fascimile":"9190000000",
    "Position":"Master Student", "Department":"ECE", "School":"Pratt School of Engineering", "Room":"Teer 106", "Staff profile":"Here is staff", "University profile URL":"ece.duke.edu", "Academic/research URL":"ece.duke.edu", "Publications and conferences":"ece.duke.edu",
    "Degree/Course":"MS", "Subjects":"ECE",
    "Facebook URL":"www.facebook.com", "LinkedIn URL":"www.linkedin.com", "MySpace URL":"www.,myspace.com", "Skype username":"www.skype.com", "Twitter URL":"www.twitter.com",
    "Favorite books":"My book", "Favorite TV shows":"My TV shows", "Favorite movies":"My movies", "Favorite quotes":"My quotes"
]

var sectionNamesInProDataSource:[String] = ["Basic Information", "Contact Information", "Staff Information", "Student Information", "Social Networking", "Personal Information"]

var sectionsInProDataSource:[ExpandableSection] = [
    ExpandableSection(isSectionExpanded: false, rowNames: [("Nickname",false), ("Birthday",false), ("Personal Summary",false)]),
    ExpandableSection(isSectionExpanded: false, rowNames: [("Email",false), ("Home page URL",false), ("Work phone", false), ("Home phone", false), ("Mobile phone",false), ("Fascimile", false)]),
    ExpandableSection(isSectionExpanded: false, rowNames: [("Position",false), ("Department",false), ("School",false), ("Room",false), ("Staff profile", false), ("University profile URL", false), ("Academic/research URL", false), ("Publications and conferences", false)]),
    ExpandableSection(isSectionExpanded: false, rowNames: [("Degree/Course", false), ("Subjects", false)]),
    ExpandableSection(isSectionExpanded: false, rowNames: [("Facebook URL", false), ("LinkedIn URL", false), ("MySpace URL", false), ("Skype username", false), ("Twitter URL", false)]),
    ExpandableSection(isSectionExpanded: false, rowNames: [("Favorite books", false), ("Favorite TV shows", false), ("Favorite movies", false), ("Favorite quotes", false)])
]
