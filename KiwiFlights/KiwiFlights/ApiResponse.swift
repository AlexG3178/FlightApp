//
//  ApiResponse.swift
//  KiwiFlights
//
//  Created by Alexandr Grigoriev on 20.08.2022.
//

import Foundation

struct Result: Codable, Hashable {
    
    var currency: String
    var data: [FlightData]
}

struct FlightData: Codable, Hashable {
    
    var id: String
    var flyFrom: String
    var flyTo: String
    var cityFrom: String
    var cityCodeFrom: String
    var cityTo: String
    var cityCodeTo: String
    var countryFrom: CountryFrom
    var countryTo: CountryTo
    var price: Int
    var route: [Route]
}

struct CountryFrom: Codable, Hashable {
    
    var code: String
    var name: String
}

struct CountryTo: Codable, Hashable {
    
    var code: String
    var name: String
}

struct Route: Codable, Hashable {
    var local_departure: String
}

