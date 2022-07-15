//
//  Planets.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import Foundation

import Foundation

// MARK: - Planet
struct Planet: Codable {
    let name: String
    let distance: Int
}

typealias Planets = [Planet]
