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

protocol NetworkManagerProtocol {
    //    func fetch<T: Decodable>(
    //        _ type: T.Type,
    //        fromUrl url: String,
    //        completion: @escaping (Result<T, NetworkError>) -> Void
    //    )
    //
    //    func fetchImage(
    //        fromUrl url: String,
    //        completion: @escaping (Result<Data, NetworkError>) -> Void
    //    )
    
    func fetch() async throws -> [Service]
    func fetchImage(fromUrl url: String) async throws -> Data
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    //    func fetch<T: Decodable>(
    //        _ type: T.Type,
    //        fromUrl url: String,
    //        completion: @escaping (Result<T, NetworkError>) -> Void
    //    ) {
    //        guard let url = URL(string: url) else {
    //            completion(.failure(.invalidUrl))
    //            return
    //        }
    //
    //        let shared = URLSession.shared
    //
    //        shared.dataTask(with: url) { data, response, error in
    //            if let error = error {
    //                print(error.localizedDescription)
    //                return
    //            }
    //
    //            guard let httpResponse = response as? HTTPURLResponse else {
    //                print("Ошибка: Некорректный HTTP-ответ")
    //                return
    //            }
    //
    //            guard (200...299).contains(httpResponse.statusCode) else {
    //                print("Ошибка: Некорректный HTTP-статус - \(httpResponse.statusCode)")
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(.noData))
    //                return
    //            }
    //
    //            do {
    //                let services = try JSONDecoder().decode(T.self, from: data)
    //
    //                DispatchQueue.main.async {
    //                    completion(.success(services))
    //                }
    //            } catch let error {
    //                completion(.failure(.decodingError))
    //                print(error.localizedDescription)
    //            }
    //
    //        }.resume()
    //    }
    
    //    func fetchImage(
    //        fromUrl url: String,
    //        completion: @escaping (Result<Data, NetworkError>) -> Void
    //    ) {
    //        guard let url = URL(string: url) else {
    //            completion(.failure(.invalidUrl))
    //            return
    //        }
    //
    //        DispatchQueue.global(qos: .background).async {
    //            guard let imageData = try? Data(contentsOf: url) else {
    //                completion(.failure(.noData))
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                completion(.success(imageData))
    //            }
    //        }
    //    }
    
    func fetch() async throws -> [Service] {
        guard let url = Bundle.main.url(forResource: "result", withExtension: "json") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            print("\(NetworkError.invalidResponse) - \(httpResponse.statusCode)")
            throw NetworkError.invalidResponse
        }
        
        let services: [Service]
        
        do {
            services = try JSONDecoder().decode([Service].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
        
        return services
    }
    
    func fetchImage(fromUrl url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl
        }
        
        let imageData: Data
        
        do {
            imageData = try Data(contentsOf: url)
        } catch {
            throw NetworkError.decodingError
        }
        
        return imageData
    }
}
