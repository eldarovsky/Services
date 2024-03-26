//
//  NetworkManager.swift
//  Business Logic
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import Foundation

// MARK: - Network Error Types

/// Network Error Types
enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
}

// MARK: - Network Manager

/// Class that helps to fetch service information and icon
final class NetworkManager {

    // MARK: Public Properties

    /// Access point to Network Manager
    static let shared = NetworkManager()

    // MARK: Private Properties

    /// URL session
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()

    // MARK: Initializers

    /// Singleton pattern initializer
    private init() {}

    // MARK: Public Methods

    /// Method to fetch info about service
    func fetchServices(
        fromUrl url: URL,
        completion: @escaping (Result<[Service], NetworkError>) -> Void
    ) {
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let mainBody = try JSONDecoder().decode(MainBody.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(mainBody.body.services))
                }
            } catch let error {
                completion(.failure(.decodingError))
                print(error.localizedDescription)
            }

        }.resume()
    }

    /// Method to fetch icon of service
    func fetchImage(
        fromUrl url: String,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.noData))
                print(error.localizedDescription)
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))

        }.resume()
    }
}
