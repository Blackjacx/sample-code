//
//  ViewController.swift
//  StackViewExample
//
//  Created by Stefan Herold on 20.06.17.
//  Copyright © 2017 DRIVE. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func unwindAction(segue: UIStoryboardSegue) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // hide menu button
        pressedMenuButton(menuButton)
    }

    @IBAction func pressedMenuButton(_ sender: Any) {

        UIView.animate(withDuration: 0.25) {
            self.buttons.forEach { (button) in
                button.isHidden = !button.isHidden
            }
        }
    }
}

