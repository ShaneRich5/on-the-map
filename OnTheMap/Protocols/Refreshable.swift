//
//  Refreshable.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/26/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import Foundation


protocol Refreshable {
    func refresh(students: [Student]) -> Void
}
