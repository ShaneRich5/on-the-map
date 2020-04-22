//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/21/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation


struct LoginResponse: Codable {
    let account: Account!
    let session: Session!
}

struct Account: Codable {
    let registered: Bool!
    let key: String!
}

struct Session: Codable {
    let id: String!
    let expiration: String!
}
