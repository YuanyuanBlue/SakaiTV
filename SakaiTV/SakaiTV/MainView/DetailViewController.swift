//
//  DetailViewController.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/9/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//
import TVUIKit
import UIKit
//"https://sakai.duke.edu/direct/assignment/site/" + siteId + ".json"
//a21cac74-836d-4232-a468-4f7e5639b235/tool/cd30afc0-339e-4fe9-8599-d7d74fb5b84c

/* This is the detail part of the master-detail view. It handles all the
 * logic to display correct information for each function
 */
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var announcementView: UITableView!
    @IBOutlet weak var memcollectionview: UICollectionView!
    //assignment

    var isPersonArrayEmpty: Bool = true
    var isResourceArrEmpty: Bool = true
    var isAssignmentEmpty: Bool = true
    var isGradeBookEmpty: Bool = true
    var isVideoEmpty: Bool = true
    var isAnnouceEmpty: Bool = true
    var isLessonEmpty: Bool = true
    var isSyllabusEmpty: Bool = true
    
    //Start:Calendar view properties
    var calendarView: UIView = UIView()
    //        In merged project, we use
    //        self.calendarView.removeFromSuperview()
    //        to remove calendarView
    var showDateInCal: UIView = UIView()
    var myScrollInCal: UIScrollView = UIScrollView()
    var myContentInCal: UIView = UIView()
    var eventLabelInCal: UILabel = UILabel()
    
    var lastWeekButtonInCal:WeekButton = WeekButton()
    var thisWeekButtonInCal:WeekButton = WeekButton()
    var nextWeekButtonInCal:WeekButton = WeekButton()
    var whichWeekInCal:Int = 0    //number of weeks from current week: <0 last, >0 next
    
    var todayInCal:Date = Date()
    var eventButtonsInCal:[EventButton] = [EventButton]()
    var dateLblsInCal:[UILabel] = [UILabel]()
    var todayLblInCal = UILabel()
    
    var myPreferredFocusedViewInCal = UIView()
    //End: Calendar view properties
    
    //Begin: profileTableView properties
    var lastExpandedSectionInPro: Int!
    var sectionNamesInPro:[String] = sectionNamesInProDataSource
    var sectionsInPro:[ExpandableSection] = sectionsInProDataSource
    //End: profileTableView properties
    
    @IBOutlet weak var profileTableView: UITableView!

    @IBOutlet weak var SyllabusTable: UITableView!
    @IBOutlet weak var lessonTable: UITableView!
    @IBOutlet weak var YoutubeTable: UITableView!
    @IBOutlet weak var YoutubeView: UIView!
    @IBOutlet weak var SchoolImg: UIImageView!
    @IBOutlet weak var AssignmentView: UIView!
    @IBOutlet weak var ResourceView: UIView!
    @IBOutlet weak var ResourceCollection: UICollectionView!
    @IBOutlet weak var DueSoon: UIButton!
    @IBOutlet weak var Newest: UIButton!
    @IBOutlet weak var AssignmentCollection: UICollectionView!
    @IBOutlet weak var getButton: UIButton!
    //var scores: [String] = ["1", "2"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAll()
        SchoolImg.isHidden = false
        SchoolImg.image = UIImage(named: "School.jpeg")
        SchoolImg.contentMode = UIView.ContentMode.scaleAspectFill
        SchoolImg.clipsToBounds = true
        if(memberStr == "ECE.564.01.F18" || memberStr == "ECE.551D.002.F17") {
            removeData()
            prepareForTargetMember()
        }
        setDelegateDataSource()
        setSelectionTarget()
        //setPersonArr()
        configureView()

    }
    
    
    func prepareForTargetMember() {
        initVideo()
        initAnnouce()
        readJson()
        extract_json()
        formAssignment()
        initGradeItems()
        initResource()
        setPersonArr()
        initLesson()
        //initSyllabus()
    }
    
    func initSyllabus() {
        if(isSyllabusEmpty) {
            if(memberStr == "ECE.564.01.F18") {
                isSyllabusEmpty = false
            }
        }
    }
    
    func initLesson() {
        if(isLessonEmpty) {
            if(memberStr == "ECE.564.01.F18") {
                lessons = ["Week One: Overview / Swift", "Week Two: Xcode", "Week Three - Views and VCs I", "Week Four - Views and VCs II"]
                pdffile = ["lessons1", "lessons2", "lessons3", "lessons4"]
                isLessonEmpty = false
            }
        }
    }
    
    func initAnnouce() {
        print("initAnnouce executed")
        if(isAnnouceEmpty) {
            if(memberStr == "ECE.564.01.F18") {
                anno_arr = []
                if let path = Bundle.main.path(forResource: "announcement_for_564", ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                        if let collection = jsonResult["announcement_collection"] as? [[String: AnyObject]] {
                            for i in 0..<collection.count {
                                //print(collection[i]["title"])
                                let str : String = collection[i]["body"] as! String
                                let single_announcement = announcementdata(title: collection[i]["title"] as! String, author: "Ric Telford", date: time_arr[i], site: "site", body: str.htmlToString)
                                anno_arr.append(single_announcement)
                                //print(anno_arr)
                            }
                        }
                    } catch {
                        print("can not read announcement json")
                    }
                }
                isAnnouceEmpty = false
            }
        }
    }
    
    //Data removed are associated with course membership
    func removeData() {
        currGrade = [Grade]()
        resourceArray = [Resource]()
        //annolist = [announcement]()
        anno_arr = []
        videoArray = [YoutubeVideo]()
        items = [[DukePerson]]()
        lessons = []
        pdffile = []
        tableviewdata = [celldata]()
    }
    
    var anno_arr : [announcementdata] = []
    //syllabusdata
    var tableviewdata = [celldata]()
    //assignment data
    var openAssignment = [Assignment] ()
    var closeAssignment = [Assignment] ()
    var allAssignment = [Assignment] ()
    var newAssignment = [Assignment] ()
    var dueAssignment = [Assignment] ()
    var assignmentItems:[(title: String, status: String, dueTimeString: String, gradeScaleMaxPoints: String, instructions: String, dueTime:Int64, openTimeString: String, openTime: Int64)] = []
    // var currAssignment = [Assignment]()
    var tapAssignment: Assignment? = nil
    var siteId : String = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    func initVideo() {
        if(isVideoEmpty) {
            if(memberStr == "ECE.564.01.F18") {
                let video1 = YoutubeVideo(title: "Example Video", token: "6v2L2UGZJAM", url: "", author: "author1", date: "November 24, 2018" )
                videoArray.append(video1)
                isVideoEmpty = false
            }
        }
    }
    
    func initResource() {
        if(isResourceArrEmpty) {
            if(memberStr == "ECE.564.01.F18") {
                let res1 = Resource(numChildren : 0, title: "3. Class Handbook", type : "pdf", url : "")
                let res2 = Resource(numChildren : 0, title: "4. Project Ideas", type : "pdf", url : "")
                let res3 = Resource(numChildren : 0, title: "Showcase", type : "pdf", url : "")
                let res4 = Resource(numChildren : 0, title: "starwars bg", type : "jpg", url : "")
                resourceArray = [Resource]()
                resourceArray.append(res1)
                resourceArray.append(res2)
                resourceArray.append(res3)
                resourceArray.append(res4)
                isResourceArrEmpty = false
            }
        }
    }
    
    func initGradeItems() {
        if(isGradeBookEmpty) {
            if(memberStr == "ECE.564.01.F18") {
                let grade1 = Grade(item: "HW1 Grade", grade: "98/100", point: 98, comments: "Good Job")
                let grade2 = Grade(item: "HW2 Grade", grade: "97/100", point: 97, comments: "Good Job")
                let grade3 = Grade(item: "HW3 Grade", grade: "96/100", point: 96, comments: "Good Job")
                let grade4 = Grade(item: "HW4 Grade", grade: "95/100", point: 95, comments: "Good Job")
                currGrade = [Grade]()
                currGrade.append(grade1)
                currGrade.append(grade2)
                currGrade.append(grade3)
                currGrade.append(grade4)
                isGradeBookEmpty = false
            } else if(memberStr == "ECE.551D.002.F17") {
                let grade1 = Grade(item: "hw1", grade: "10/10", point: 10, comments: "grade")
                let grade2 = Grade(item: "hw2", grade: "10/10", point: 10, comments: "grade")
                let grade3 = Grade(item: "hw3", grade: "10/10", point: 10, comments: "grade")
                let grade4 = Grade(item: "mini project", grade: "90/100", point: 90, comments: "grade")
                currGrade = [Grade]()
                currGrade.append(grade1)
                currGrade.append(grade2)
                currGrade.append(grade3)
                currGrade.append(grade4)
                isGradeBookEmpty = false
            }
        }
    }
    
    //
    func setSelectionTarget(){
        getButton.addTarget(self, action: #selector(DetailViewController.GETJson), for: UIControl.Event.primaryActionTriggered)
        Newest.addTarget(self, action: #selector(DetailViewController.sortAssignmentByNew), for: UIControl.Event.primaryActionTriggered)
        DueSoon.addTarget(self, action: #selector(DetailViewController.sortAssignmentByDue), for: UIControl.Event.primaryActionTriggered)
    }
    
    func setDelegateDataSource() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
        AssignmentCollection.dataSource = self
        AssignmentCollection.delegate = self
        scoreTable.dataSource = self
        scoreTable.delegate = self
        classTable.dataSource = self
        classTable.delegate = self
        ResourceCollection.delegate = self
        ResourceCollection.dataSource = self
        memcollectionview.delegate = self
        memcollectionview.dataSource = self
        announcementView.dataSource = self
        announcementView.delegate = self
        YoutubeTable.delegate = self
        YoutubeTable.dataSource = self
        lessonTable.dataSource = self
        lessonTable.delegate = self
        SyllabusTable.dataSource = self
        SyllabusTable.delegate = self
    }
    
    func setPersonArr(){
        if isPersonArrayEmpty {
            if items.isEmpty {
                initItems()
                addDefaultPerson()
            }
            isPersonArrayEmpty = false
        }
    }
    
    
    @objc func sortAssignmentByNew() {
        allAssignment = newAssignment
        AssignmentCollection.reloadData()
    }
    
    @objc func sortAssignmentByDue() {
        allAssignment = dueAssignment
        AssignmentCollection.reloadData()
    }
    
    func formAssignment () {
        if(memberStr == "ECE.564.01.F18") {
        for i in assignmentItems {
            let assignment1 = Assignment(assignmentTitle: i.title, status: i.status, due: i.dueTimeString, scale: i.gradeScaleMaxPoints, instructions: i.instructions, dueTime: i.dueTime, open: i.openTimeString, openTime: i.openTime)
            if (assignment1.status == "OPEN") {
                openAssignment.append(assignment1)
            } else {
                closeAssignment.append(assignment1)
            }
            allAssignment.append(assignment1)
            dueAssignment.append(assignment1)
            newAssignment.append(assignment1)
        }
        openAssignment = openAssignment.sorted () {$0.dueTime < $1.dueTime}
        closeAssignment = closeAssignment.sorted () {$1.dueTime < $0.dueTime}
        allAssignment = allAssignment.sorted() {$0.openTime > $1.openTime}
        dueAssignment = openAssignment.sorted() {$0.dueTime < $1.dueTime}
       // dueAssignment = allAssignment.sorted() {$0.dueTime < $1.dueTime}
        newAssignment = allAssignment.sorted() {$0.openTime > $1.openTime}
        }
    }
    
    //get syllabus json
    func extract_json() {
        if(memberStr == "ECE.564.01.F18") {
        if let path = Bundle.main.path(forResource: "syllabus_for_564", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                if let items = jsonResult["items"] as? [[String: AnyObject]] {
                    
                    
                    for item in items {
                        let str1 : String = item["title"] as! String
                        let str2 : String = item["data"]! as! String
                        let single_celldata = celldata(opened: false, title: str1, detail: str2.htmlToString)
                        print(single_celldata.detail)
                        tableviewdata.append(single_celldata)
                    }
                }
                
                
            } catch {
                print("cannot read json")
            }
        }
        }
    }
    
    //get assignment json
    func readJson() {
        if(memberStr == "ECE.564.01.F18") {
        if let path = Bundle.main.path(forResource: "Assignment", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
                if let assignment_collection = jsonResult["assignment_collection"] as? [[String: AnyObject]] {
                    
                    for assignment in assignment_collection {
                        var title:String = "Not Available"
                        var status:String = "Not Available"
                        var dueTimeString:String = "Not Available"
                        var dueTime:Int64 = 0
                        var gradeScaleMaxPoints:String = "Not Available"
                        var instructions:String = "<h5>Not Available</h5>"
                        var openTimeString:String = "Not Available"
                        var openTime:Int64 = 0
                        if let mytitle = assignment["title"] as? String {
                            title = (mytitle == "" ? "Not Available" : mytitle)
                        }
                        if let mystatus = assignment["status"] as? String {
                            status = (mystatus == "" ? "Not Available" : mystatus)
                        }
                        if let mydueTimeString = assignment["dueTimeString"] as? String {
                            dueTimeString = (mydueTimeString == "" ? "Not Available" : mydueTimeString)
                        }
                        if let tempDue = assignment["dueTime"]  {
                            dueTime = (tempDue["epochSecond"] as? Int64) ?? -1
                            let date = Date(timeIntervalSince1970: TimeInterval(dueTime))
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                            dateFormatter.locale = NSLocale.current
                            dateFormatter.dateFormat = "HH:mm, MMM d" //Specify your format that you want
                            dueTimeString = dateFormatter.string(from: date)
                        }
                        if let myopenTimeString = assignment["openTimeString"] as? String {
                            openTimeString = (myopenTimeString == "" ? "Not Available" : myopenTimeString)
                        }
                        if let tempOpen = assignment["openTime"]  {
                            openTime = (tempOpen["epochSecond"] as? Int64) ?? -1
                            let date = Date(timeIntervalSince1970: TimeInterval(openTime))
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                            dateFormatter.locale = NSLocale.current
                            dateFormatter.dateFormat = "HH:mm, MMM d" //Specify your format that you want
                            openTimeString = dateFormatter.string(from: date)
                        }
                        if let mygradeScaleMaxPoints = assignment["gradeScaleMaxPoints"] as? String {
                            gradeScaleMaxPoints = (mygradeScaleMaxPoints == "" ? "Not Available" : mygradeScaleMaxPoints)
                        }
                        if let myinstructions = assignment["instructions"] as? String {
                            instructions = (myinstructions == "" ? "<h5>Not Available</h5>" : myinstructions)
                        }
                        
                        let tuple = (title, status, dueTimeString, gradeScaleMaxPoints, instructions, dueTime, openTimeString, openTime)
                        self.assignmentItems.append(tuple);
                        
                    }
                    
                    print("success")
                    
                    
                }
            } catch {
                print("cannot read json")
            }
        }
        }
    }
    
    func addDefaultPerson() {
        
            let Yuanyuan = DukePerson("Yuanyuan", "Yu")
            Yuanyuan.gender = .Female
            Yuanyuan.role = .Student
            Yuanyuan.whereFrom = "China"
            Yuanyuan.degree = "MENG"
            Yuanyuan.hobbies = ["Baseball", "Fencing", "Golf"]
            Yuanyuan.bestProgrammingLanguages = ["Java", "Swift", "Python"]
            //Yuanyuan.img = "yy"
            //map["Yuanyuan Yu"] = Yuanyuan
            //personArray.append(Yuanyuan)
            
            let Ric = DukePerson("Ric", "Telford")
            Ric.gender = .Male
            Ric.role = .Professor
            Ric.whereFrom = "Morrisville, NC"
            Ric.degree = "BS"
            Ric.hobbies = ["Golf", "Swimming", "Biking"]
            Ric.bestProgrammingLanguages = ["Swift", "C", "C++"]
            //Ric.img = "Ric"
            //map["Ric Telford"] = Ric
            //personArray.append(Ric)
            
            let cpy = DukePerson("Peiyi", "Chen")
            cpy.gender = .Female
            cpy.role = .Student
            cpy.whereFrom = "China"
            cpy.degree = "MENG"
            cpy.hobbies = ["Eating!", "Eating!", "Eating!"]
            cpy.bestProgrammingLanguages = ["Matlab"]
            //cpy.img = "cpy"
            cpy.team = "Sakai TV"
            //map["Peiyi Chen"] = cpy
            //personArray.append(cpy)
            
            let rx = DukePerson("Xin", "Rong")
            rx.gender = .Male
            rx.role = .Student
            rx.whereFrom = "China"
            rx.degree = "MS"
            //map["Xin Rong"] = rx
            rx.team = "Sakai TV"
            //personArray.append(rx)
            
            let xt = DukePerson("Tong", "Xiong")
            xt.gender = .Female
            xt.role = .Student
            xt.whereFrom = "China"
            xt.degree = "MS"
            //map["Xin Rong"] = rx
            xt.team = "Sakai TV"
            //personArray.append(xt)
            
            items[0].append(Ric)
            items[3].append(Yuanyuan)
            items[3].append(xt)
            items[3].append(rx)
            items[2].append(cpy)
            
            
            //let _ = DukePerson.saveToDoInfo(items)
            //let _ = DukePerson.saveToDoInfo2(sections)
        
    }
    
    
    func initItems(){
        for _ in sections {
            items.append([])
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == profileTableView) {
            return sectionNamesInPro.count
        }else if(tableView == scoreTable || tableView == YoutubeTable || tableView == lessonTable) {
            return 1
        } else if(tableView == announcementView) {
            return 2
        } else if(tableView == SyllabusTable){
            return tableviewdata.count
        } else {
            return sections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == AssignmentCollection) {
            return allAssignment.count
        } else if(collectionView == memcollectionview) {
            return courselist.count
        } else {
            return resourceArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == memcollectionview) {
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! membershipCollectionViewCell
            if(cell.membershiptitle.text != nil) {
                memberStr = cell.membershiptitle.text!
                if(memberStr != "ECE.564.01.F18"){
                    removeData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == AssignmentCollection) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssignmentCell", for: indexPath) as! AssignmentViewCell
        var currAssign: Assignment? = nil
        currAssign = allAssignment[indexPath.item]
        
        cell.AssignmentTitle.text = currAssign?.assignmentTitle
        cell.AssignmentDue.text = currAssign?.due
        cell.AssignmentOpen.text = currAssign?.open
        cell.AssignmentStatus.text = currAssign?.status
        cell.AssignmentScale.text = currAssign?.scale
        cell.AssignmentInstruction.text = ""
        if (currAssign?.instructions != nil) {
           let attrStr = try! NSAttributedString(
                data: (currAssign?.instructions.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [.documentType : NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            let att = NSAttributedString(string: attrStr.string, attributes: [NSAttributedString.Key.font: UIFont(name: "Futura", size: 22.0)!, NSAttributedString.Key.foregroundColor: UIColor.brown ])
            cell.AssignmentInstruction.attributedText = att
        }
            
            return cell
        } else if(collectionView == memcollectionview) {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "membershipcell", for: indexPath) as? membershipCollectionViewCell {
                //            print(membershipCollectionViewCell.self)
                print(cell)
                let a_course = courselist[indexPath.row]
                cell.congigurecell(course: a_course)
                return cell
            } else {
                print("aaaa")
                return UICollectionViewCell()
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResourceCell", for: indexPath) as! ResourceViewCell
            cell.Title.text = resourceArray[indexPath.item].title
            cell.RType.text = resourceArray[indexPath.item].type
            cell.contentView.clipsToBounds = true
            cell.layer.cornerRadius = 20
            cell.contentView.layer.cornerRadius = 20
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == scoreTable) {
            return "GradeBook"
        } else if(tableView == classTable){
            return  sections[section]
        } else {
            return ""
        }
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        //headerView.backgroundColor = DARK_GREEN
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Chalkduster", size: 20)
        headerLabel.textColor = UIColor.white
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == profileTableView{
            let headerView = UIView()
            headerView.backgroundColor = UIColor.magenta
            
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 1135, height: 100)
            button.setTitle(sectionNamesInPro[section], for: .normal)
            button.backgroundColor = UIColor.magenta
            button.setTitleColor(.white, for: .normal)
            button.tag = section
            headerView.addSubview(button)
            return headerView
        } else{
            return nil
        }
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == profileTableView{
            return 0.001
        }else {
            return 0.000
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(tableView == classTable){
         cell.backgroundColor = APPLE_GREEN
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profileTableView {
            if sectionsInPro[section].isSectionExpanded {
                return sectionsInPro[section].numberOfRows()
            } else {
                return 0
            }
        } else if(tableView == scoreTable) {
            return currGrade.count
        } else if(tableView == announcementView) {
            switch section {
            case 0 :
                return 1
            case 1 :
                return anno_arr.count
            default :
                return 0
            }
        } else if(tableView == YoutubeTable){
            return videoArray.count
        } else if(tableView == lessonTable) {
            return lessons.count
        } else if(tableView == SyllabusTable) {
            if tableviewdata[section].opened == true {
                return 2
            } else {
                return 1
            }
        } else{
            return items.isEmpty ? 0 : items[section].count
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == profileTableView){
            let res = getRowNameAndType(indexPath)
            //Condition: whether labelRow or inputRow
            if res.1 == .labelRow {
                //Flip the ExpandedRow flag
                let isRowExpanded:Bool = sectionsInPro[indexPath.section].rowNames[res.2].1
                sectionsInPro[indexPath.section].rowNames[res.2].1 = !isRowExpanded
                if isRowExpanded {
                    let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row+1, section: indexPath.section)) as! ProfileTableViewCell
                    studentsInPro[res.0] = cell.itemTextField.text!
                    self.profileTableView.deleteRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
                    //Save updated data
                } else {
                    self.profileTableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
                }
            } else {
                //Do nothing for inputRow.
            }
        } else if(tableView == announcementView){
            if indexPath.section == 1 {
                cur_body = anno_arr[indexPath.row].body
                self.performSegue(withIdentifier: "annosegue", sender: self)
            }
        } else if(tableView == lessonTable) {
            nameoffile = pdffile[indexPath.row]
            self.performSegue(withIdentifier: "lessonspdfsegue", sender: self)
        } else if(tableView == SyllabusTable) {
            if tableviewdata[indexPath.section].opened == true {
                tableviewdata[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableviewdata[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profileTableView {
            let res = getRowNameAndType(indexPath)

            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
                cell.configCell(itemName:res.0, isInputCell: res.1 == .inputRow)
                return cell
            } else {
                return UITableViewCell()
            }
        } else if(tableView == SyllabusTable) {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "titlecell", for: indexPath) as! titlecell
                cell.celltitle.text = tableviewdata[indexPath.section].title
                cell.backgroundColor = UIColor.blue
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath) as! detailcell
                cell.celltext.text = tableviewdata[indexPath.section].detail
                cell.backgroundColor = UIColor.white
                return cell
            }
        } else if(tableView == lessonTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonscell", for: indexPath) as! lessonscell
            cell.fileicon.image = UIImage(named: "Open-file-icon.png")
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let italicsfont = UIFont(name: "Avenir-BookOblique", size: 30)
            let underlineAttributedString = NSAttributedString(string: lessons[indexPath.row], attributes: underlineAttribute)
            
            cell.lessonstitle.attributedText = underlineAttributedString
            cell.lessonstitle.font = italicsfont
            return cell
        }else if (tableView == announcementView) {
            switch indexPath.section {
            case 0 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! headercell
                cell.h1.text = "Subject"
                cell.h2.text = "Saved by"
                cell.h3.text = "Modified by"
                cell.h4.text = "Site"
                return cell
            case 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "announcement", for: indexPath) as! annocell
                cell.subject.text = anno_arr[indexPath.row].title
                cell.savedby.text = anno_arr[indexPath.row].author
                cell.modifieddate.text = anno_arr[indexPath.row].date
                cell.site.text = anno_arr[indexPath.row].site
                return cell
            default :
                let cell = UITableViewCell()
                return cell
            }
        } else if(tableView == scoreTable) {
            let cell = Bundle.main.loadNibNamed("ScoreTableViewCell", owner: self, options: nil)?.first as! ScoreTableViewCell
            cell.Title.text = currGrade[indexPath.row].item
            cell.Grade.text = currGrade[indexPath.row].grade
            cell.Comments.text = currGrade[indexPath.row].comments
            return cell
        } else if(tableView == YoutubeTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell", for: indexPath) as! YoutubeCell
            cell.author.text = videoArray[indexPath.row].author
            cell.title.text = videoArray[indexPath.row].title
            cell.date.text = videoArray[indexPath.row].date
            return cell
        } else {
            //let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
            //cell.textLabel?.text = scores[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! DukePersonTableViewCell
            let tempPerson: DukePerson
            tempPerson = items[indexPath.section][indexPath.row]
            let data = UserDefaults.standard.object(forKey: tempPerson.img) as? NSData
            if(data != nil) {
                cell.cellimg.image = UIImage(data: data! as Data)
            } else {
                let myGif = UIImage.gifImageWithName("funny")
                cell.cellimg.image = UIImage(named: tempPerson.img)
                cell.cellimg.image = myGif
            }
            cell.cellLabel.text = tempPerson.fullName
            cell.cellDes.text = tempPerson.description
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == SyllabusTable) {
            return UITableView.automaticDimension
        } else {
            return tableView.rowHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt IndexPath: IndexPath) -> CGFloat {
        if(tableView == SyllabusTable) {
            return UITableView.automaticDimension
        } else {
            return tableView.rowHeight
        }
    }
    
    @IBOutlet weak var scoreTable: UITableView!
    @IBOutlet weak var classTable: UITableView!
    var detailItem: String?
    @IBOutlet var ItemView: UIView!
    
    var item: String? {
        didSet {
            refreshUI()
        }
    }
    
    func configureView() {
        switch detailItem {
            case "Profile":
                setProfile()
            case "Calendar":
                setCalendar()
            case "Gradebook":
                setGradeView()
            case "Membership":
                setMembership()
            case "Class":
                setClass()
            case "Resource":
                setResourceView()
            case "Assignment":
                setAssignmentView()
            case "Annoucement":
                setAnnoucementView()
            case "Lesson":
                setLessonView()
            case "Youtube":
                setYoutubeView()
            case "Syllabus":
                setSyllabusView()
            default:
                print("error")
        }
    }
    
    
    func refreshUI() {
        loadViewIfNeeded()
        self.view.addSubview(ItemView)
    }
    
    func hideAll() {
        profileTableView.isHidden = true
        calendarView.isHidden = true
        getButton.isHidden = true
        scoreTable.isHidden = true
        classTable.isHidden = true
        AssignmentView.isHidden = true
        ResourceView.isHidden = true
        Newest.isHidden = true
        DueSoon.isHidden = true
        SchoolImg.isHidden = true
        memcollectionview.isHidden = true
        announcementView.isHidden = true
        YoutubeView.isHidden = true
        lessonTable.isHidden = true
        SyllabusTable.isHidden = true
    }
    
    func setProfile(){
        hideAll()
        self.lastExpandedSectionInPro = -1
        profileTableView.isHidden = false
    }
    
    func setCalendar(){
        hideAll()
        initCalendarView()
        calendarView.isHidden = false
    }
    
    func setSyllabusView() {
        hideAll()
        SyllabusTable.isHidden = false
    }
    
    func setLessonView(){
        hideAll()
        lessonTable.isHidden = false
    }
    
    func setYoutubeView() {
        hideAll()
        YoutubeView.isHidden = false
    }
    
    func setAnnoucementView() {
        hideAll()
        announcementView.isHidden = false
    }
    
    func setAssignmentView() {
        hideAll()
        AssignmentView.isHidden = false
        Newest.isHidden = false
        DueSoon.isHidden = false
    }
    
    func setResourceView() {
        hideAll()
        ResourceView.isHidden = false
    }
    
    func setGradeView() {
        hideAll()
        scoreTable.isHidden = false
    }
    
    func setMembership() {
        hideAll()
        memcollectionview.isHidden = false
    }

    func setClass() {
        hideAll()
        if(memberStr == "ECE.564.01.F18") {
            getButton.isHidden = false
            classTable.isHidden = false
        }
    }
        //Begin: profileTableView Helper Functions
    
    //Helper function: return rowName, rowType(whether labelRow or inputRow), and index in rowNames array of this section. Used for generating correct type of TableCell
    func getRowNameAndType(_ indexPath:IndexPath) -> (String, RowType, Int){
        let section:Int = indexPath.section
        let row:Int = indexPath.row
        let rowNames:[(String, Bool)] = sectionsInPro[section].rowNames
        
        var name:String = rowNames[0].0
        var type:RowType = .labelRow
        var i = 0
        var rowNameIndex = 0
        while rowNameIndex < rowNames.count {
            name = rowNames[rowNameIndex].0
            type = .labelRow
            if( i==row ){
                break
            }
            i += 1
            if rowNames[rowNameIndex].1 {
                type = .inputRow
                if( i==row ){
                    break
                }
                i += 1
            }
            rowNameIndex += 1
        }
        return (name, type, rowNameIndex)
    }
    
    //Helper function. Return all indexPaths in one section
    func getAllIndexPaths(in section:Int) -> [IndexPath] {
        var sectionIndexPaths = [IndexPath]()
        
        if section >= 0{
            for row in 0 ..< sectionsInPro[section].numberOfRows() {
                let indexPath = IndexPath(row: row, section: section)
                sectionIndexPaths.append(indexPath)
            }
        }
        return sectionIndexPaths
    }
    
    //Used to handle section expand and close when profileTableViewCell SECTION HEADER is focused
    func handleSectionExpandClose(sender:UIButton) {
        let section:Int = sender.tag
        if section == self.lastExpandedSectionInPro {return}
        let indexPathsToShow = getAllIndexPaths(in: section)
        let indexPathsToHide = getAllIndexPaths(in: self.lastExpandedSectionInPro)
        //Delete rows of prev focused section
        if(self.lastExpandedSectionInPro>=0){
            sectionsInPro[self.lastExpandedSectionInPro].isSectionExpanded = false
        }
        self.profileTableView.deleteRows(at: indexPathsToHide, with: .fade)
        //Insert rows of next focused section
        sectionsInPro[section].isSectionExpanded = true
        self.profileTableView.insertRows(at: indexPathsToShow, with: .fade)
        self.lastExpandedSectionInPro = section
    }
    
    //End: profileTableView Helper Functions
    
    //Begin: calendarView Init
    func initCalendarView(){
        let calendarViewX: Int = 0
        calendarView = UIView(frame: CGRect(x: calendarViewX, y: 0, width: 1285-calendarViewX , height: 1080))
        calendarView.backgroundColor = .white
        self.view.addSubview(calendarView)
        
        let subX: Int = (1285-1050) / 2
        self.showDateInCal = UIView(frame: CGRect(x: subX, y: 10, width: 1050, height: 250))
        self.showDateInCal.backgroundColor = .white
        calendarView.addSubview(self.showDateInCal)
        
        self.myScrollInCal = UIScrollView(frame: CGRect(x: subX, y: 260, width: 1050, height: 720))
        self.myScrollInCal.backgroundColor = .white
        calendarView.addSubview(self.myScrollInCal)
        
        self.myContentInCal = UIView(frame: CGRect(x: 0, y: 0, width: 1050, height: 2420))
        self.myContentInCal.backgroundColor = .white
        myScrollInCal.addSubview(self.myContentInCal)
        //MARK:Don't forget the following one statement. Otherwise contentView can't scroll!!!
        self.myScrollInCal.contentSize = CGSize(width: 1050, height: 2420)
        
        addTimeGrids()
        
        self.eventLabelInCal = UILabel(frame: CGRect(x: subX, y: 980, width: 1050, height: 100))
        eventLabelInCal.backgroundColor = .white
        eventLabelInCal.font = UIFont.systemFont(ofSize: 15)
        eventLabelInCal.numberOfLines = 5
        eventLabelInCal.textAlignment = .left
        eventLabelInCal.textColor = .black
        calendarView.addSubview(self.eventLabelInCal)
        
        self.whichWeekInCal = 0
        
        drawWeekButtons()
        drawWeekdays()
        drawTodayCircle()
        drawDatesInWeek()
        drawTodayLabel()
        
        drawHelperViews()
        drawInitEventCells()
    }
    
    //Add grid lines in myContentInCal UIView
    func addTimeGrids(){
        for i in 0 ..< timeLabelStrings.count {
            var textLabel: UILabel!
            textLabel = UILabel(frame: CGRect(x:10, y:i*100 , width: 50, height: 20))
            textLabel.isHidden = false
            textLabel.backgroundColor = UIColor.white
            textLabel.text = timeLabelStrings[i]
            textLabel.font = UIFont.systemFont(ofSize: 15)
            textLabel.textColor = UIColor.gray
            textLabel.textAlignment = .right
            myContentInCal.addSubview(textLabel)
            
            var lineView: UIView!
            lineView = UIView(frame: CGRect(x:70, y:i*100+10, width:980, height:1))
            lineView.backgroundColor = .gray
            myContentInCal.addSubview(lineView)
        }
        
        for i in 0...7 {
            var lineView: UIView!
            lineView = UIView(frame: CGRect(x:i*140+69, y:10, width:1, height:2400))
            lineView.backgroundColor = .gray
            myContentInCal.addSubview(lineView)
        }
    }
    
    //Returns a WeekButton
    func getWeekButton(pos:CGRect, bgColor:UIColor, title:String, titleColor:UIColor, lastThisNext:Int) -> WeekButton {
        let btn = WeekButton()
        btn.firstDateOfWeek = CalendarTool.firstDateThisWeek(self.todayInCal)
        btn.lastThisNext = lastThisNext
        btn.frame = pos
        btn.backgroundColor = bgColor  //UIColor((255,60,50,1))
        btn.layer.borderColor = btn.backgroundColor!.cgColor
        btn.layer.cornerRadius = 10
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for:.normal)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.titleLabel?.textAlignment = .center
        return btn
    }
    
    //Draw "Last Week", "This Week" and "Next Week" buttons on showDateInCal UIView
    func drawWeekButtons(){
        let lastWeekButtonInCalPos = CGRect(x: 40, y: 180, width: 250, height: 50)
        let lastWeekBgColor = UIColor((255,60,50,1))
        let lastWeekTitle = "Last Week"
        let lastWeekTitleColor = UIColor.white
        let thisWeekButtonInCalPos = CGRect(x: 330, y: 180, width: 400, height: 50)
        let thisWeekBgColor = UIColor.white
        let thisWeekTitle = "This Week"
        let thisWeekTitleColor = UIColor((255,60,50,1))
        let nextWeekButtonInCalPos = CGRect(x: 770, y: 180, width: 250, height: 50)
        let nextWeekBgColor = UIColor((255,60,50,1))
        let nextWeekTitle = "Next Week"
        let nextWeekTitleColor = UIColor.white
        
        self.lastWeekButtonInCal = getWeekButton(pos: lastWeekButtonInCalPos, bgColor: lastWeekBgColor, title: lastWeekTitle, titleColor: lastWeekTitleColor, lastThisNext: -1)
        showDateInCal.addSubview(self.lastWeekButtonInCal)
        self.thisWeekButtonInCal = getWeekButton(pos: thisWeekButtonInCalPos, bgColor: thisWeekBgColor, title: thisWeekTitle, titleColor: thisWeekTitleColor, lastThisNext: 0)
        showDateInCal.addSubview(self.thisWeekButtonInCal)
        self.nextWeekButtonInCal = getWeekButton(pos: nextWeekButtonInCalPos, bgColor: nextWeekBgColor, title: nextWeekTitle, titleColor: nextWeekTitleColor, lastThisNext: 1)
        showDateInCal.addSubview(self.nextWeekButtonInCal)
        
        self.lastWeekButtonInCal.addTarget(self, action: #selector(DetailViewController.clickWeekButton(_:)), for: UIControl.Event.primaryActionTriggered)
        self.thisWeekButtonInCal.addTarget(self, action: #selector(DetailViewController.clickWeekButton(_:)), for: UIControl.Event.primaryActionTriggered)
        self.nextWeekButtonInCal.addTarget(self, action: #selector(DetailViewController.clickWeekButton(_:)), for: UIControl.Event.primaryActionTriggered)
    }
    
    //Event Handler function when select a WeekButton, show all Dates and EventCells for a selected week.
    @objc func clickWeekButton(_ sender:WeekButton){
        let lastThisNext:Int = sender.lastThisNext
        //        if let date = sender.firstDateOfWeek {
        //            print("sender.firstDateOfWeek = " + date.description(with: .current))
        //        }else{
        //            print("Can't receive sender WeekButton!")
        //        }
        //
        if(lastThisNext == 0){
            self.whichWeekInCal = 0
        }else{
            self.whichWeekInCal += lastThisNext
        }
        
        let tempDate = CalendarTool.endDate(self.todayInCal, unit: .day, addValue: self.whichWeekInCal * 7)
        let tempFd = CalendarTool.firstDateThisWeek(tempDate)
        
        //Update DateLabels with new dates.
        //MARK: pass the first Date of week
        let datesInWeek:[Int] = CalendarTool.datesInWeek(tempFd)
        //print("self.eventButtonsInCal.count = \(self.eventButtonsInCal.count)")
        for i in 0...6 {
            self.dateLblsInCal[i].text = String(datesInWeek[i])
        }
        
        //Update text of todayLabelInCal
        var myStr:String = tempDate.description(with: .current)
        if let range = myStr.range(of: "at") {
            let firstPart = myStr[myStr.startIndex..<range.lowerBound]
            myStr = String(firstPart)
        }
        self.todayLblInCal.text = myStr
        
        //Delete EventCells currently displayed
        for i in 0 ..< self.eventButtonsInCal.count {
            self.eventButtonsInCal[i].removeFromSuperview()
        }
        self.eventButtonsInCal = [EventButton]()
        
        //Draw EventCells for the new week chosen
        drawCellsForWeek(firstDate: tempFd)
    }
    
    //Draw weekdays labels
    func drawWeekdays(){
        let weekdayStr:[String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for i in 0..<weekdayStr.count {
            let weekdayLbl = UILabel()
            weekdayLbl.frame = CGRect(x: i*140+70, y: 90, width: 140, height: 30)
            weekdayLbl.backgroundColor = .white
            weekdayLbl.text = weekdayStr[i]
            weekdayLbl.font = UIFont.systemFont(ofSize: 20)
            weekdayLbl.textColor = .gray
            weekdayLbl.textAlignment = .center
            self.showDateInCal.addSubview(weekdayLbl)
        }
    }
    
    //Use a red circle to highlight TODAY
    func drawTodayCircle(){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:25, y: 25), radius: 25, startAngle: CGFloat(0.0).toRadians(), endAngle: CGFloat(360.0).toRadians(), clockwise: true)
        let circleLayer = CAShapeLayer()
        let i = CalendarTool.DayinWeek(self.todayInCal)
        circleLayer.frame = CGRect(x: i*140-25, y: 125, width: 2 * 25, height: 2 * 25)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor((255,60,50,1)).cgColor
        self.showDateInCal.layer.addSublayer(circleLayer)
    }
    
    //Calculate and draw datesLblInCal in current week
    func drawDatesInWeek(){
        let datesInWeek:[Int] = CalendarTool.datesInWeek(CalendarTool.firstDateThisWeek(self.todayInCal))
        for i in 0..<datesInWeek.count {
            let dateLbl = UILabel()
            dateLbl.frame = CGRect(x: i*140+70, y: 130, width: 140, height: 40)
            dateLbl.backgroundColor = .clear
            dateLbl.text = String(datesInWeek[i])
            dateLbl.font = UIFont.systemFont(ofSize: 25)
            if(whichWeekInCal == 0 && datesInWeek[i] == CalendarTool.Day(self.todayInCal)) {
                dateLbl.textColor = .white
            }else{
                dateLbl.textColor = .black
            }
            dateLbl.textAlignment = .center
            self.dateLblsInCal.append(dateLbl)
            self.showDateInCal.addSubview(dateLbl)
        }
    }
    
    //Draw todayLblInCal
    func drawTodayLabel(){
        var myStr:String = self.todayInCal.description(with: .current)
        if let range = myStr.range(of: "at") {
            let firstPart = myStr[myStr.startIndex..<range.lowerBound]
            myStr = String(firstPart)
        }
        
        let todayLblInCal = UILabel()
        todayLblInCal.frame = CGRect(x: 70, y: 20, width: 980, height: 50)
        todayLblInCal.backgroundColor = .clear
        todayLblInCal.text = myStr
        todayLblInCal.font = UIFont.systemFont(ofSize: 30)
        todayLblInCal.textAlignment = .center
        self.todayLblInCal = todayLblInCal
        self.showDateInCal.addSubview(todayLblInCal)
    }
    
    //Draw DumbButtons, used for help scroll the scroll view. Otherwise there is no focused item for scrolling. They are always displayed!
    func drawHelperViews(){
        let eventInfoView = DumbButton(frame: CGRect(x:489, y:210, width:140, height:100))
        eventInfoView.backgroundColor = UIColor.orange
        eventInfoView.setTitle("ECE 590.04 Computer and Information Security", for: .normal)
        eventInfoView.setTitleColor(.white, for:.normal)
        eventInfoView.setTitleColor(UIColor.green, for: .highlighted)
        eventInfoView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        eventInfoView.titleLabel?.numberOfLines = 100/20
        eventInfoView.titleLabel?.textAlignment = .left
        eventInfoView.isEnabled = true
        myContentInCal.addSubview(eventInfoView)
        
        let eventInfoView1 = DumbButton(frame: CGRect(x:489, y:2010, width:140, height:100))
        eventInfoView1.backgroundColor = UIColor.orange
        eventInfoView1.setTitle("ECE 564 Mobile App Development iOS", for: .normal)
        eventInfoView1.setTitleColor(.white, for:.normal)
        eventInfoView1.setTitleColor(UIColor.green, for: .highlighted)
        eventInfoView1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        eventInfoView1.titleLabel?.numberOfLines = 100/20
        eventInfoView1.titleLabel?.textAlignment = .left
        eventInfoView1.isEnabled = true
        myContentInCal.addSubview(eventInfoView1)
    }
    
    //Draw cells for the week with given firstDate.
    //MARK: pass the first Date of a week (Sunday)
    func drawCellsForWeek(firstDate:Date){
        let fd = CalendarTool.firstDateThisWeek(firstDate)
        let startOfWeek = Calendar.current.startOfDay(for: fd)
        let ed = CalendarTool.endDate(fd, unit: .day, addValue: 7)
        let endOfWeek = Calendar.current.startOfDay(for: ed)
        
        for ec in eventCells {
            if (ec.startTime < startOfWeek || ec.startTime >= endOfWeek){
                continue
            }
            let rand:Int = Int.random(in: 0...9)
            let evBtn = ec.drawEventButton(color:colors[rand])
            self.eventButtonsInCal.append(evBtn)
            myContentInCal.addSubview(evBtn)
        }
    }
    
    //Draw initial eventCells, actually they are eventCells for current week
    func drawInitEventCells() {
        drawCellsForWeek(firstDate: self.todayInCal)
    }
    
    //When focus point moves, change contents in eventLabelInCal UILabel
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if detailItem == "Profile" {
            guard let button = UIScreen.main.focusedView as? UIButton else {
                return
            }
            handleSectionExpandClose(sender: button)
        } else if detailItem == "Calendar" {
            if let focusedButton = UIScreen.main.focusedView as? EventButton {
                if let i = focusedButton.eventID {
                    let event = eventCells[i]
                    let footerText:String = "Title: " + event.title + "\nStart: \(shortenLocale(event.startTime))" + "           " + "End: \(shortenLocale(event.endTime))" + "\nLocation: " + event.location + "          " + "People: " + event.people + "\nDetails: " + event.details
                    eventLabelInCal.text = footerText
                }
            }
        }
    }
    
    //End: calendarView Init

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Youtube") {
            if let destination = segue.destination as? YouTubeController {
                let rowIdx = YoutubeTable.indexPathForSelectedRow!.row
                destination.videotoken = videoArray[rowIdx].token
            }
        } else if (segue.identifier == "resourceSegue") {
            if let destination = segue.destination as? newresourceViewController {
                let indexPaths = ResourceCollection.indexPathsForSelectedItems
                let indexPath : NSIndexPath = indexPaths![0] as NSIndexPath
                destination.fileType = resourceArray[indexPath.item].type
                destination.fileName = resourceArray[indexPath.item].title
            }
        }
    }
 
    func convertJsonToPeople( peopleFromServer: inout [DukePerson], post: inout [[String: AnyObject]]) {
        for p in post {
            let t = DukePerson("", "")
            if let fn = p["firstname"] as? String
            {
                t.firstName = String(fn)
            }
            if let uid = p["uid"] as? Int
            {
                t.uid = uid
            }
            if let ln = p["lastname"] as? String
            {
                t.lastName = String(ln)
            }
            if let wf = p["wherefrom"] as? String
            {
                t.whereFrom = String(wf)
            }
            if let g = p["gender"] as? Bool
            {
                t.gender = g ? Gender.Male : .Female
            }
            if let r = p["role"] as? String
            {
                t.role = r == "TA" ? DukeRole.TA : r == "Professor" ? DukeRole.Professor : DukeRole.Student
            }
            
            if let team = p["team"] as? String
            {
                t.team = team
            }
            
            if let hb = p["hobbies"] as? [String]
            {
                t.hobbies = hb
            }
            
            if let lang = p["languages"] as? [String]
            {
                t.bestProgrammingLanguages = lang
            }
            
            if let pic = p["pic"] as? String
            {
                t.imgForJSON = pic
            }
            peopleFromServer.append(t)
        }
    }
    
    /*this is a helper function to check if a person is in item*/
    func containsPeople(_ p: DukePerson) -> Bool {
        for i in items {
            for j in i {
                if ((j.firstName == p.firstName && j.lastName == p.lastName) || j.uid != nil && j.uid == p.uid) {
                    return true
                }
            }
        }
        return false
    }
    
    /*this function add persons from server to items*/
    func addPeopleFromNet(_ peopleFromServer: inout [DukePerson]) {
        for p in peopleFromServer {
            if p.role == .Professor {
                items[0].append(p)
            } else if p.role == .TA {
                items[1].append(p)
            } else {
                let idx = sections.index(of: p.team)
                if(idx != nil) {
                    if(!containsPeople(p)) {
                        items[idx!].append(p)
                    }
                } else {
                    sections.append(p.team)
                    items.append([DukePerson]())
                    if(!containsPeople(p)) {
                        items[items.count - 1].append(p)
                    }
                }
            }
        }
    }
    /*this function handles get request */
    @objc func GETJson() -> Bool {
        let url = URL(string: "http://ece564.colab.duke.edu:5000/get")
        var isJSON = true
        var peopleFromServer = [DukePerson]()
        let httprequest = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error != nil
            {
                print("error calling GET on /posts/55")
                isJSON = false
            }
            else
            {
                do {
                    var post = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: AnyObject]]
                    self.convertJsonToPeople(peopleFromServer: &peopleFromServer, post: &post)
                    self.addPeopleFromNet(&peopleFromServer)
                    DispatchQueue.main.async {
                        self.classTable.reloadData()
                    }
                    // print(post)
                } catch let error {
                    print("json error: \(error)")
                    isJSON = false
                }
            }
            
        }
        httprequest.resume()
        return isJSON
    }
    
    /*this function convert a DukePerson into a dictionary and then it convert the
     * dictionary into JSON */
    func postSinglePeople(p : DukePerson) -> String {
        var res = ""
        var dic = [String:AnyObject]()
        dic["uid"] = p.uid as AnyObject
        dic["firstname"] = p.firstName as AnyObject
        dic["lastname"] = p.lastName as AnyObject
        dic["wherefrom"] = p.whereFrom as AnyObject
        dic["gender"] = (p.gender == Gender.Male ? true : false )as AnyObject
        dic["role"] = p.role.rawValue as AnyObject
        dic["degree"] = p.degree as AnyObject
        dic["team"] = p.team as AnyObject
        dic["hobbies"] = p.hobbies as AnyObject
        dic["languages"] = p.bestProgrammingLanguages as AnyObject
        dic["pic"] = (p.imgForJSON ?? "xx") as AnyObject
        
        do {
            let jsonOutput = try JSONSerialization.data(withJSONObject: dic)
            res = String(data: jsonOutput, encoding: String.Encoding.utf8)! as String
        } catch let error {
            print("json error: \(error)")
        }
        print("res: \(res)")
        return res
    }
    
    /*this function post a DukePerson to server*/
    func postPeople(member: DukePerson) {
        let url = URL(string: "http://ece564.colab.duke.edu:5000/send")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let postString = postSinglePeople(p: member)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return // check for fundamental networking error
                }
                
                // Getting values from JSON Response
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
            }
            task.resume()
            //            print("response: \()")
        }
    }
    
    
    @IBAction func returnFromResource(segue: UIStoryboardSegue) {
        
    }
    
    

}

/*extension DetailViewController: ItemSelectionDelegate {
    func itemSelected(_ newItem: String) {
        item = newItem
    }
}*/


