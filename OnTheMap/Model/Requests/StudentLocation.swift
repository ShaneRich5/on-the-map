//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Shane Richards on 5/2/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var uniqueKey: String!
    var firstName: String!
    var lastName: String!
    var mapString: String!
    var mediaURL: String!
    var latitude: Double!
    var longitude: Double!
    var objectId: String?
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
