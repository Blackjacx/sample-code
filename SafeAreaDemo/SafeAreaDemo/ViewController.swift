//
//  ViewController.swift
//  SafeAreaDemo
//
//  Created by Stefan Herold on 23.01.20.
//  Copyright © 2020 stherold. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static let size: CGFloat = 50

    let redView = UIView()
    let topLine = UIView()
    let bottomLine = UIView()
    let leadingLine = UIView()
    let trailingLine = UIView()
    let greenView = UIView()
    lazy var redViewBottom = redView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0)
    var animator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewRespectsSystemMinimumLayoutMargins = false
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        var constraints: [NSLayoutConstraint] = []
        constraints += setupRedView()
        constraints += setupGreenView()
        constraints += setupBottomSafeAreaGuide()
        constraints += setupTopSafeAreaGuide()
        constraints += setupLeadingSafeAreaGuide()
        constraints += setupTrailingSafeAreaGuide()
        NSLayoutConstraint.activate(constraints)

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        animate()
    }

    private func setupBottomSafeAreaGuide() -> [NSLayoutConstraint] {
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = .black
        view.addSubview(bottomLine)

        return [
            bottomLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomLine.topAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
        ]
    }

    private func setupTopSafeAreaGuide() -> [NSLayoutConstraint] {
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.backgroundColor = .black
        view.addSubview(topLine)

        return [
            topLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLine.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1),
        ]
    }

    private func setupLeadingSafeAreaGuide() -> [NSLayoutConstraint] {
        leadingLine.translatesAutoresizingMaskIntoConstraints = false
        leadingLine.backgroundColor = .black
        view.addSubview(leadingLine)

        return [
            leadingLine.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            leadingLine.topAnchor.constraint(equalTo: view.topAnchor),
            leadingLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingLine.widthAnchor.constraint(equalToConstant: 1),
        ]
    }

    private func setupTrailingSafeAreaGuide() -> [NSLayoutConstraint] {
        trailingLine.translatesAutoresizingMaskIntoConstraints = false
        trailingLine.backgroundColor = .black
        view.addSubview(trailingLine)

        return [
            trailingLine.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            trailingLine.topAnchor.constraint(equalTo: view.topAnchor),
            trailingLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailingLine.widthAnchor.constraint(equalToConstant: 1),
        ]
    }

    private func setupGreenView() -> [NSLayoutConstraint] {
        greenView.translatesAutoresizingMaskIntoConstraints = false
        greenView.backgroundColor = .green
        redView.addSubview(greenView)

        return [
            greenView.leadingAnchor.constraint(equalTo: redView.layoutMarginsGuide.leadingAnchor),
            greenView.trailingAnchor.constraint(equalTo: redView.layoutMarginsGuide.trailingAnchor),
            greenView.topAnchor.constraint(equalTo: redView.layoutMarginsGuide.topAnchor),
            greenView.bottomAnchor.constraint(equalTo: redView.layoutMarginsGuide.bottomAnchor)
        ]
    }

    func setupRedView() -> [NSLayoutConstraint] {

        redView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redView)

        return [
            redView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: Self.size),
            redView.widthAnchor.constraint(equalToConstant: 300),
            redView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            redViewBottom
        ]
    }

    func animate() {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        redViewBottom.constant = redViewBottom.constant == 0 ? -300 : 0

        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2, delay: 0, options: [], animations: {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
        animator.addCompletion { (state) in
            self.animate()
        }
    }


}

