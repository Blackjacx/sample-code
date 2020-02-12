//
//  ViewController.swift
//  NFC_Example
//
//  Created by Stefan Herold on 11.06.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    private let stack = UIStackView()
    private let messageLabel = UILabel()
    private let scanNDEFButton = UIButton(type: .system)
    private let scanNFCTagButton = UIButton(type: .system)
    private let scanNFCVasButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)

    let queue = DispatchQueue(label: "NFC Queue", qos: .default)

    override func viewDidLoad() {
        super.viewDidLoad()

        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        messageLabel.text = "Welcome..."
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        stack.addArrangedSubview(messageLabel)

        scanNDEFButton.setTitle("Launch NFCNDEFReaderSession", for: .normal)
        scanNDEFButton.addTarget(self, action: #selector(onScanNDEF(_:)), for: .touchUpInside)
        stack.addArrangedSubview(scanNDEFButton)

        scanNFCTagButton.setTitle("Launch NFCTagReaderSession", for: .normal)
        scanNFCTagButton.addTarget(self, action: #selector(onScanNFCTag(_:)), for: .touchUpInside)
        stack.addArrangedSubview(scanNFCTagButton)

        scanNFCVasButton.setTitle("Launch NFCVASReaderSession", for: .normal)
        scanNFCVasButton.addTarget(self, action: #selector(onScanNFCVAS(_:)), for: .touchUpInside)
        stack.addArrangedSubview(scanNFCVasButton)

        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(onClear(_:)), for: .touchUpInside)
        stack.addArrangedSubview(clearButton)

        var constraints: [NSLayoutConstraint] = [
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        stack.arrangedSubviews.forEach { (view) in
            guard view is UIButton else { return}
            constraints.append(view.heightAnchor.constraint(equalToConstant: 44))
        }
        NSLayoutConstraint.activate(constraints)
    }

    @objc func onScanNDEF(_ sender: UIButton) {
        let session = NFCNDEFReaderSession(delegate: self, queue: queue, invalidateAfterFirstRead: false)
        session.begin()
    }

    @objc func onScanNFCTag(_ sender: UIButton) {
        let session = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693, .iso18092], delegate: self, queue: queue)
        session?.begin()
    }

    @objc func onScanNFCVAS(_ sender: UIButton) {
//        let config = NFCVASCommandConfiguration(vasMode: .urlOnly, passTypeIdentifier: "dummy_id", url: URL(string: "https://www.google.com"))
//        let session = NFCVASReaderSession(vasCommandConfigurations: [config], delegate: self, queue: queue)
//        session.begin()
    }

    @objc func onClear(_ sender: UIButton) {
        messageLabel.text = "Welcome..."
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var msg: String = ""
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    guard messageLabel.text != nil else {
                        DispatchQueue.main.async {
                            msg = string
                        }
                        continue
                    }
                    DispatchQueue.main.async {
                        msg.append("\(string)\n")
                    }
                }
            }
        }
        messageLabel.text = msg
        print(msg)
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        DispatchQueue.main.async { [weak self] in
            let msg: String = "Did become active"
            self?.messageLabel.text = msg
            print(msg)
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            let msg: String = error.localizedDescription
            self?.messageLabel.text = msg
            print(msg)
        }
    }
}

extension ViewController: NFCTagReaderSessionDelegate {

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        DispatchQueue.main.async { [weak self] in
            let msg: String = "Tag session did become active"
            self?.messageLabel.text = msg
            print(msg)
        }
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            let msg = error.localizedDescription
            self?.messageLabel.text = msg
            print(msg)
        }
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        DispatchQueue.main.async { [weak self] in
            let msg = tags.map {
                switch $0 {
                case let .miFare(tag):
                    return tag.description
                case let .feliCa(tag):
                    return tag.description
                case let .iso7816(tag):
                    return tag.description
                case let .iso15693(tag):
                    return tag.description
                @unknown default:
                    return "Unknown Tag Found"
                }
            }.joined(separator: "\n")
            self?.messageLabel.text = msg
            print(msg)
        }
    }
}

//extension ViewController: NFCVASReaderSessionDelegate {
//
//    func readerSessionDidBecomeActive(_ session: NFCVASReaderSession) {
//        DispatchQueue.main.async { [weak self] in
//            let msg: String = "Tag session did become active"
//            self?.messageLabel.text = msg
//            print(msg)
//        }
//    }
//
//    func readerSession(_ session: NFCVASReaderSession, didReceive responses: [NFCVASResponse]) {
//        DispatchQueue.main.async { [weak self] in
//            let msg: String = responses.description
//            self?.messageLabel.text = msg
//            print(msg)
//        }
//    }
//
//    func readerSession(_ session: NFCVASReaderSession, didInvalidateWithError error: Error) {
//        DispatchQueue.main.async { [weak self] in
//            let msg: String = error.localizedDescription
//            self?.messageLabel.text = msg
//            print(msg)
//        }
//    }
//}
