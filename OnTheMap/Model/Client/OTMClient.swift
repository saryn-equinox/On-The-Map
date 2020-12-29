//
//  OTMClient.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 27/12/2020.
//

import Foundation


class OTMClient {
    
    struct Auth {
        static var userId: String = ""
        static var sessionId: String = ""
    }
    
    enum Endpoints {
        static let postAndDeleteSessionBase = "https://onthemap-api.udacity.com/v1/session"
        static let getPublicUserBase = "https://onthemap-api.udacity.com/v1/users/"
        
        case postSession
        case deleteSession
        case getPublicUser(String)
        
        var stringValue: String {
            switch self {
            case .postSession:
                return Endpoints.postAndDeleteSessionBase
            case .deleteSession:
                return Endpoints.postAndDeleteSessionBase
            case .getPublicUser(let userId):
                return Endpoints.getPublicUserBase + "\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
}
