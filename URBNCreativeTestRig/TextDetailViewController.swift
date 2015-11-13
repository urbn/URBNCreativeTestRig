//
//  TextDetailViewController.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/9/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit
import URBNConvenience

class OptionsLabel: UILabel {
    private var optionsKey: String
    private var options: TextOptions = TextOptions() {
        didSet {
            let data = NSKeyedArchiver.archivedDataWithRootObject(options)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: optionsKey)
        }
    }
    
    init(key: String) {
        optionsKey = key
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(optionsKey) as? NSData,
            let savedOptions = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? TextOptions {
                options = savedOptions
        }
        else {
            options = TextOptions()
        }
        
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextDetailViewController: BaseDetailViewController {

    class override var displayName: String {
        return "Text Options"
    }
    
    private let titleLabel = OptionsLabel(key: "titleOptions")
    private let subTitleLabel = OptionsLabel(key: "subTitleOptions")
    private let bodyLabel = OptionsLabel(key: "bodyOptions")
    private let priceLabel = OptionsLabel(key: "priceOptions")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        if titleLabel.options.text == "Sample" {
            titleLabel.options.text = "This is your title"
        }
        titleLabel.attributedText = titleLabel.options.attributedString()
        view.addSubview(titleLabel)
        
        if subTitleLabel.options.text == "Sample" {
            subTitleLabel.options.text = "This is your subtitle title"
        }
        subTitleLabel.attributedText = subTitleLabel.options.attributedString()
        view.addSubview(subTitleLabel)

        if bodyLabel.options.text == "Sample" {
            bodyLabel.options.text = "This is your body text. Double tap any of the labels to edit individual values for the labels."
        }
        bodyLabel.attributedText = bodyLabel.options.attributedString()
        view.addSubview(bodyLabel)

        if priceLabel.options.text == "Sample" {
            priceLabel.options.text = "$100"
        }
        priceLabel.attributedText = priceLabel.options.attributedString()
        view.addSubview(priceLabel)
        
        let views: Dictionary<String, UILabel> = ["titleLabel" : titleLabel, "subTitleLabel" : subTitleLabel, "bodyLabel" : bodyLabel, "priceLabel" : priceLabel]

        for label in views.values {
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
            tap.numberOfTapsRequired = 2
            label.addGestureRecognizer(tap)
            label.userInteractionEnabled = true
        }

        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[titleLabel]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[titleLabel]-[subTitleLabel]-[bodyLabel]-[priceLabel]", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views))
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if let label = recognizer.view as? OptionsLabel {
            let toggleVC = TextDetailTogglesViewController(textOptions: label.options, completion: { (canceled, options) -> Void in
                self.closeToggles()
                if !canceled {
                    label.attributedText = options.attributedString()
                    label.options = options
                }
            })
            
            let toggles = UINavigationController(rootViewController: toggleVC)

            self.presentViewController(toggles, animated: true, completion: nil)
        }
    }
    
    func closeToggles() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
