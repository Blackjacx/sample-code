//
//  ViewController.swift
//  ImageCellTest
//
//  Created by Stefan Herold on 12.02.20.
//  Copyright © 2020 stherold. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let urls = [
            URL(string: "https://images.app.goo.gl/c4zxGBHToW7LR9Gf9")!,
            URL(string: "https://images.app.goo.gl/9GaRZaHadSkZpPgB7")!,
            URL(string: "https://images.app.goo.gl/p8W1D8swoqv4LuQx6")!
        ]
        let vc = ImageListViewController(urls)
        present(vc, animated: true, completion: nil)
    }
}

