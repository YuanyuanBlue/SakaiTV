//
//  ProfileTableViewCell.swift
//  SakaiTV
//
//  Created by 荣欣 on 12/7/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemTextField: UITextField!
    var isInput:Bool!
    var tempColor:UIColor!
    
    func configCell(itemName:String, isInputCell:Bool){
        self.isInput = isInputCell
        itemLabel.isHidden = self.isInput
        itemTextField.isHidden = !self.isInput
        itemLabel.text = itemName
        itemTextField.placeholder = itemName
        itemTextField.text = studentsInPro[itemName]
        self.backgroundColor = UIColor.orange
        
        //Set input types for inputRow
        let low:String = itemName.lowercased()
        itemTextField.keyboardType = { itemName -> UIKeyboardType in
            if low.range(of: "url") != nil{return .URL}
            else if low.range(of: "phone") != nil{return .phonePad}
            else if low.range(of: "email") != nil {return .emailAddress}
            else if low.range(of: "birthday") != nil{return .numbersAndPunctuation}
            else { return .default }
        }(itemName)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextFocus = context.nextFocusedView as? ProfileTableViewCell{
            nextFocus.backgroundColor = UIColor.blue
            nextFocus.itemLabel.textColor = UIColor.white
            nextFocus.itemLabel.font = itemLabel.font.withSize(55)
        }
        
        if let prevFocus = context.previouslyFocusedView as? ProfileTableViewCell{
            prevFocus.backgroundColor = UIColor.orange
            prevFocus.itemLabel.textColor = UIColor.black
            prevFocus.itemLabel.font = itemLabel.font.withSize(40)
        }
    }
    
    //For input cell, focus should be moved to inputTextField. Thanks to https:\//stackoverflow.com/questions/33295800/focus-uitextfield-in-tableviewcell-on-tvos/33305942#33305942
    override var canBecomeFocused: Bool{
        return !self.isInput
    }
}
