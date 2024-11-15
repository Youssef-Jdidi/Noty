//
//  NotifCell.swift
//  Noty
//
//  Created by Youssef Jdidi on 10/4/2021.
//

import UIKit

class NotifCell: UICollectionViewCell {

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint! {
        didSet {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userDidTap)))
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(resource: R.nib.songCell),
            forCellReuseIdentifier: R.reuseIdentifier.songCell.identifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {}

    @objc func userDidTap() {
        self.tableViewHeight.constant == 0 ?
            show() : hide()
    }

    // MARK: Private Methods
    private func show() {
        let height = CGFloat(44 * 5)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.tableViewHeight.constant = height
            }, completion: nil)
    }
    private func hide() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
            self?.tableViewHeight.constant = 0
        }, completion: nil)
    }
}

extension NotifCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.songCell.identifier, for: indexPath) as? SongCell else { return UITableViewCell() }
        return cell
    }
}
