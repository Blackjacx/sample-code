//
//  TestView.swift
//  DesignablesTest
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 flinc. All rights reserved.
//

import UIKit

/*
 * References
 *
 * http://justabeech.com/2014/07/27/xcode-6-live-rendering-from-nib/
 * http://nshipster.com/ibinspectable-ibdesignable/
 * https://github.com/edelabar/AutoLayoutTester/blob/master/UI/NibLoadedView.swift
 */

@IBDesignable class NibLoadedView: UIView {
    var proxyView: NibLoadedView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if (subviews.count == 0) {
            if let view = loadNib() {
                view.frame = self.bounds
                self.proxyView = view
                self.addSubview(view)
                self.setNeedsLayout()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if (self.subviews.count == 0) {
            if let view = loadNib() {
                view.translatesAutoresizingMaskIntoConstraints = false
                view.proxyView = view
                return view
            }
        }
        return self
    }
    
    private func loadNib() -> NibLoadedView? {
        let classType = self.dynamicType
        let packageAndNibName = nameOfClass(classType)
        let nibName = packageAndNibName.componentsSeparatedByString(".").last
        let elements = NSBundle(forClass: classType).loadNibNamed(nibName, owner: nil, options: nil)
        
        for anObject in elements {
            if (anObject.isKindOfClass(self.dynamicType)) {
                return anObject as? NibLoadedView;
            }
        }
        return nil
    }
}
