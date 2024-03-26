//
//  NetworkManager.swift
//  Services
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//

import Foundation

enum NetworkError: String, Error {
    case invalidUrl = "Ошибка: Некорректный URL-адрес"
    case noData = "Ошибка: Нет данных"
    case decodingError = "Ошибка: Ошибка декодирования"
    case invalidResponse = "Ошибка: Некорректный HTTP-ответ"
}

final class NetworkManager {
    // MARK: - TEST version

    static let shared = NetworkManager()
    private init() {}

    func fetchServices(
        fromUrl url: URL,
        completion: @escaping (Result<[Service], NetworkError>) -> Void
    ) {

        let shared = URLSession.shared

        shared.dataTask(with: url) { data, _, error in
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

    func fetchImage(
        fromUrl url: String,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }

        let shared = URLSession.shared

        shared.dataTask(with: url) { data, _, error in
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
