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
    static let signUpUrl = "https://auth.udacity.com/sign-up"
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let orderByParam = "?order=-updatedAt"
        
        case session
        case getUser(String)
        case studentLocation
        case studentLocationChange(String)
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .getUser(let userId):
                return "\(Endpoints.base)/users/\(userId)"
            case .studentLocation:
                return Endpoints.base + "/StudentLocation\(Endpoints.orderByParam)"
            case .studentLocationChange(let objectId):
                return "\(Endpoints.base)/StudentLocation/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var hasValidResponse = false
            
            if let httpResponse = response as? HTTPURLResponse {
                hasValidResponse = (200...299).contains(httpResponse.statusCode)
            }
            
            guard hasValidResponse == true, let data = data, error == nil else {
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
    
    @discardableResult class func taskForPutRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
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
    
    @discardableResult class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
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
        
        _ = taskForPostRequest(url: Endpoints.session.url, responseType: LoginResponse.self, body: udacityCredentials, completion: { response, error in
            
            if let sessionId = response?.session.id, let userId = response?.account.key {
                completion(sessionId, userId, nil)
            } else {
                completion(nil, nil, error)
            }
        })
    }
    
    class func getUser(userId: String, completion: @escaping (User?, Error?) -> Void) {
        _ = taskForGetRequest(url: Endpoints.getUser(userId).url, responseType: UserDetailResponse.self, completion: { response, error in
            
            if let userResponse = response, let user = Optional<User>.some( userResponse.toUser()) {
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    class func loadStudents(completion: @escaping ([Student]?, Error?) -> Void) -> URLSessionDataTask {
        return taskForGetRequest(url: Endpoints.studentLocation.url, responseType: StudentListResponse.self, completion: { response, error in
            
            if let response = response, let students = Optional<[Student]>.some(response.results) {
                completion(students, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    class func saveStudentLocation(studentLocation: StudentLocation, completion: @escaping (String?, Error?) -> Void) {
        
        taskForPostRequest(url: Endpoints.studentLocation.url, responseType: CreateStudentLocationResponse.self, body: studentLocation, completion: { response, error in
            
            if let response = response, let objectId = Optional.some(response.objectId) {
                completion(objectId, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    class func updateStudentLocation(objectId: String, studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        
        taskForPutRequest(url: Endpoints.studentLocationChange(objectId).url, responseType: CreateStudentLocationResponse.self, body: studentLocation, completion: { response, error in
            
            if let _ = response, error == nil{
                completion(true, nil)
            } else {
                completion(false, error)
            }
        })
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        
        for cookie in HTTPCookieStorage.shared.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = data, error == nil {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
        return task
    }
}
