//
//  UdaErrorResponse.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 29/12/2020.
//

import Foundation
struct UdaErrorResponse: Codable {
    let status: Int
    let error: String
}

extension UdaErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
