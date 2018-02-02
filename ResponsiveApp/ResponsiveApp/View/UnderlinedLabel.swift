//
//  UnderlinedLabel.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 2.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit

class UnderlinedLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        underlineLabel()
    }
    
    override var text: String? {
        didSet {
           underlineLabel()
        }
    }
    
    private func underlineLabel() {
        guard let text = text else { return }
        let textRange = NSMakeRange(0, text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        self.attributedText = attributedText
    }
}
