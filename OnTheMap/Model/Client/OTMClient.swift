//
//  OTMClient.swift
//  OnTheMap
//
//  Created by 邱浩庭 on 27/12/2020.
//

import Foundation
import CoreLocation


class OTMClient {
    
    struct Auth {
        static var userId: String = ""
        static var sessionId: String = ""
    }
    
    enum Endpoints {
        static private let postAndDeleteSessionBase = "https://onthemap-api.udacity.com/v1/session"
        static private let getPublicUserBase = "https://onthemap-api.udacity.com/v1/users/"
        static private let MapLocationBase = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case postSession
        case deleteSession
        case getPublicUser(String)
        case getStudentLocation
        case putStudentLocation
        
        private var stringValue: String {
            switch self {
            case .postSession:
                return Endpoints.postAndDeleteSessionBase
            case .deleteSession:
                return Endpoints.postAndDeleteSessionBase
            case .getPublicUser(let userId):
                return Endpoints.getPublicUserBase + "\(userId)"
            case .getStudentLocation:
                return Endpoints.MapLocationBase + "?order=-updatedAt&limit=100"
            case .putStudentLocation:
                return Endpoints.MapLocationBase
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func resetUserInfo() {
        self.Auth.sessionId = ""
        self.Auth.userId = ""
    }
    
    class func putStudentLocation(mapString: String, mediaURL: String, lastName: String, firstName: String, completion: @escaping (UpdateUserMapResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.putStudentLocation.url)
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(UserMapInfo(uniqueKey: self.Auth.userId, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: AppData.latForUpdate, longitude: AppData.lonForUpdate))
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UpdateUserMapResponse.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping (StudentsLocationResult?, Error?) -> Void) {
        let url = Endpoints.getStudentLocation.url
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
            completion(nil, error)
              return
          }
            let deocder = JSONDecoder()
            let responseObject = try! deocder.decode(StudentsLocationResult.self, from: data!)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        }
        task.resume()
    }

    /**
     Used to authenticate udacity account info and log in
     */
    class func postUdaSession(username: String, password: String, completion: @escaping (UdaSessionResponse?, Error?) -> Void) -> URLSessionTask {
        let url = Endpoints.postSession.url
        let body = LoginSession(udacity: UserInfo(username: username, password: password))
        var httpValue = [String: String]()
        httpValue["application/json"] = "Accept"
        httpValue["application/json"] = "Content-Type"
        let task = taskForUdaPostAndDeleteRequest(url: url, method: "POST", value: httpValue, body: body, responseType: UdaSessionResponse.self, completion: completion)
        return task
    }
    
    /**
     Used to log out
     */
    class func deleteUdaSession(completion: @escaping (UdaLogoutResponse?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(nil, error)
                return
            }
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
                completion(try! decoder.decode(UdaLogoutResponse.self, from: newData!), nil)
            }
        }
        task.resume()
        return task
    }
    
    class func taskForUdaPostAndDeleteRequest<RequestType: Codable, ResponseType: Codable>(url: URL, method: String, value: [String:String], body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = method
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        for (k, v) in value {
            request.addValue(k, forHTTPHeaderField: v)
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if (error != nil) {
                completion(nil, error)
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                // try anonther decoding
                do {
                    let errorObject = try decoder.decode(UdaErrorResponse.self, from: newData!)
                    DispatchQueue.main.async {
                        completion(nil, errorObject)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        })
        
        task.resume()
        return task
    }
}
