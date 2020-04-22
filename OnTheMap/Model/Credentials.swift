//
//  LoginCredentials.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/21/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation


struct UdacityCredentials: Codable {
    let udacity: Credentials!
}


struct Credentials: Codable {
    let username: String!
    let password: String!
}
