//
//  MasterViewController.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/9/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit
import URBNDataSource

class MasterViewController: UITableViewController {

    internal var detailViewController: UINavigationController?
    
    private let dataSource: URBNArrayDataSourceAdapter = URBNArrayDataSourceAdapter(items: nil)
    private var objects = [BaseDetailViewController]()

    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

        dataSource.replaceItems([TextDetailViewController.self])
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        dataSource.fallbackDataSource = self
        dataSource.tableView = tableView
        
        dataSource.registerCellClass(UITableViewCell.self) { (cell, obj, indexPath) -> Void in
            if let tvCell = cell as? UITableViewCell {
                obj as! BaseDetailViewController.Type
                tvCell.textLabel?.text = obj.displayName
            }
        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let detailVC = detailViewController as UINavigationController! {
            let vcClass = dataSource.itemAtIndexPath(indexPath) as! BaseDetailViewController.Type
            let vc = vcClass.init()
            
            detailVC.viewControllers = [vc]
            splitViewController?.showDetailViewController(detailVC, sender: self)
        }
    }

}

