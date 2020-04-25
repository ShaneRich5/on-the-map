//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/24/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//


import UIKit

class StudentTableViewCell: UITableViewCell {
    public static var reuseIdentifier = "StudentTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func configure(with student: Student) {
        titleLabel.text = "\(student.firstName!) \(student.lastName!)"
        subtitleLabel.text = student.mediaURL
    }
}
