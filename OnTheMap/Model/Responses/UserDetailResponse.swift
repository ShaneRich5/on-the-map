//
//  UserDetailResponse.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/27/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation


class UserDetailResponse: Codable {
    var firstName: String!
    var lastName: String!
    var userId: String!
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case userId = "key"
    }
    
    func toUser() -> User {
        let user =  User()
        user.firstName = firstName
        user.lastName = lastName
        user.userId = userId
        return user
    }
}
