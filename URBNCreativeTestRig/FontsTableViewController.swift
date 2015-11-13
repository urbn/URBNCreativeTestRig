//
//  FontsTableViewController.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/12/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit
import URBNDataSource

class FontsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    private let completion: (fontName: String) -> (Void)
    private let dataSource = URBNArrayDataSourceAdapter(items: nil)
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var tableData: Array<String> = []
    
    private lazy var typeFaces: Array<String> = {
        var fonts: Array<String> = []
        
        let fontFamilies = UIFont.familyNames()
        for family in fontFamilies {
            if UIFont.fontNamesForFamilyName(family).count > 0 {
                fonts.appendContentsOf(UIFont.fontNamesForFamilyName(family))
            }
            else {
                fonts.append(family)
            }
        }
        
        fonts.sortInPlace(<)
        
        SystemFonts.allValues
        fonts.insertContentsOf(SystemFonts.allValues, at: 0)

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
        
        view.backgroundColor = UIColor.whiteColor()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        tableData = typeFaces
        dataSource.replaceItems(tableData)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        dataSource.fallbackDataSource = self
        dataSource.tableView = tableView
        
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
        completion(fontName: tableData[indexPath.row])
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text where searchText != "" {
            tableData = typeFaces.filter { (name: String) -> Bool in
                return name.lowercaseString.hasPrefix(searchText.lowercaseString)
            }
        }
        else {
            tableData = typeFaces
        }

        dataSource.replaceItems(tableData)
    }
}
