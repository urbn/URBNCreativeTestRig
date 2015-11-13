//
//  TextDetailTogglesViewController.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/9/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit

class OptionTextField: UITextField {
    var setTextBlock: () -> (Void) = {}
    override var text: String? {
        didSet {
            setTextBlock()
        }
    }
}

class TextDetailTogglesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    private let options: TextOptions
    private let completionCallback: (canceled: Bool, options: TextOptions) -> (Void)

    private let textView = UITextView()
    private let fontField = OptionTextField()
    private let sizeField = UITextField()
    private let kerningField = UITextField()
    private let colorField = OptionTextField()

    private let alignmentField = OptionTextField()
    private let lineSpacingField = UITextField()
    private let paragraphSpacingField = UITextField()
    
    private var currentresponder: UIResponder?
    
    init(textOptions: TextOptions, completion: (canceled: Bool, options: TextOptions) -> Void) {
        options = textOptions.copy() as! TextOptions
        completionCallback = completion
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")

        let accessoryView = UIToolbar(frame: CGRectMake(0.0, 0.0, view.width, 44.0))
        accessoryView.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissKeyboard")]
        let line = UIView()
        line.backgroundColor = UIColor.grayColor()
        line.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.addSubview(line)
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[line]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["line": line]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[line(==1)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["line": line]))
        
        var labels: Dictionary<String, UIView>= [:]

        let textLabel = UILabel()
        textLabel.text = "Text:"
        labels["textLabel"] = textLabel
            
        textView.text = options.text
        textView.delegate = self
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.inputAccessoryView = accessoryView
        view.addSubview(textView)
        
        let fontLabel = UILabel()
        fontLabel.text = "Font:"
        labels["fontLabel"] = fontLabel

        let sizeLabel = UILabel()
        sizeLabel.text = "Size:"
        labels["sizeLabel"] = sizeLabel
        
        let kerningLabel = UILabel()
        kerningLabel.text = "Kerning:"
        labels["kerningLabel"] = kerningLabel
        
        let colorLabel = UILabel()
        colorLabel.text = "Text Color:"
        labels["colorLabel"] = colorLabel
        
        let alignmentLabel = UILabel()
        alignmentLabel.text = "Alignment:"
        labels["alignmentLabel"] = alignmentLabel

        let lineSpacingLabel = UILabel()
        lineSpacingLabel.text = "Line Spacing:"
        labels["lineSpacingLabel"] = lineSpacingLabel

        let paragraphSpacingLabel = UILabel()
        paragraphSpacingLabel.text = "Paragraph Spacing:"
        labels["paragraphSpacingLabel"] = paragraphSpacingLabel

        for label in labels.values {
            if let label = label as? UILabel {
                label.font = UIFont.boldSystemFontOfSize(14.0)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
                view.addSubview(label)
            }
        }
        
        var values: Dictionary<String, UIView>= [:]
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        fontField.text = options.typeFace
        values["fontField"] = fontField
        fontField.setTextBlock = {[unowned self] in
            self.options.typeFace = self.fontField.text!
        }

        sizeField.text = options.fontSize.description
        sizeField.userInteractionEnabled = false
        values["sizeField"] = sizeField
        
        let sizeStepper = UIStepper()
        sizeStepper.minimumValue = 0.0
        sizeStepper.maximumValue = 100.0
        sizeStepper.stepValue = 1.0
        sizeStepper.value = options.fontSize
        sizeStepper.translatesAutoresizingMaskIntoConstraints = false
        sizeStepper.addTarget(self, action: "fontSizeStepperValueChanged:", forControlEvents: .ValueChanged)
        view.addSubview(sizeStepper)
        
        kerningField.text = options.kerning.description
        kerningField.userInteractionEnabled = false
        values["kerningField"] = kerningField
        
        let kerningStepper = UIStepper()
        kerningStepper.minimumValue = 0.0
        kerningStepper.maximumValue = 10.0
        kerningStepper.stepValue = 0.1
        kerningStepper.value = options.kerning
        kerningStepper.translatesAutoresizingMaskIntoConstraints = false
        kerningStepper.addTarget(self, action: "kerningStepperValueChanged:", forControlEvents: .ValueChanged)
        view.addSubview(kerningStepper)
        
        let colorSwatch = UIButton(type: .Custom)
        colorSwatch.backgroundColor = UIColor(hexString: options.textColor)
        colorSwatch.translatesAutoresizingMaskIntoConstraints = false
        colorSwatch.layer.cornerRadius = 15.0
        colorSwatch.layer.borderColor = UIColor.grayColor().CGColor
        colorSwatch.layer.borderWidth = 1.0
        colorSwatch.addTarget(self, action: "colorSwatchTouched", forControlEvents: .TouchUpInside)
        view.addSubview(colorSwatch)
        
        colorField.text = options.textColor
        colorField.delegate = self
        colorField.setTextBlock = {[unowned self] in
            self.options.textColor = self.colorField.text!
            colorSwatch.backgroundColor = UIColor(hexString: self.colorField.text)
        }
        values["colorField"] = colorField
        
        alignmentField.text = options.alignment.rawValue
        alignmentField.inputView = picker
        alignmentField.setTextBlock = {[unowned self] in
            self.options.alignment = TextAlignment(rawValue: self.alignmentField.text!)!
        }
        values["alignmentField"] = alignmentField

        lineSpacingField.text = options.lineSpacing.description
        lineSpacingField.userInteractionEnabled = false
        values["lineSpacingField"] = lineSpacingField

        let lineSpacingStepper = UIStepper()
        lineSpacingStepper.minimumValue = 0.0
        lineSpacingStepper.maximumValue = 10.0
        lineSpacingStepper.stepValue = 0.1
        lineSpacingStepper.value = options.lineSpacing
        lineSpacingStepper.translatesAutoresizingMaskIntoConstraints = false
        lineSpacingStepper.addTarget(self, action: "lineSpacingStepperValueChanged:", forControlEvents: .ValueChanged)
        view.addSubview(lineSpacingStepper)

        paragraphSpacingField.text = options.paragraphSpacing.description
        paragraphSpacingField.userInteractionEnabled = false
        values["paragraphSpacingField"] = paragraphSpacingField

        let paragraphSpacingStepper = UIStepper()
        paragraphSpacingStepper.minimumValue = 0.0
        paragraphSpacingStepper.maximumValue = 10.0
        paragraphSpacingStepper.stepValue = 0.1
        paragraphSpacingStepper.value = options.lineSpacing
        paragraphSpacingStepper.translatesAutoresizingMaskIntoConstraints = false
        paragraphSpacingStepper.addTarget(self, action: "paragraphSpacingStepperValueChanged:", forControlEvents: .ValueChanged)
        view.addSubview(paragraphSpacingStepper)

        for value in values.values {
            if let value = value as? UITextField {
                value.inputAccessoryView = accessoryView
                value.font = UIFont.systemFontOfSize(14.0)
                value.returnKeyType = UIReturnKeyType.Done
                value.delegate = self
                value.translatesAutoresizingMaskIntoConstraints = false
                value.textColor = UIColor.grayColor()
                value.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
                view.addSubview(value)
            }
        }

        var views = labels
        views += values
        views["textView"] = textView
        views["sizeStepper"] = sizeStepper
        views["kerningStepper"] = kerningStepper
        views["colorSwatch"] = colorSwatch
        views["lineSpacingStepper"] = lineSpacingStepper
        views["paragraphSpacingStepper"] = paragraphSpacingStepper
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[textView]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[fontLabel]-[fontField]-20-|", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[sizeLabel]-[sizeField]", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[sizeField]->=10-[sizeStepper]-20-|", options:[.AlignAllCenterY], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[kerningLabel]-[kerningField]", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[kerningField]->=10-[kerningStepper]-20-|", options:[.AlignAllCenterY], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[colorLabel]-[colorField]", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[colorField]->=10-[colorSwatch(30)]-20-|", options:[.AlignAllCenterY], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[colorSwatch(30)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[alignmentLabel]-[alignmentField]-20-|", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[lineSpacingLabel]-[lineSpacingField]", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[lineSpacingField]->=10-[lineSpacingStepper]-20-|", options:[.AlignAllCenterY], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[paragraphSpacingLabel]-[paragraphSpacingField]", options:[.AlignAllBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[paragraphSpacingField]->=10-[paragraphSpacingStepper]-20-|", options:[.AlignAllCenterY], metrics: nil, views: views))

        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[textLabel]-2-[textView(==60)]-p-[fontLabel]-p-[sizeLabel]-p-[kerningLabel]-p-[colorLabel]-p-[alignmentLabel]-p-[lineSpacingLabel]-p-[paragraphSpacingLabel]", options: [.AlignAllLeft], metrics: ["p": 30], views: views))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentresponder?.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentresponder = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        currentresponder = nil
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == fontField {
            let fontVC = FontsTableViewController(completionBlock: { (fontName) -> (Void) in
                textField.text = fontName
                self.options.typeFace = fontName
                self.dismissFonts()
            })

            let nav = UINavigationController(rootViewController: fontVC)
            fontVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "dismissFonts")
            self.presentViewController(nav, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        options.text = textView.text
    }
    func textViewDidBeginEditing(textView: UITextView) {
        currentresponder = textView
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        currentresponder = nil
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TextAlignment.allValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentresponder == nil {
            return ""
        }
        
        return TextAlignment.allValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alignmentField.text = TextAlignment.allValues[row]
    }
    
    func dismissKeyboard() {
        currentresponder?.resignFirstResponder()
    }
    
    func fontSizeStepperValueChanged(sender: UIStepper) {
        sizeField.text = sender.value.description
        options.fontSize = sender.value
    }
    
    func kerningStepperValueChanged(sender: UIStepper) {
        kerningField.text = sender.value.description
        options.kerning = sender.value
    }

    func lineSpacingStepperValueChanged(sender: UIStepper) {
        lineSpacingField.text = sender.value.description
        options.lineSpacing = sender.value
    }

    func paragraphSpacingStepperValueChanged(sender: UIStepper) {
        paragraphSpacingField.text = sender.value.description
        options.paragraphSpacing = sender.value
    }

    func cancel() {
        completionCallback(canceled: true, options: options)
    }

    func save() {
        currentresponder?.resignFirstResponder()
        completionCallback(canceled: false, options: options)
    }
    
    func colorSwatchTouched() {
        colorField.becomeFirstResponder()
    }
    
    func dismissFonts() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left[k] = v
    }
}
