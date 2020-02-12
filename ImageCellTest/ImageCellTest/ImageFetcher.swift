//
//  ImageFetcher.swift
//  ImageCellTest
//
//  Created by Stefan Herold on 12.02.20.
//  Copyright © 2020 stherold. All rights reserved.
//

import UIKit

struct ImageFetcher {

    private static var cache: [URL: UIImage] = [:]
    private static var session: URLSessionProtocol = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()

    static func fetch(from url: URL?, placeholder: UIImage? = nil, session: URLSessionProtocol? = nil, didFetchImage: @escaping (UIImage)->()) {

        // Update session
        if let session = session {
            Self.session = session
        }

        // Try to find cached image
        if let url = url, let cachedImage = Self.cache[url] {
            didFetchImage(cachedImage)
            return
        }

        // Load new image from backend
        guard let url = url else { return }

        Self.session.dataTask(with: url) { (data, _, _) in

            guard let data = data else { return }

            DispatchQueue.main.async {

                guard let image = UIImage(data: data) else { return }
                Self.cache[url] = image
                didFetchImage(image)
            }
        }.resume()
    }
}

extension URLSession: URLSessionProtocol {}
