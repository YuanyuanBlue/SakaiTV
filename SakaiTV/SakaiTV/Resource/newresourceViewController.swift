//
//  newresourceViewController.swift
//  SakaiTV
//
//  Created by tong on 12/7/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

class newresourceViewController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    var fileType: String = ""
    var fileName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.frame = CGRect(x: 0, y: 0, width: scrollview.frame.width, height: scrollview.frame.height*2)
        scrollview.contentSize = scrollview.frame.size
        if fileType == "pdf" {
            let pdf : CGPDFDocument = openPDF(filename: fileName)
            let i_arr : NSMutableArray = imageForPDF(document: pdf)
            print(i_arr)
            self.addImagescrollview(arr: i_arr)
        } else if (fileType == "jpg" || fileType == "png" || fileType == "jpeg") {
            
            let pic : UIImage = UIImage(named: fileName + "." + fileType)!
            let imgview = UIImageView(frame: self.scrollview.frame)
            imgview.image = pic
            imgview.frame = CGRect(x: 0, y: 0, width: imgview.frame.size.width, height: imgview.frame.size.height)
            self.scrollview.addSubview(imgview)
            
            
        } else {
            
        }
        self.scrollview.backgroundColor = UIColor.white;
        self.scrollview.panGestureRecognizer.allowedTouchTypes = [NSNumber(value:UITouch.TouchType.indirect.rawValue)]
        // Do any additional setup after loading the view.
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
        //        scrollview.frame = CGRect(x: 0, y: 0, width: scrollview.frame.width, height: scrollview.frame.height*2)
        //        scrollview.contentSize = scrollview.frame.size
        print("totalpages: \(totalpages)")
        let pageimages : NSMutableArray = []
        for i in 1..<totalpages+1 {
            let page = document.page(at: i)
            //print("page: \(page)")
            let pageRect = page!.getBoxRect(.mediaBox)
            UIGraphicsBeginImageContext(pageRect.size)
            let context : CGContext = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: pageRect.size.height)
            context.scaleBy(x: 1, y: -1)
            context.concatenate(page!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(page!)
            
            //            let scale = imageWidth / pageRect.size.width
            //            pageRect.size = CGSize(width: pageRect.size.width * scale, height:  pageRect.size.height * scale)
            //            pageRect.origin = CGPoint.zero
            //
            //            UIGraphicsBeginImageContext(pageRect.size)
            //            let ctx = UIGraphicsGetCurrentContext()
            //            ctx!.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            //            ctx!.fill(pageRect)
            //            ctx!.saveGState()
            //            ctx!.translateBy(x: 0.0, y: pageRect.size.height)
            //            ctx!.scaleBy(x: 1.0, y: -1.0)
            //            ctx!.concatenate(page!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            //
            //            ctx!.drawPDFPage(page!)
            //            ctx!.restoreGState()
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
            //            imgview.image = UIImage(named: "Open-file-icon.png")
            self.scrollview.addSubview(imgview)
            heigth += imgview.frame.height
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
