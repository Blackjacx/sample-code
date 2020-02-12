//
//  SearchCompleter.swift
//  SearchCompletionTest
//
//  Created by Stefan Herold on 17.10.17.
//  Copyright © 2017 CodingCobra. All rights reserved.
//

import MapKit
enum SuggestionType {
    case detail
    case suggestion
}

class SearchCompleter: NSObject, MKLocalSearchCompleterDelegate {

    private var searchCompletionHandler: (([SearchCompletionSuggestion]) -> Void)?
    private var localSearch: MKLocalSearch?
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchCompletionResults: [SearchCompletionSuggestion]? {
        didSet {
            guard let searchCompletionResults = searchCompletionResults else {return}
            searchCompletionHandler?(searchCompletionResults)
        }
    }

    override init() {
        super.init()
        searchCompleter.delegate = self
    }

    func query(_ query: String, region: MKCoordinateRegion, searchCompletionHandler: @escaping ([SearchCompletionSuggestion]) -> Void, localSearchCompletionHandler: @escaping ((MKLocalSearchResponse) -> Void)) {

        searchCompleter.cancel()
        localSearch?.cancel()

        if query.isEmpty { searchCompletionResults = [] }
        else { searchCompletionResults = nil }

        // Using MKLocalSearchCompleter - specialized in finding addresses
        self.searchCompletionHandler = searchCompletionHandler
        searchCompleter.region = region
        searchCompleter.filterType = .locationsOnly
        searchCompleter.queryFragment = ""
        searchCompleter.queryFragment = query

        // Using MKLocalSearch - specialized in finding POI's
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = region

        localSearch = MKLocalSearch(request: request)
        localSearch?.start { [weak self] (response, error) in
            guard let response = response else {return}
            self?.updateSearchCompletionResults(response.mapItems, type: .detail)
        }
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        updateSearchCompletionResults(completer.results, type: .suggestion)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    }

    private func updateSearchCompletionResults(_ update: [SearchCompletionSuggestion], type: SuggestionType) {
        let tmp = type == .detail ? update + (searchCompletionResults ?? []) : (searchCompletionResults ?? []) + update
        var results: [SearchCompletionSuggestion] = []

        for result in tmp {
            if !(results.contains { result.id.range(of: $0.id) != nil }) {
                results.append(result)
            }
        }
        searchCompletionResults = results
    }
}

protocol SearchCompletionSuggestion {
    var id: String {get}
    var title: String {get}
    var address: String {get}
}

extension MKLocalSearchCompletion: SearchCompletionSuggestion {
    var id: String {return address}
    var address: String {return subtitle}
}

extension MKMapItem: SearchCompletionSuggestion {
    var id: String { return placemark.localizedAddress(forceSingleLine: true, useState: false, useCountry: false, useZIP: true, useCity: false) }
    var title: String { return name ?? "" }
    var address: String { return placemark.localizedAddress(forceSingleLine: true, useState: false, useCountry: true, useZIP: true) }
}
