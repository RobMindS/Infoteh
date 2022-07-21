//
//  СityListModel.swift
//  Infoteh
//
//  Created by admin on 19.07.2022.
//

import Foundation

struct СityModel: Decodable {
    
    var id: Int = 0
    var name: String = ""
    var state: String = ""
    var country: String = ""
    var coord: Сoordinates
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case state = "state"
        case country = "country"
        case coord = "coord"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coord = try container.decode(Сoordinates.self, forKey: .coord)
    }
}

struct Сoordinates: Decodable {
    
    var lon: Double = 0.0
    var lat: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
    }
}
