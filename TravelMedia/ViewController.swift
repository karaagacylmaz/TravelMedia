//
//  ViewController.swift
//  TravelMedia
//
//  Created by Yılmaz Karaağaç on 1/22/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addPlusButtonToNavigationBar()
        configureTableView()
    }
    
    // MARK: - Plus button
    func addPlusButtonToNavigationBar() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    // Go to other segue (screen)
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    // MARK: - Table View
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // the template of a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test"
        return cell
    }
    // cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // MARK: - Core Data Usage

}

