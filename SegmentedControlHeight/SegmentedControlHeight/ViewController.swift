//
//  ViewController.swift
//  SegmentedControlHeight
//
//  Created by Stefan Herold on 08.04.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewRespectsSystemMinimumLayoutMargins = false
        view.directionalLayoutMargins = .zero

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20

        stack.addArrangedSubview(createSegmentedControl(height: 30))
        stack.addArrangedSubview(createSegmentedControl(height: 50))

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ]
        )
    }

    func createSegmentedControl(height: CGFloat) -> UISegmentedControl {

        let control = UISegmentedControl()
        control.backgroundColor = .red

        control.insertSegment(withTitle: "Active", at: 0, animated: false)
        control.insertSegment(withTitle: "Finished", at: 1, animated: false)

//        NSLayoutConstraint.activate([
//            control.heightAnchor.constraint(equalToConstant: height),
//            ]
//        )
        return control
    }


}

