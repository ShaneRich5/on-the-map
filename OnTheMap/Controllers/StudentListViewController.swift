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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Request Error \(error)")
                return
            }

            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(StudentListResponse.self, from: data)
                    self.students = result.results
                    self.tableView.reloadData()
                } catch {
                    print("error occured: \(error)")
                }
            }
        }
        
        task.resume()
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
