//
//  ServicesViewController.swift
//  Services
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//

import UIKit

final class ServicesViewController: UITableViewController {

    private let networkManager = NetworkManager.shared

    private var services: [Service] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetch()
    }

    private func fetch() {
        guard let url = Bundle.main.url(forResource: "result", withExtension: "json") else { return }

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
}

private extension ServicesViewController {
    func setupView() {
        title = "Сервисы"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.backgroundColor = .black
    }
}

// MARK: - TableView Data Source
extension ServicesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black
        cell.accessoryType = .disclosureIndicator

        var content = cell.defaultContentConfiguration()

        let service = services[indexPath.row]
        let imageURL = service.iconURL

        networkManager.fetchImage(fromUrl: imageURL) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    guard let image = UIImage(data: imageData) else { return }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
