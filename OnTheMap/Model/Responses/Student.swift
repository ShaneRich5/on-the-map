//
//  Student.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/24/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

class Student: Codable {
    var firstName: String!
    var lastName: String!
    var longitude: Float!
    var latitude: Float!
    var mapString: String!
    var mediaURL: String!
    var uniqueKey: String!
    var objectId: String!
    var createdAt: String!
    var updatedAt: String!
}
