//
//  Models.swift
//  Services
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//

// MARK: - Services
struct MainBody: Decodable {
    let body: Body
    let status: Int
}

// MARK: - Body
struct Body: Decodable {
    let services: [Service]
}

// MARK: - Service
struct Service: Decodable {
    let name: String
    let description: String
    let link: String
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case name, description, link
        case iconURL = "icon_url"
    }
}
