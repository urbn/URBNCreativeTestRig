//
//  TextOptions.swift
//  URBNCreativeTestRig
//
//  Created by Jason Grandelli on 11/10/15.
//  Copyright © 2015 Jason Grandelli. All rights reserved.
//

import UIKit
import UIColor_Utilities

enum SystemFonts: String {
    case Regular
    case Italic
    case Bold
    
    static let allValues = [Regular.rawValue, Italic.rawValue, Bold.rawValue]
}

enum TextAlignment: String {
    case Left
    case Center
    case Right
    case Justified
    case Natural
    
    static let allValues = [Left.rawValue, Center.rawValue, Right.rawValue, Justified.rawValue, Natural.rawValue]
}

class TextOptions: NSObject, NSCopying, NSCoding {
    internal var text: String = "Sample"
    internal var typeFace: String = SystemFonts.Regular.rawValue
    internal var fontSize: Double = 14.0
    internal var textColor: String = "#000000"
    internal var kerning: Double = 0.0
    internal var alignment: TextAlignment = .Left
    internal var lineSpacing: Double = 0.0
    internal var paragraphSpacing: Double = 0.0
    
    required convenience init?(coder decoder: NSCoder) {
        guard let text = decoder.decodeObjectForKey("text") as? String,
            let typeFace = decoder.decodeObjectForKey("typeFace") as? String,
            let textColor = decoder.decodeObjectForKey("textColor") as? String
            else {
                return nil
        }
        
        self.init()
        
        self.text = text
        self.typeFace = typeFace
        self.fontSize = decoder.decodeDoubleForKey("fontSize")
        self.textColor = textColor
        self.kerning = decoder.decodeDoubleForKey("kerning")
        if let alignmentRaw = decoder.decodeObjectForKey("alignment") as? String {
            if let alignment = TextAlignment(rawValue: alignmentRaw) as TextAlignment? {
                self.alignment = alignment
            }
        }
        self.lineSpacing = decoder.decodeDoubleForKey("lineSpacing")
        self.paragraphSpacing = decoder.decodeDoubleForKey("paragraphSpacing")
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.text, forKey: "text")
        coder.encodeObject(self.typeFace, forKey: "typeFace")
        coder.encodeDouble(self.fontSize, forKey: "fontSize")
        coder.encodeObject(self.textColor, forKey: "textColor")
        coder.encodeDouble(self.kerning, forKey: "kerning")
        coder.encodeObject(self.alignment.rawValue, forKey: "alingment")
        coder.encodeDouble(self.lineSpacing, forKey: "lineSpacing")
        coder.encodeDouble(self.paragraphSpacing, forKey: "paragraphSpacing")
    }
    
    required override init() { }
    
    internal func attributedString() -> NSAttributedString {
        let font = TextOptions.fontForName(typeFace, size: CGFloat(fontSize))
        
        let textAlignment: NSTextAlignment
        switch alignment {
        case .Center:
            textAlignment = .Center
            
        case .Right:
            textAlignment = .Right
            
        case .Justified:
            textAlignment = .Justified
            
        case .Natural:
            textAlignment = .Natural
            
        default:
            textAlignment = .Left
        }

        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = CGFloat(lineSpacing)
        pStyle.paragraphSpacing = CGFloat(paragraphSpacing)
        pStyle.alignment = textAlignment
        
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor(hexString: textColor), NSKernAttributeName: kerning, NSParagraphStyleAttributeName: pStyle.copy()])
    }
    
    static internal func fontForName(name: String, size: CGFloat) -> (UIFont) {
        let font: UIFont
        
        if name == SystemFonts.Italic.rawValue {
            font = UIFont.italicSystemFontOfSize(size)
        }
        else if name == SystemFonts.Bold.rawValue {
            font = UIFont.boldSystemFontOfSize(size)
        }
        else if UIFont(name: name, size: size) != nil {
            font = UIFont(name: name, size: size)!
        }
        else {
            font = UIFont.systemFontOfSize(size)
        }
        
        return font
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = self.dynamicType.init()

        copy.typeFace = typeFace
        copy.fontSize = fontSize
        copy.textColor = textColor
        copy.kerning = kerning
        copy.text = text
        copy.alignment = alignment
        copy.lineSpacing = lineSpacing
        copy.paragraphSpacing = paragraphSpacing
        
        return copy
    }
}
