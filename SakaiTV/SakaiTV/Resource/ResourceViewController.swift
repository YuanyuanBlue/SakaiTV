//
//  ResourceViewController.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/16/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

/* This class is used to display pdf and image files
 */
class ResourceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var ResourseTable: UITableView!
    var pageCount: Int = 0
    var fileType: String = ""
    var fileName: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileType == "pdf" ? pageCount : 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath) as! ResourceTableViewCell
        if(fileType == "pdf") {
            let pdf: CGPDFDocument = openPDF(filename: fileName)
            cell.img.image = imageForPDF(document: pdf, pageNumber: indexPath.row + 1, imageWidth: 612.0)
        } else if(fileType == "jpg" || fileType == "jpeg" || fileType == "png") {
            cell.img.image = UIImage(named: fileName + "." + fileType)
        }
        return cell
    }
    
    //let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector(("handleSwipes")))
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ResourseTable.delegate = self
        ResourseTable.dataSource = self
        if(fileType == "pdf") {
            let _: CGPDFDocument = openPDF(filename: fileName)
        } else if (fileType == "jpg" || fileType == "png" || fileType == "jpeg") {
            pageCount = 1
        } else {
            
        }
        
    }
    
    func openPDF(filename: String) -> CGPDFDocument {
        //let path: CFString = CFStringCreateWithCString (nil, filename, CFStringEncoding(String.Encoding.utf8.rawValue));
        //rawvalue = 0?
        let path = Bundle.main.path(forResource: filename, ofType: "pdf")!
        let cString = path.cString(using: String.Encoding.macOSRoman)!
        
        let cfString = CFStringCreateWithCString(nil, cString, CFStringBuiltInEncodings.macRoman.rawValue)
        let url: CFURL = CFURLCreateWithFileSystemPath (nil, cfString, CFURLPathStyle(rawValue: 0)!, false);
        let pdf : CGPDFDocument = CGPDFDocument (url)!;
        let count = pdf.numberOfPages
        self.pageCount = count
        return (count == 0 ? nil : pdf)!
      
    }

   //https://stackoverflow.com/questions/34535769/rendering-pdf-in-apple-tv-tvos/34596250
   // func imageForPDF(URL: NSURL, pageNumber: Int, imageWidth: CGFloat) -> UIImage{
     //   let document = CGPDFDocument(URL)
    func imageForPDF(document: CGPDFDocument, pageNumber: Int, imageWidth: CGFloat) -> UIImage{
        let page = document.page(at: pageNumber)
        var pageRect = page!.getBoxRect(.mediaBox)
        let scale = imageWidth / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width * scale, height:  pageRect.size.height * scale)
        pageRect.origin = CGPoint.zero
        
        UIGraphicsBeginImageContext(pageRect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ctx!.fill(pageRect)
        ctx!.saveGState()
        ctx!.translateBy(x: 0.0, y: pageRect.size.height)
        ctx!.scaleBy(x: 1.0, y: -1.0)
        ctx!.concatenate(page!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        
        ctx!.drawPDFPage(page!)
        ctx!.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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
