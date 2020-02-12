//
//  ImageListViewController.swift
//  ImageCellTest
//
//  Created by Stefan Herold on 12.02.20.
//  Copyright © 2020 stherold. All rights reserved.
//

import UIKit

final class ImageListViewController: UIViewController {

    private let imgURLs: [URL]

    private let table = UITableView()

    init(_ urls: [URL]) {
        self.imgURLs = urls
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.imgURLs = []
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        table.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseID)
        view.addSubview(table)

        setupAutoLayout()
    }

    private func setupAutoLayout() {

        let padding: CGFloat = 0
        let constraints: [NSLayoutConstraint] = [
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ImageListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imgURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseID, for: indexPath)

        guard let imgCell = cell as? ImageCell else {
            return cell
        }

        let url = imgURLs[indexPath.row]
        imgCell.configure(url)
        return cell
    }


}

extension ImageListViewController: UITableViewDelegate {

}

final class ImageCell: UITableViewCell {

    static let reuseID = "img_cell"

    private let imgView = UIImageView()

    // MARK: - Initalization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        setupImgView()
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        backgroundColor = .systemBackground
        setupImgView()
        setupAutoLayout()
    }

    private func setupImgView() {

        imgView.backgroundColor = .systemBackground
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .label
        imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgView)
    }

    private func setupAutoLayout() {

        let padding: CGFloat = 10
        let constraints: [NSLayoutConstraint] = [
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(_ url: URL) {

        imgView.setImage(from: url)
    }
}
