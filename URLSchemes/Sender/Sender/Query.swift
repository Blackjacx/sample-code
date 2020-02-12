//
//  Query.swift
//  Sender
//
//  Created by Stefan Herold on 17.07.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import Foundation
import CoreLocation

struct Query: Codable {
    let title: String
    let scheme: String
    let path: String
    let params: QueryParams

    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.path = path
        components.queryItems = params.queryItems
        return components.url!
    }
}

struct QueryParams: Codable {
    let originLat: CLLocationDegrees
    let originLng: CLLocationDegrees
    let destinationLat: CLLocationDegrees
    let destinationLng: CLLocationDegrees
    let departureTime: String?
    let arrivalTime: String?

    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "origin_lat", value: "\(originLat)"),
            URLQueryItem(name: "origin_lng", value: "\(originLng)"),
            URLQueryItem(name: "destination_lat", value: "\(destinationLat)"),
            URLQueryItem(name: "destination_lng", value: "\(destinationLng)"),
            departureTime.map { URLQueryItem(name: "departure_time", value: $0) },
            arrivalTime.map { URLQueryItem(name: "arrival_time", value: $0) }
            ].compactMap { $0 }
    }
}
