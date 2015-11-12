//
//  FontsTableViewController.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/12/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit
import URBNDataSource

class FontsTableViewController: UITableViewController {

    private let completion: (fontName: String) -> (Void)
    private let dataSource = URBNArrayDataSourceAdapter(items: nil)
    private lazy var typeFaces: Array<String> = {
        var fonts: Array<String> = SystemFonts.allValues
        
        let fontFamilies = UIFont.familyNames()
        for family in fontFamilies {
            if UIFont.fontNamesForFamilyName(family).count > 0 {
                fonts.appendContentsOf(UIFont.fontNamesForFamilyName(family))
            }
            else {
                fonts.append(family)
            }
        }
        
        return fonts
    }()
    
    internal init(completionBlock: (fontName: String) -> (Void)) {
        completion = completionBlock
        
        super.init(style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        dataSource.replaceItems(typeFaces)
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        dataSource.fallbackDataSource = self
        dataSource.tableView = self.tableView
        
        dataSource.registerCellClass(UITableViewCell.self) { (cell, obj, indexPath) -> Void in
            if let tvCell = cell as? UITableViewCell {
                if let fontName = obj as? String {
                    tvCell.textLabel?.text = fontName
                    tvCell.textLabel?.font = TextOptions.fontForName(fontName, size: 12.0)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        completion(fontName: typeFaces[indexPath.row])
    }
}
