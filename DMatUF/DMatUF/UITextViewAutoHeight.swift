//
//  TextViewAutoHeight.swift
//  TextViewAutoHeightDemo
//
//  Created by pc-laptp on 12/3/14.
//  Copyright (c) 2014 StreetCoding. All rights reserved.
//

import UIKit

class Foo: UILabel {

}

class UITextViewAutoHeight: UITextView {
    
    //MARK: attributes
    var  maxHeight:CGFloat?
    var  heightConstraint:NSLayoutConstraint?
   
    //MARK: initialize
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
    //MARK: private
    
    private func setup() {
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                self.heightConstraint = constraint as NSLayoutConstraint;
                break;
            }
        }
    }
    
    private func setupConstraint() {
        var finalContentSize:CGSize = self.contentSize
        finalContentSize.width  += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        finalContentSize.height += (self.textContainerInset.top  + self.textContainerInset.bottom) / 2.0
        
        fixTextViewHeigth(finalContentSize)
    }
    
    private func fixTextViewHeigth(finalContentSize:CGSize) {
        if let maxHeight = self.maxHeight {
            var  customContentSize = finalContentSize;
            
            customContentSize.height = min(customContentSize.height, CGFloat(maxHeight))
            
            self.heightConstraint?.constant = customContentSize.height;
            
            if finalContentSize.height <= CGRectGetHeight(self.frame) {
                let textViewHeight = (CGRectGetHeight(self.frame) - self.contentSize.height * self.zoomScale)/2.0
                
                self.contentOffset = CGPointMake(0, -(textViewHeight < 0.0 ? 0.0 : textViewHeight))
                
            }
        }
    }
}