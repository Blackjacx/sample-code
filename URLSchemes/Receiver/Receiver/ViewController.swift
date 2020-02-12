//
//  ViewController.swift
//  Receiver
//
//  Created by Stefan Herold on 01.07.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let message = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        message.translatesAutoresizingMaskIntoConstraints = false
        message.numberOfLines = 0
        message.text = "Hello Deep Link..."
        view.addSubview(message)

        let constraints: [NSLayoutConstraint] = [
            message.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            message.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            message.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            message.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(with message: String) {
        self.message.text = message
    }
}

