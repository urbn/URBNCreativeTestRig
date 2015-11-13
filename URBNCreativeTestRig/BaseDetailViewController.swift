//
//  DetailViewController.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/9/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit

class BaseDetailViewController: UIViewController {

    class var displayName: String {
        return "Override Me"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = self.dynamicType.displayName
        navigationController?.navigationBar.translucent = false
    }

}

