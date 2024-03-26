//
//  Models.swift
//  Services
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//

struct ServiceList: Decodable {
    let services: [Service]
}

struct Service: Decodable {
    let name: String
    let description: String
    let link: String
    let icon_url: String
}
