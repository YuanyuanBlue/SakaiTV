//
//  ClassData.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/13/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
import UIKit
/* This file contains data structures used for Class
 */

var sections = ["Professor", "TA", "Students Without Team", "Sakai TV"]
var items = [[DukePerson]]()



enum Gender: String,  Codable {
    
    case Male = "Male"
    case Female = "Female"
}

class Person: Codable{
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
    
    
}

enum DukeRole : String, Codable {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "TA"
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}
//: ### START OF HOMEWORK
//: Do not change anything above.
//: Put your code here:

//This enum are error types for me to throw exceptions
enum MyError: Error {
    case toMuchBestProgramming
    case noSuchRole
    case noValidHeight
}

/* This DukePerson class contains basic information for Duke people. It contains information
 * such as a person's name, role, degree and email adress. It also contains a description to
 * help user print all information inside a DukePerson. To initiate an instanse of a
 * DukePerson, you must provide first name, last name, best programming languages (no more
 * than 3) and hobbies of that person.
 */

class DukePerson :  BlueDevil, CustomStringConvertible, Codable{
    var hobbies: [String] = []
    
    var uid: Int?
    
    var imgForJSON: String?
    
    var role: DukeRole = .Student
    
    var img: String = ""
    
    var fullName: String = ""
    
    var team: String = ""
    
    static var personId: String = ""
    
    var hasJob: Bool = false
    
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
    
    
    var degree: String = ""
    
    var bestProgrammingLanguages: [String] = []
    
    // var emailAddresses = Set<String>()
    
    
    // var height: Float?
    /*required init(from decoder: Decoder) throws {
     
     }
     
     override func encode(to encoder: Encoder) throws {
     
     }*/
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("PersonJSONFile1")
    static let ArchiveURL2 = DocumentsDirectory.appendingPathComponent("SectionJSONFile1")
    
    //This function saves the section to display teams
    static func saveToDoInfo2(_ todoList: [String]) -> Bool {
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todoList) {
            if let json = String(data: encoded, encoding: .utf8) {
                print(json)
                outputData = encoded
            }
            else { return false }
            
            do {
                try outputData.write(to: ArchiveURL2)
            } catch let error as NSError {
                print (error)
                return false
            }
            return true
        }
        else { return false }
    }
    
    //This function loads the section to display teams
    static func loadToDoInfo2() -> [String]? {
        let decoder = JSONDecoder()
        var todoItems = [String]()
        let tempData: Data
        
        do {
            tempData = try Data(contentsOf: ArchiveURL2)
        } catch let error as NSError {
            print(error)
            return nil
        }
        if let decoded = try? decoder.decode([String].self, from: tempData) {
            todoItems = decoded
        }
        return todoItems
    }
    
    
    //This function saves the DukePerson
    static func saveToDoInfo(_ todoList: [[DukePerson]]) -> Bool {
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todoList) {
            if let json = String(data: encoded, encoding: .utf8) {
                print(json)
                outputData = encoded
            }
            else { return false }
            
            do {
                try outputData.write(to: ArchiveURL)
            } catch let error as NSError {
                print (error)
                return false
            }
            return true
        }
        else { return false }
    }
    
    //This function loads the DukePerson
    static func loadToDoInfo() -> [[DukePerson]]? {
        let decoder = JSONDecoder()
        var todoItems = [[DukePerson]]()
        let tempData: Data
        
        do {
            tempData = try Data(contentsOf: ArchiveURL)
        } catch let error as NSError {
            print(error)
            return nil
        }
        if let decoded = try? decoder.decode([[DukePerson]].self, from: tempData) {
            todoItems = decoded
        }
        return todoItems
    }
    
    //This function is used in description to display users' info
    func printArr(_ arr: [String]) -> String {
        let count = arr.count
        var result: String = ""
        if count == 1 {
            result = result + " " + arr[0] + "."
        } else {
            for pcount in 0..<count {
                if(pcount == count - 2) {
                    result = result + " " + arr[pcount] + " and " + arr[pcount + 1] + "."
                    break
                } else {
                    result = result +  " " + arr[pcount] + ","
                }
            }
        }
        return result
    }
    
    var description: String {
        var personInfo: String = ""
        personInfo = self.firstName + " " + self.lastName + " is from " + self.whereFrom + " and is a " + self.role.rawValue + ". "
        let programmingCount: Int = self.bestProgrammingLanguages.count
        let hobbiesCount: Int = self.hobbies.count
        if programmingCount > 0 {
            personInfo += self.gender == Gender.Male ? "He" : "She"
            personInfo += " is proficient in"
            personInfo += printArr(self.bestProgrammingLanguages)
        }
        if hobbiesCount > 0 {
            personInfo = personInfo + " When not in class, " + self.firstName + " enjoys"
            personInfo += printArr(self.hobbies)
        }
        return personInfo
        
    }
    
    
    
    init(_ firstName: String, _ lastName: String) {
        // super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        DukePerson.personId = Date().description
    }
    
    init(f firstName: String, l lastName: String, role: DukeRole, p programming: [String], h hobbies: [String]) throws{
        self.role = role
        // super.init()
        self.firstName = firstName
        self.lastName = lastName
        guard programming.count <= 3 else {
            print("Best programming languages can not be more than 3")
            throw MyError.toMuchBestProgramming
        }
        self.bestProgrammingLanguages = programming
        self.hobbies = hobbies
        if(programming.count > 3) {
            
        }
        self.fullName = firstName + " " + lastName
        DukePerson.personId = Date().description
    }
    
    
    
}



//funny.gif is from https://www.google.com/imgres?imgurl=https%3A%2F%2Fww1.sinaimg.cn%2Flarge%2F47481d23jw1eutt4u19cxj207i09wt9e.jpg&imgrefurl=http%3A%2F%2Ftw.weibo.com%2Fryuetsuya%2F3873142386963201&docid=qDLpnHqqkseowM&tbnid=0zcWYMvRGpwVGM%3A&vet=10ahUKEwjlx9ms8M3dAhUE71MKHZT5AiIQMwh7KEkwSQ..i&w=270&h=356&bih=751&biw=1439&q=火影忍者%20向日葵&ved=0ahUKEwjlx9ms8M3dAhUE71MKHZT5AiIQMwh7KEkwSQ&iact=mrc&uact=8#h=356&imgdii=85FnE3VqsFFQuM:&vet=10ahUKEwjlx9ms8M3dAhUE71MKHZT5AiIQMwh7KEkwSQ..i&w=270
// code below is from https://github.com/kiritmodi2702/GIF-Swift
extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}
