//
//  ProfileUtilities.swift
//  SakaiTV
//
//  Created by 荣欣 on 12/7/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation
import UIKit

//Determine what kind of cell row is: Label for display, or input text field
enum RowType:Int{
    case labelRow = 0
    case inputRow = 1
}

//Define the data structure for each expandable section
struct ExpandableSection{
    var isSectionExpanded:Bool = false
    var rowNames:[(String,Bool)] = [("Default RowName", false)]
    // Return number of rows in a section, since a RowName is associated with a labelRow and a inputRow
    func numberOfRows () -> Int{
        var res:Int = 0
        for rowName in rowNames{
            res += 1
            if rowName.1 == true {
                res += 1
            }
        }
        return res
    }
}
