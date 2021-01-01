//
//  UserMapInfo.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 31/12/2020.
//

import Foundation

struct UserMapInfo: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
