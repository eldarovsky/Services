//
//  ServicesViewController.swift
//  ViewControllers
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit

// MARK: - Services ViewController

/// Class of list of services
final class ServicesViewController: UITableViewController {

    // MARK: Private Properties
    private let networkManager = NetworkManager.shared
    private var services: [Service] = []

    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchServices()
    }

    // MARK: Private Methods
    
    /// Fetch services information method
    private func fetchServices() {
        guard let url = Bundle.main.url(forResource: Text.resourceName, withExtension: Text.resourceExtension) else { return }

        networkManager.fetchServices(fromUrl: url) { [weak self] result in
            switch result {
            case .success(let services):
                self?.services = services
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// Pull to refresh method
    @objc private func reloadData() {
        fetchServices()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Setup UI Methods

private extension ServicesViewController {

    /// Setup views methods
    func setupViews() {
        setupView()
        setupNavigationBar()
        setupTableView()
    }
}

private extension ServicesViewController {

    /// Setup view appearance method
    func setupView() {
        title = Text.title
    }

    /// Setup navigation bar appearance method
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }

    /// Setup table view appearance method
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Text.cellIdentifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
        refreshControl.backgroundColor = .black

        let attributedTitle = NSAttributedString(
            string: Text.refreshTitle,
            attributes: [.foregroundColor: UIColor.gray]
        )

        refreshControl.attributedTitle = attributedTitle

        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - TableView Data Source

extension ServicesViewController {

    /// Setup number of rows in section method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count
    }

    /// Setup cell appearance and functionality method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Text.cellIdentifier, for: indexPath)
        cell.backgroundColor = .black
        cell.accessoryType = .disclosureIndicator

        var content = cell.defaultContentConfiguration()

        let service = services[indexPath.row]
        let imageURL = service.iconURL

        networkManager.fetchImage(fromUrl: imageURL) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }

                DispatchQueue.main.async {
                    content.image = image
                    content.text = service.name
                    content.secondaryText = service.description

                    cell.contentConfiguration = content
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        return cell
    }
}

// MARK: - TableView Delegate

extension ServicesViewController {

    /// Selected cell action method. Includes visual cell deselection and transition logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let url = services[indexPath.row].link

        if let targetUrl = URL(string: url), UIApplication.shared.canOpenURL(targetUrl) {
            UIApplication.shared.open(targetUrl)
        } else {
            if let targetUrl = URL(string: url) {
                UIApplication.shared.open(targetUrl)
            }
        }
    }

    /// Provide cell height method
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    /// Cell animation method
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}

// MARK: - Constants

/// Text constants
private enum Text {

    /// Screen title
    static let title = "Сервисы"

    /// Pull to refresh text
    static let refreshTitle = "Обновление данных"

    /// Resource file name
    static let resourceName = "result"

    /// Resource file extension
    static let resourceExtension = "json"

    /// Table view cell identifier
    static let cellIdentifier = "cell"
}
