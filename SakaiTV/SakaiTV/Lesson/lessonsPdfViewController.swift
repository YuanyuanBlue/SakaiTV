//
//  lessonsPdfViewController.swift
//  SakaiTV
//
//  Created by tong on 12/6/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

class lessonsPdfViewController: UIViewController {


    
    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.frame = CGRect(x: 0, y: 0, width: scrollview.frame.width, height: scrollview.frame.height*2)
        scrollview.contentSize = scrollview.frame.size
        let pdf : CGPDFDocument = openPDF(filename: nameoffile)
        let i_arr : NSMutableArray = imageForPDF(document: pdf)
        print(i_arr)
        self.addImagescrollview(arr: i_arr)
        self.scrollview.backgroundColor = UIColor.white;
        self.scrollview.panGestureRecognizer.allowedTouchTypes = [NSNumber(value:UITouch.TouchType.indirect.rawValue)]
    }
    
    
    
    //https://stackoverflow.com/questions/34535769/rendering-pdf-in-apple-tv-tvos/34596250
    func openPDF(filename: String) -> CGPDFDocument {
        print(filename)
        let path = Bundle.main.path(forResource: filename, ofType: "pdf")!
        let cString = path.cString(using: String.Encoding.macOSRoman)!
        
        let cfString = CFStringCreateWithCString(nil, cString, CFStringBuiltInEncodings.macRoman.rawValue)
        let url: CFURL = CFURLCreateWithFileSystemPath (nil, cfString, CFURLPathStyle(rawValue: 0)!, false);
        let pdf : CGPDFDocument = CGPDFDocument (url)!;
        let count = pdf.numberOfPages
        return (count == 0 ? nil : pdf)!
        
    }
    
    
    func imageForPDF(document: CGPDFDocument) -> NSMutableArray{
        let totalpages = document.numberOfPages
        
        print("totalpages: \(totalpages)")
        let pageimages : NSMutableArray = []
        for i in 1..<totalpages+1 {
            let page = document.page(at: i)
            let pageRect = page!.getBoxRect(.mediaBox)
            UIGraphicsBeginImageContext(pageRect.size)
            let context : CGContext = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: pageRect.size.height)
            context.scaleBy(x: 1, y: -1)
            context.concatenate(page!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(page!)
            
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            pageimages.add(image!)
            self.scrollview.contentSize = CGSize(width: scrollview.contentSize.width, height: scrollview.contentSize.height + (image?.size.height)!)
            print(scrollview.contentSize)
        }
        return pageimages
    }
    
    func addImagescrollview(arr: NSMutableArray){
        var heigth : CGFloat = 0
        for cur_image in arr {
            let imgview = UIImageView(frame: self.scrollview.frame)
            imgview.image = cur_image as? UIImage
            imgview.frame = CGRect(x: 0, y: heigth, width: imgview.frame.size.width, height: imgview.frame.size.height)
            self.scrollview.addSubview(imgview)
            heigth += imgview.frame.height
        }
    }
}
