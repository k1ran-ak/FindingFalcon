//
//  Vehilces.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import Foundation

import Foundation

// MARK: - Vehicle
struct Vehicle: Codable {
    let name: String
    let totalNo, maxDistance, speed: Int

    enum CodingKeys: String, CodingKey {
        case name
        case totalNo = "total_no"
        case maxDistance = "max_distance"
        case speed
    }
}

typealias Vehicles = [Vehicle]

