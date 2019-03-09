//
//  NSAttributedString+Extensions.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    convenience init(string: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment = NSTextAlignment.left, lineSpacing: CGFloat = 0) {
        let attributes = NSAttributedString.attributesFor(font: font, textColor: textColor, textAlignment: textAlignment, lineSpacing: lineSpacing)
        self.init(string: string, attributes: attributes)
    }
    
    func heightInWidth(_ width: CGFloat) -> CGFloat {
        return boundingRect(with: CGSize(width: width, height: CGFloat.infinity), options: [NSStringDrawingOptions.usesFontLeading, NSStringDrawingOptions.usesLineFragmentOrigin], context: nil).size.height
    }
    
    func widthInHeight(_ height: CGFloat) -> CGFloat {
        return boundingRect(with: CGSize(width: CGFloat.infinity, height: height), options: NSStringDrawingOptions.usesFontLeading, context: nil).size.width
    }
    
    class func attributesFor(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment = NSTextAlignment.left, lineSpacing: CGFloat = 0) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.lineSpacing = lineSpacing
        return [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
    }
}
