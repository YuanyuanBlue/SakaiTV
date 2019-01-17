//
//  annoBodyViewController.swift
//  SakaiTV
//
//  Created by tong on 12/6/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit

class annoBodyViewController: UIViewController {

    
    @IBOutlet weak var annotext: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotext.text = ""
        //annotext.centertext()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        annotext.text = cur_body
        
        
    }



}
