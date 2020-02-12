//
//  ViewController.swift
//  AnimatedButton
//
//  Created by Stefan Herold on 15.06.18.
//  Copyright © 2018 CodingCobra. All rights reserved.
//

import UIKit

final class CustomButton: UIButton {

    private let backgroundLayer = CALayer()
    private let highlightedBackgroundLayer = CALayer()
    private let expirationLayer = CALayer()
    private var sliderPercentage: CGFloat = 0

    override var isHighlighted: Bool {
        didSet { updateLayer() }
    }

    override var isEnabled: Bool {
        didSet { updateLayer() }
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        layer.cornerRadius = frame.height / 4.0
        layer.masksToBounds = true

        backgroundLayer.backgroundColor = UIColor(red: 1.0 / 255.0, green: 192.0 / 255.0, blue: 1.0, alpha: 1.0).cgColor
        layer.insertSublayer(backgroundLayer, at: 0)

        highlightedBackgroundLayer.backgroundColor = UIColor(red: 1.0 / 255.0, green: 192.0 / 255.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.75).cgColor
        layer.insertSublayer(highlightedBackgroundLayer, above: backgroundLayer)

        expirationLayer.backgroundColor = UIColor.black.withAlphaComponent(0.25).cgColor
        layer.insertSublayer(expirationLayer, above: backgroundLayer)
    }

    @IBAction func sliderChanged(_ sender: UISlider) {

        sliderPercentage = CGFloat(sender.value)
        setNeedsLayout()
        layoutIfNeeded()
    }

    override func layoutSubviews() {

        backgroundLayer.frame = bounds
        highlightedBackgroundLayer.frame = bounds

        var expirationBounds = bounds
        expirationBounds.size.width = bounds.width * CGFloat(1 - sliderPercentage)
        expirationLayer.frame = expirationBounds

        expirationLayer.isHidden = sliderPercentage == 0 || sliderPercentage == 1

        super.layoutSubviews()
    }

    private func updateLayer() {

        backgroundLayer.isHidden = isHighlighted || isSelected || !isEnabled

        highlightedBackgroundLayer.isHidden = !isHighlighted
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        button.setBackgroundImage(#imageLiteral(resourceName: "buttonBG"), for: .normal)

    }
}

