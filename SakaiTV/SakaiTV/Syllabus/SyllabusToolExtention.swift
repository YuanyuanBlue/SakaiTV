//
//  SyllabusToolExtention.swift
//  SakaiTV
//
//  Created by tong on 12/6/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

//reference: https://www.youtube.com/watch?v=Tf0_Fys6i7A

import UIKit

extension UITextView {
    func centertext() {
        var topcorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topcorrect = topcorrect < 0.0 ? 0.0  : topcorrect
        self.contentInset.top = topcorrect
    }
}
