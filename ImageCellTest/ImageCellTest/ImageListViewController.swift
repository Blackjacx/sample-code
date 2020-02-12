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
    private var cellHeightCache: [IndexPath : CGFloat] = [:]

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
        setupTable()
        setupAutoLayout()
    }

    private func setupTable() {
        table.dataSource = self
        table.delegate = self
        table.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseID)
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
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
        imgCell.configure(url, didConfigure: { [weak self] preferredCellHeight in
            if self?.cellHeightCache[indexPath] != preferredCellHeight {
                self?.cellHeightCache[indexPath] = preferredCellHeight
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        })
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightCache[indexPath] ?? 0
    }
}

extension ImageListViewController: UITableViewDelegate {

}

final class ImageCell: UITableViewCell {

    static let reuseID = "img_cell"
    static let paddingV: CGFloat = 25
    static let paddingH: CGFloat = 50

    private lazy var imgView: UIImageView! = UIImageView()

    private var imgViewHeight: NSLayoutConstraint!

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

        if imgView.superview == nil {
            imgView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(imgView)
        }
    }

    private func setupAutoLayout() {

        let constraints: [NSLayoutConstraint] = [
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.paddingH),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.paddingH),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.paddingV),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.paddingV)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(_ url: URL, didConfigure: @escaping (_ preferredCellHeight: CGFloat) -> ()) {

        imgView.setImage(from: url, didSetImage: { [weak self] img in
            guard let self = self, let img = img else {
                didConfigure(Self.paddingH)
                return
            }
            let imgAspect = img.size.width / img.size.height
            let imgViewWidth = self.contentView.frame.width - 2 * Self.paddingH
            let imgViewHeight = imgViewWidth / imgAspect
            print("(\(imgViewWidth), \(imgViewHeight), \(imgAspect))")
            self.imgView.image = img
            didConfigure(imgViewHeight + 2 * Self.paddingV)
        })
    }
}
