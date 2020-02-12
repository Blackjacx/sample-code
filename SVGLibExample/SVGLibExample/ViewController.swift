//
//  ViewController.swift
//  SVGLibExample
//
//  Created by Stefan Herold on 01/12/2016.
//  Copyright © 2016 stefanherold. All rights reserved.
//

import UIKit
import Macaw

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let macawViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SVGExampleViewController")
        self.present(macawViewController, animated: true, completion: nil)
    }
}
