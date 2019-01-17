//
//  CalendarUtilities.swift
//  SakaiTV
//
//  Created by 荣欣 on 12/7/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ rgbColorCode: (Int, Int, Int, Float)) {
        let redPart: CGFloat = CGFloat(rgbColorCode.0) / 255
        let greenPart: CGFloat = CGFloat(rgbColorCode.1) / 255
        let bluePart: CGFloat = CGFloat(rgbColorCode.2) / 255
        let alphaPart: CGFloat = CGFloat(rgbColorCode.3)
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alphaPart)
    }
}

//CalendarTool Reference: https://github.com/LitterL/CalendarDemo
//Many utility functions are used to return components of a Date, or calculate a result Date
open class CalendarTool: NSObject {
    
    //returns the year of given date
    open class func Year(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.year, from: date)
        return components.year!
    }
    
    //returns the month of given date
    open class func Month(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.month, from: date)
        return components.month!
    }
    
    //returns the date of given date
    open class func Day(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.day, from: date)
        return components.day!
    }
    
    //returns the hour of given date
    open class func Hour(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.hour, from: date)
        return components.hour!
    }
    
    //returns the minute of given date
    open class func Minute(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.minute, from: date)
        return components.minute!
    }
    
    //return the number of days in this month
    open class func DaysInMonth(_ date:Date)->Int{
        let days = (Foundation.Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return days.length
    }
    
    //returns the last month
    open class func UpMonth(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.month  = -1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return Month(newDate!)
    }
    
    //returns the next month
    open class func NextMonth(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.month  = +1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return Month(newDate!)
    }
    
    //returns the last year
    open class func UpYear(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.year  = -1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return Year(newDate!)
    }
    
    //returns the next year
    open class func NextYear(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.year  = +1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return Year(newDate!)
    }
    
    //returns the date one week later from TODAY
    open class func DateNextWeek(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.day  = +7
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return Day(newDate!)
    }
    
    //returns the date one week earlier from TODAY
    open class func DateUpWeek(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.day  = -7
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: date, options: .wrapComponents)
        return Day(newDate!)
    }
    
    //MARK:The last four methods are most frequently used in our calendarView
    //Return the first date (Sunday) in this week
    open class func firstDateThisWeek(_ date:Date)->Date{
        let dayInWeek = CalendarTool.DayinWeek(date)
        let res = CalendarTool.endDate(date, unit:.day, addValue: 1 - dayInWeek)
        return res
    }
    
    //Returns the order of today in this week，1 for Sunday, 7 for Saturday
    open class func DayinWeek(_ date:Date)->Int{
        let components = (Foundation.Calendar.current as NSCalendar).components(.weekday, from: date)
        return components.weekday!
    }
    
    //Return all Dates in the week of given date.
    //MARK:Pass the first Date of a week(Sunday)
    open class func datesInWeek(_ firstDateOfWeek:Date) -> [Int] {
        var dates:[Int] = [Int]()
        for i in 0...6 {
            dates.append(CalendarTool.Day(CalendarTool.endDate(firstDateOfWeek, unit:.day, addValue: i)))
        }
        return dates
    }
    
    //Calculate a Date by adding an increment
    open class func endDate(_ date:Date, unit: NSCalendar.Unit, addValue:Int)->Date{
        let calendar = Foundation.Calendar.current as NSCalendar
        let newDate = calendar.date(byAdding: unit, value: addValue, to: date, options: [])
        return newDate!
    }
}

//Time Format Transformation. Referenced from https://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
extension Date{
    static func getDate(_ components:(Int, Int, Int, Int, Int, Int)) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = components.0
        dateComponents.month = components.1
        dateComponents.day = components.2
        dateComponents.timeZone = TimeZone.current // East Daylight Time
        dateComponents.hour = components.3
        dateComponents.minute = components.4
        dateComponents.second = components.5
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        print("\(userCalendar.timeZone)")
        return userCalendar.date(from: dateComponents)!
    }
    
    //In our calendarView, we usually use this one
    static func getDate(_ str:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: str)!
    }
}

//Shorten time zone substring in the string of Date
func shortenLocale(_ date:Date) -> String {
    let old:String = date.description(with:.current)
    var new:String = old.replacingOccurrences(of: "Eastern Standard Time", with: "EST")
    new = new.replacingOccurrences(of: "Eastern Daylight Time", with: "EDT")
    return new
}

//Used for drawing circle with UIBezithPath
extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
