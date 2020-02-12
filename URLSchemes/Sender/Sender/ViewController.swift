//
//  ViewController.swift
//  Sender
//
//  Created by Stefan Herold on 01.07.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import UIKit

enum ProcessingError: Error {
    case noPath
    case noData
    case urlConstructionError(Query)
    case cannotOpenUrl(URL)

}

class ViewController: UIViewController {

    private static let cellid = "cell"
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private var table = UITableView()

    private var titles: [String] = []
    private var urls: [URL] = []
    private var storeController: StoreKitController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Launcher"

        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)

        let constraints: [NSLayoutConstraint] = [
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)

        loadQueries()
    }

    private func loadQueries() {

        do {
            guard let path = Bundle.main.path(forResource: "Queries", ofType: "json") else {
                throw ProcessingError.noPath
            }

            guard let data = FileManager.default.contents(atPath: path) else {
                throw ProcessingError.noData
            }

            let queries = try type(of: self).decoder.decode([Query].self, from: data)

            titles = queries.map { $0.title }
            urls = queries.map { $0.url }
            table.reloadData()

        } catch {
            print("\(error)")
        }
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let url = urls[indexPath.row]

        guard UIApplication.shared.canOpenURL(url) else {
            storeController = StoreKitController()
            storeController?.displayStoreProductViewController(for: 1400408720, on: self) {
                // Here you can try again automatically or let the user open
                // our app again. But beware of make sure the app is really
                // installed here otherwise StoreKit opens again...
            }
            return
        }

        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            if !success {
                let alert = UIAlertController(title: "Info", message: "Launching the selected app failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }

    }
}

extension ViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let title = titles[indexPath.row]
        let url = urls[indexPath.row]
        let cell: UITableViewCell
        if let tmp = table.dequeueReusableCell(withIdentifier: type(of: self).cellid) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: type(of: self).cellid)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = .gray
        }
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = url.absoluteString
        return cell
    }
}
