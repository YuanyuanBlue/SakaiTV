//
//  CalendarData.swift
//  SakaiTV
//
//  Created by 荣欣 on 12/7/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
import UIKit

var timeLabelStrings:[String] = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM", "12 AM"]

var colors:[UIColor] = [.magenta, .blue, .purple, .orange, .brown, .gray, UIColor((110,210,250,1)), UIColor((0,200,180,1)), UIColor((65,165,15,1)), UIColor((255,210,0,1))]

//DumbButton class, subclass of UIButton, used for help scrolling the whole scroll view of calendar
class DumbButton:UIButton {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in:context, with: coordinator)
        
        if context.nextFocusedView == self {    // This is when the button will be focused. You can change the backgroundColor and textColor here
            self.backgroundColor = .red
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            self.layer.shadowColor = UIColor.red.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 1.0
            self.layer.masksToBounds = false
        } else {  // This is when the focus has left and goes back to defaul. Don't forget to reset the values
            self.backgroundColor = .orange
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            self.layer.shadowColor = nil
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0.0
            self.layer.shadowRadius = 0.0
            self.layer.masksToBounds = false
        }
    }
}

//Define a class, which represents an "EventCell" on Scrollable TimeTable. Use eventID to associate button with event
class EventButton:UIButton {
    var colorNotFocused:UIColor!
    var eventID:Int!
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in:context, with: coordinator)
        
        if context.nextFocusedView == self {    // This is when the button will be focused. You can change the backgroundColor and textColor here
            self.colorNotFocused = self.backgroundColor
            self.backgroundColor = .red
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            self.layer.shadowColor = UIColor.red.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 1.0
            self.layer.masksToBounds = false
        } else {    // This is when the focus has left and goes back to default. Don't forget to reset the values
            self.backgroundColor = self.colorNotFocused
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            self.layer.shadowColor = nil
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0.0
            self.layer.shadowRadius = 0.0
            self.layer.masksToBounds = false
        }
    }
}

//Class to represent event. Use eventID to associate with eventButton
class EventCell {
    static var counter: Int = 0
    var eventID:Int!
    var startTime:Date!
    var endTime:Date!
    var cellHeight:Int
    {
        get{
            // oneDate.timeIntervalSince(newDate) / 36
            return Int(round(self.endTime.timeIntervalSince(self.startTime) / 36))
        }
    }
    
    var startX:Int{
        get{
            return (CalendarTool.DayinWeek(startTime)-1) * 140 + 69
        }
    }
    
    var startY:Int{
        get{
            return ( 10 + CalendarTool.Hour(startTime) * 100 + Int(round(Double(CalendarTool.Minute(startTime)) / 60.0 * 100.0)))
        }
    }
    
    var title:String!
    var location:String!
    var people:String!
    var details:String!
    
    init(startTime:Date!, endTime:Date!, title:String!, location:String!, people:String!, details:String!){
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.location = location
        self.people = people
        self.details = details
        self.eventID = EventCell.counter
        EventCell.counter += 1
    }
    
    //Draw the EventButton and associate it with eventCell
    func drawEventButton(color:UIColor) -> EventButton {
        let eventButton = EventButton()
        eventButton.eventID = self.eventID
        eventButton.frame = CGRect(x: self.startX, y: self.startY, width: 140, height: self.cellHeight)
        eventButton.backgroundColor = color
        eventButton.layer.borderColor = color.cgColor
        eventButton.layer.cornerRadius = 10
        eventButton.titleLabel?.numberOfLines = self.cellHeight/20
        eventButton.setTitle(self.title, for: .normal)
        eventButton.setTitleColor(.white, for:.normal)
        eventButton.setTitleColor(UIColor.green, for: .highlighted)
        eventButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        eventButton.titleLabel?.textAlignment = .left
        return eventButton
    }
}

