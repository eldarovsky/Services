//
//  Models.swift
//  Model
//
//  Created by Эльдар Абдуллин on 26.03.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

// MARK: - MainBody Model

/// Main model that stores information about all services and HTTP-status code
struct MainBody: Decodable {
    
    /// Information about all services
    let body: Body
    
    /// HTTP-status code
    let status: Int
}

// MARK: - Body Model

/// Model that stores array of all services
struct Body: Decodable {
    
    /// Array of cervices
    let services: [Service]
}

// MARK: - Service Model

/// Model that stores all information about particular service
struct Service: Decodable {
    
    /// Name of service
    let name: String
    
    /// Description of service
    let description: String
    
    /// HTTP-address of service
    let link: String
    
    /// Icon of service
    let iconURL: String
    
    /// CodingKeys for properties
    enum CodingKeys: String, CodingKey {
        case name, description, link
        case iconURL = "icon_url"
    }
}
