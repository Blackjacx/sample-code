//
//  UIImageView+Networking.swift
//  ImageCellTest
//
//  Created by Stefan Herold on 12.02.20.
//  Copyright © 2020 stherold. All rights reserved.
//

import UIKit


extension UIImageView {

    private static var cache: [URL: UIImage] = [:]
    private static var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()

    func setImage(from url: URL?, placeholder: UIImage? = nil, session: URLSession? = nil) {

        // Update session
        if let session = session {
            UIImageView.session = session
        }

        // Try to find cached image
        if let url = url, let cachedImage = UIImageView.cache[url] {
            self.image = cachedImage
            return
        }

        // Set placeholder image to bridge loading
        if let placeholder = placeholder {
            self.image = placeholder
        }

        // Load new image from backend
        guard let url = url else { return }

        UIImageView.session.dataTask(with: url) { [weak self] (data, _, _) in

            guard let data = data else { return }

            DispatchQueue.main.async {

                guard let image = UIImage(data: data) else { return }
                UIImageView.cache[url] = image
                self?.image = image
            }
        }.resume()
    }
}
