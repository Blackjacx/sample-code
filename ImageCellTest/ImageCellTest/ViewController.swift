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

        let urls: [URL] = [
            URL(string: "https://mcdn.wallpapersafari.com/medium/47/47/8b2sOV.jpg")!,
            URL(string: "https://s29843.pcdn.co/blog/wp-content/uploads/sites/2/2016/11/what-is-high-res-768x570.jpg")!,
            URL(string: "https://www.procyclinguk.com/wp-content/uploads/2015/04/2015PR.jpg")!,
            URL(string: "https://vastphotos.com/files/uploads/photos/10430/ocean-landscape-photo-print-xl.jpg")!
        ]
        let vc = ImageListViewController(urls)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

