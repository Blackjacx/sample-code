//
//  ViewController.swift
//  WebSocketExample
//
//  Created by Stefan Herold on 12.06.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let task = URLSession.shared.webSocketTask(with: URL(string: "ws://demos.kaazing.com/echo")!)
        task.resume()

//        task.send(.string("Hello Socket!")) { (error) in
//            guard let   error = error else {
//                return
//            }
//            print(error)
//        }

        task.receive { (result) in
            print(result)
        }
    }
}

