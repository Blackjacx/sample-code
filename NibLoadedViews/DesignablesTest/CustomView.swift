//
//  CustomView.swift
//  DesignablesTest
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 flinc. All rights reserved.
//

import UIKit

class CustomView: NibLoadedView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBInspectable var title: String = "" {
        didSet {
            if let proxy = proxyView as? CustomView {
                proxy.titleLabel.text = title
            }
            else {
                titleLabel.text = title
            }
        }
    }
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            if let proxy = self.proxyView as? CustomView {
//                proxy.layer.cornerRadius = cornerRadius
//                proxy.layer.masksToBounds = cornerRadius > 0
//            }
//            else {
//                layer.cornerRadius = cornerRadius
//                layer.masksToBounds = cornerRadius > 0
//            }
//        }
//    }
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            proxy().layer.borderWidth = borderWidth
//        }
//    }
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            proxy().layer.borderColor = borderColor?.CGColor
//        }
//    }
//    @IBInspectable var bgColor: UIColor? {
//        didSet {
//            if let proxy = self.proxyView as? CustomView {
//                proxy.backgroundColor = bgColor
//            }
//            else {
//                backgroundColor = bgColor
//            }
//        }
//    }
//
//    @IBInspectable var bgColor2: UIColor? {
//        get {
//            return backgroundColor
//        }
//        set {
//            proxy().backgroundColor = UIColor.greenColor()
//            backgroundColor = UIColor.greenColor()
//        }
//    }
}