//Class to draw "Last Week", "This Week" and "Next Week" buttons
class WeekButton:UIButton{
    var colorNotFocused:UIColor!
    var firstDateOfWeek:Date!
    var lastThisNext:Int!    //Used to calculate number of weeks away from the week displayed
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in:context, with: coordinator)
        
        if context.nextFocusedView == self {    // This is when the button will be focused. You can change the backgroundColor and textColor here
            self.colorNotFocused = self.backgroundColor
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
            self.layer.shadowColor = UIColor((255,60,50,1)).cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 1.0
            self.layer.masksToBounds = false
        } else {    // This is when the focus has left and goes back to default. Don't forget to reset the values
            self.backgroundColor = self.colorNotFocused
            self.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            self.layer.shadowColor = nil
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0.0
            self.layer.shadowRadius = 0.0
            self.layer.masksToBounds = false
        }
    }
}

//Sample data to test our calendarView
var eventCells:[EventCell] = [
    EventCell(startTime: Date.getDate("2018-11-20 11:45:00"), endTime: Date.getDate("2018-11-20 13:00:00"), title: "ECE 590-04 Computer and Information Security", location:"Social Science 136", people:"Tyler Blestch", details:"End System Security"),
    EventCell(startTime: Date.getDate("2018-11-21 08:30:00"), endTime: Date.getDate("2018-11-21 11:15:00"), title: "EGRMGMT 540 Management in High-tech Industry Final Exam", location:"Teer 115", people:"Edward McDowell Marshall", details:"Performance Coaching"),
    EventCell(startTime: Date.getDate("2018-11-21 11:45:00"), endTime: Date.getDate("2018-11-21 13:00:00"), title: "ECE 564 Mobile App Development iOS", location:"Teer 106", people:"Ric Telford", details:"Map View: How to make use of GPS"),
    EventCell(startTime: Date.getDate("2018-11-22 11:45:00"), endTime: Date.getDate("2018-11-22 13:00:00"), title: "ECE 590-04 Computer and Information Security", location:"Social Science 136", people:"Tyler Blestch", details:"Malwares"),
    EventCell(startTime: Date.getDate("2018-11-22 16:40:00"), endTime: Date.getDate("2018-11-22 19:25:00"), title: "EGRMGMT 530 Financial Accounting", location:"FCIEMAS Schisciano A", people:"Charles Jude Skender", details:"Bonds, Interest Rate and Interest Expense"),
    EventCell(startTime: Date.getDate("2018-11-26 11:45:00"), endTime: Date.getDate("2018-11-26 13:00:00"), title: "ECE 564 Mobile App Development iOS", location:"Teer 106", people:"Ric Telford", details:"Calendar, Event and Contact"),
    EventCell(startTime: Date.getDate("2018-11-27 11:45:00"), endTime: Date.getDate("2018-11-27 13:00:00"), title: "ECE 590-04 Computer and Information Security", location:"Social Science 136", people:"Tyler Blestch", details:"Wireless and Mobile Security"),
    EventCell(startTime: Date.getDate("2018-11-28 08:30:00"), endTime: Date.getDate("2018-11-28 11:15:00"), title: "EGRMGMT 540 Management in High-tech Industry Final Exam", location:"Teer 115", people:"Edward McDowell Marshall", details:"Last Lecture and Course Review"),
    EventCell(startTime: Date.getDate("2018-11-28 11:45:00"), endTime: Date.getDate("2018-11-28 13:00:00"), title: "ECE 564 Mobile App Development iOS", location:"Teer 106", people:"Ric Telford", details:"ARKit Applications Sample, TA lecture"),
    EventCell(startTime: Date.getDate("2018-11-29 11:45:00"), endTime: Date.getDate("2018-11-29 13:00:00"), title: "ECE 590-04 Computer and Information Security", location:"Social Science 136", people:"Tyler Blestch", details:"Reverse Engineering Principles and Tools"),
    EventCell(startTime: Date.getDate("2018-11-29 16:40:00"), endTime: Date.getDate("2018-11-29 19:25:00"), title: "EGRMGMT 530 Financial Accounting", location:"FCIEMAS Schisciano A", people:"Charles Jude Skender", details:"Common Stocks and Preferred Stocks"),
    EventCell(startTime: Date.getDate("2018-11-30 12:00:00"), endTime: Date.getDate("2018-11-30 14:45:00"), title: "EGRMGMT 590-15 Quality Experience Telemetry", location:"Teer 115", people:"Luis Morales", details:"Quality Experience Telemetry Project Presentation"),
    EventCell(startTime: Date.getDate("2018-12-03 11:45:00"), endTime: Date.getDate("2018-12-03 13:00:00"), title: "ECE 564 Mobile App Development iOS", location:"Teer 106", people:"Ric Telford", details:"Project Final Presentation Session 1"),
    EventCell(startTime: Date.getDate("2018-12-04 11:45:00"), endTime: Date.getDate("2018-12-04 13:00:00"), title: "ECE 590-04 Computer and Information Security", location:"Social Science 136", people:"Tyler Blestch", details:"Guest Speaker on Human Factor"),
    EventCell(startTime: Date.getDate("2018-12-05 08:30:00"), endTime: Date.getDate("2018-12-05 11:15:00"), title: "EGRMGMT 540 Management in High-tech Industry Final Exam", location:"Teer 115", people:"Edward McDowell Marshall", details:"Final Exam"),
    EventCell(startTime: Date.getDate("2018-12-05 11:45:00"), endTime: Date.getDate("2018-12-05 13:00:00"), title: "ECE 564 Mobile App Development iOS", location:"Teer 106", people:"Ric Telford", details:"Project Final Presentation Session 2"),
    EventCell(startTime: Date.getDate("2018-12-06 11:45:00"), endTime: Date.getDate("2018-12-06 13:00:00"), title: "ECE 590-04 Computer and Information Security", location:"Social Science 136", people:"Tyler Blestch", details:"Final Exam Review Session"),
    EventCell(startTime: Date.getDate("2018-12-06 16:40:00"), endTime: Date.getDate("2018-12-06 19:25:00"), title: "EGRMGMT 530 Financial Accounting Final Exam", location:"FCIEMAS Schisciano A", people:"Charles Jude Skender", details:"Financial Accounting Final Exam, one page cheat sheet allowed"),
    EventCell(startTime: Date.getDate("2018-12-07 12:00:00"), endTime: Date.getDate("2018-12-07 14:45:00"), title: "EGRMGMT 590-15 Quality Experience Telemetry Final Exam", location:"Teer 115", people:"Luis Morales", details:"Quality Experience Telemetry Final Exam, closed book and closed notes"),
    EventCell(startTime: Date.getDate("2018-12-12 10:05:00"), endTime: Date.getDate("2018-12-12 11:20:00"), title: "ECE 568 Engineering Robust Server Software", location:"FCIEMAS Schisciano A", people:"Brian M. Rogers", details:"Introfution to Course syllabus and logistics"),
    EventCell(startTime: Date.getDate("2018-12-11 08:30:00"), endTime: Date.getDate("2018-12-11 11:15:00"), title: "EGRMGMT 563 Supply Chain Management", location:"Teer 203", people:"Pranab Manjuber", details:"Introfution to Suppliers"),
    EventCell(startTime: Date.getDate("2018-12-13 18:15:00"), endTime: Date.getDate("2018-12-13 21:00:00"), title: "MENG 570 Business Fundamentals in High-tech Industry", location:"Teer 115", people:"Ric Telford", details:"Introfution to Market and Competition"),
    EventCell(startTime: Date.getDate("2018-12-19 10:05:00"), endTime: Date.getDate("2018-12-19 11:20:00"), title: "ECE 568 Engineering Robust Server Software", location:"FCIEMAS Schisciano A", people:"Brian M. Rogers", details:"Unix Deamon Process Management"),
    EventCell(startTime: Date.getDate("2018-12-18 08:30:00"), endTime: Date.getDate("2018-12-18 11:15:00"), title: "EGRMGMT 563 Supply Chain Management", location:"Teer 203", people:"Pranab Manjuber", details:"Introfution to Inventory and Consumption"),
    EventCell(startTime: Date.getDate("2018-12-20 18:15:00"), endTime: Date.getDate("2018-12-20 21:00:00"), title: "MENG 570 Business Fundamentals in High-tech Industry", location:"Teer 115", people:"Ric Telford", details:"Introfution to Marketing Strategies"),
]

