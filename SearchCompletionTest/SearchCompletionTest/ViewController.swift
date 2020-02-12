//
//  ViewController.swift
//  SearchCompletionTest
//
//  Created by Stefan Herold on 17.10.17.
//  Copyright © 2017 CodingCobra. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let completer = SearchCompleter()
    let formatter = CNPostalAddressFormatter()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var results: [(title: String, subtitle: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = results[indexPath.row]

        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let center = CLLocationCoordinate2D(latitude: 50.10967, longitude: 8.6689301)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)

        completer.query(searchText, region: region, searchCompletionHandler: { [weak self] (results) in
            self?.results = results.map { ($0.title, $0.address) }
            self?.tableView.reloadData()

        }, localSearchCompletionHandler: { [weak self] (response) in
            self?.results = response.mapItems.map {
                let title = $0.placemark.name ?? ""
                var subtitle = ""
                if let address = $0.placemark.postalAddress {
                    subtitle = self?.formatter.string(from: address ) ?? ""
                }
                return (title, subtitle)
            }
            self?.tableView.reloadData()
        })
    }
}

