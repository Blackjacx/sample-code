//
//  UIImageView+Extensions.swift
//  ImageCellTest
//
//  Created by Stefan Herold on 12.02.20.
//  Copyright © 2020 stherold. All rights reserved.
//

import UIKit

extension UIImageView {

    private static var cache: [URL: UIImage] = [:]
    private static var session: URLSessionProtocol = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()

    func setImage(from url: URL?, placeholder: UIImage? = nil, session: URLSessionProtocol? = nil, didSetImage: @escaping (UIImage?)->()) {

        // Update session
        if let session = session {
            Self.session = session
        }

        // Try to find cached image
        if let url = url, let cachedImage = Self.cache[url] {
            self.image = cachedImage
            didSetImage(cachedImage)
            return
        }

        // Set image to placeholder or nil and report that change
        self.image = placeholder
        didSetImage(placeholder)

        // Load new image from backend
        guard let url = url else { return }

        Self.session.dataTask(with: url) { (data, _, _) in

            guard let data = data else { return }

            DispatchQueue.main.async {

                guard let image = UIImage(data: data) else { return }
                Self.cache[url] = image
                self.image = image
                didSetImage(image)
            }
        }.resume()
    }
}

extension URLSession: URLSessionProtocol {}
