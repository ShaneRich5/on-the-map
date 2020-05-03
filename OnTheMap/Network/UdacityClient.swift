//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Shane Richards on 5/3/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation


class UdacityClient {
    static let securityCharacters = ")]}'"
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getUser(String)
        
        var stringValue: String {
            switch self {
                case .login:
                    return Endpoints.base + "/session"
                case .getUser(let userId):
                    return "\(Endpoints.base)/users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        
        print("url: \(url)")
        
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let initialCharacterData = data.subdata(in: 0..<securityCharacters.count)
            let initialCharacters = String(decoding: initialCharacterData, as: UTF8.self)

            var jsonData: Data
            
            if initialCharacters == securityCharacters {
                let range = 5..<data.count
                jsonData = data.subdata(in: range)
            } else {
                jsonData = data
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(responseType, from: jsonData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            
            let initialCharacterData = data.subdata(in: 0..<securityCharacters.count)
            let initialCharacters = String(decoding: initialCharacterData, as: UTF8.self)

            var jsonData: Data
            
            if initialCharacters == securityCharacters {
                let range = 5..<data.count
                jsonData = data.subdata(in: range)
            } else {
                jsonData = data
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    class func login(email: String, password: String, completion: @escaping (String?, String?, Error?) -> Void) {
        let credentials = Credentials(username: email, password: password)
        let udacityCredentials = UdacityCredentials(udacity: credentials)
        
        _ = taskForPostRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: udacityCredentials, completion: { response, error in
            
            if let sessionId = response?.session.id, let userId = response?.account.key {
                completion(sessionId, userId, nil)
            } else {
                completion(nil, nil, error)
            }
        })
    }
    
    class func getUser(userId: String, completion: @escaping (User?, Error?) -> Void) {
        let url = Endpoints.getUser(userId).url
        
        _ = taskForGetRequest(url: url, responseType: UserDetailResponse.self, completion: { response, error in
            
            if let userResponse = response, let user = Optional<User>.some( userResponse.toUser()) {
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        })
    }
}
