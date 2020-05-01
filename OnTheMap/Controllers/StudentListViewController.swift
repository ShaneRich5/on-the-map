//
//  UserListViewController.swift
//  OnTheMap
//
//  Created by Shane Richards on 4/24/20.
//  Copyright © 2020 Shane Richards. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let segueIdentifier = "followLink"
    var students = [Student]()
    var selectedIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}

extension StudentListViewController: Refreshable {
    func refresh(students: [Student]) {
        self.students = students
    }
}

extension StudentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseIdentifier) as! StudentTableViewCell
        let student = students[indexPath.row]
        
        cell.configure(with: student)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
}

extension StudentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: segueIdentifier, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
