//
//  LocationProtocol.swift
//  Beiwagen
//
//  Created by Stefan Herold on 26.04.17.
//  Copyright © 2017 DRIVE. All rights reserved.
//

import Foundation
import MapKit
import Contacts

public protocol LocationProtocol {

    var locationTitle: String { get }
    var street: String { get }
    var streetNumber: String { get }
    var zipCode: String { get }
    var city: String { get }
    var state: String { get }
    var countryName: String { get }
    var coordinate: CLLocationCoordinate2D { get }

    func localizedAddress(forceSingleLine: Bool, useState: Bool, useCountry: Bool, useZIP: Bool, useCity: Bool) -> String
}

extension LocationProtocol {

    var streetIncludingNumber: String {

        guard !street.isEmpty else {
            return ""
        }
        guard !streetNumber.isEmpty else {
            return street
        }
        return "\(street) \(streetNumber)"
    }

    var asMapItem: MKMapItem {

        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
    }

    public func localizedAddress(
        forceSingleLine: Bool = true,
        useState: Bool = false,
        useCountry: Bool = false,
        useZIP: Bool = false,
        useCity: Bool = true) -> String {

        let address = CNMutablePostalAddress()
        address.street = streetIncludingNumber

        if useCity {
            address.city = city
        }

        if useState {
            address.state = state
        }

        if useCountry {
            address.country = countryName
        }

        if useZIP {
            address.postalCode = zipCode
        }

        let addressString = CNPostalAddressFormatter.string(from: address, style: .mailingAddress)
        var result: String = addressString

        if forceSingleLine {
            let components: [String] = addressString.components(separatedBy: .newlines).flatMap {
                let trimmed = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed.isEmpty ? nil : trimmed
            }
            result = components.joined(separator: ", ")
        }

        return result
    }
}

// MARK: - Useful String Extensions

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }

    var utf8Encoded: Data {
        return data(using: .utf8) ?? Data()
    }

    subscript (i: Int) -> Character {
        return self[index(self.startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    /// Used to parse the phone number and the dialing code to remove invalid characters. Only digits are allowed.
    /// - parameter numberOrDialingCode: Any String where invalid characters are removed from
    /// - returns: A String that is never nil but maybe empty
    static func stripAllButDigits(fromText text: String?) -> String {
        // Trim any non digits
        let nonDigitsCharset = CharacterSet.decimalDigits.inverted
        let components = text?.components(separatedBy: nonDigitsCharset )
        let strippedText = components?.joined()
        return strippedText ?? ""
    }

    /// Trims new lines and whitespaces from a given text
    ///
    /// - Parameter text: The input string that should be trimmed
    /// - Returns: The trimmed input string or an empty string if the input string is nil
    static func trim(_ text: String?) -> String {
        return (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - CLPlacemark

extension CLPlacemark: LocationProtocol {

    public var coordinate: CLLocationCoordinate2D { return location?.coordinate ?? kCLLocationCoordinate2DInvalid }

    public var countryName: String { return String.trim(country) }
    public var locationTitle: String { return String.trim(name) }
    public var city: String { return String.trim(locality) }
    public var state: String { return String.trim(administrativeArea) }
    public var street: String { return String.trim(thoroughfare) }
    public var streetNumber: String { return String.trim(subThoroughfare) }
    public var zipCode: String { return String.trim(postalCode) }
}

// MARK: - Location Protocol Generation

/// Generates an object that conforms to `LocationProtocol` from a coordinate and an optional address dictionary
///
/// - Parameters:
///   - coordinate: The `CLLocationCoordinate2D` to initialize the `LocationProtocol`
///   - addressDictionary: The dictionary containing address coponents like street, city, etc. to initialize the `LocationProtocol`
/// - Returns: An object that conforms to `LocationProtocol`
public func locationProtocolFrom(coordinate: CLLocationCoordinate2D, addressDictionary: [String: Any]? = nil) -> LocationProtocol {

    return MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
}

/// Generates an object that conforms to `LocationProtocol` from an Apple CLPlacemark
///
/// - Parameter placemark: The placemark that should be converted to an object conforming to `LocationProtocol`
/// - Parameter coord: The coordinate that should be used instead of the coordinate of the placemark
/// - Returns: An object that conforms to the `LocationProtocol`
public func locationProtocolFrom(placemark: CLPlacemark, coord: CLLocationCoordinate2D? = nil) -> LocationProtocol {

    let coordinate = coord ?? placemark.coordinate
    let addressDictionary: [String: Any]? = placemark.addressDictionary as? [String: Any]
    return locationProtocolFrom(coordinate: coordinate, addressDictionary: addressDictionary)
}
