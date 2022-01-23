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
    
    var mediaArray = [TableViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addPlusButtonToNavigationBar()
        configureTableView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
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
        cell.textLabel?.text = mediaArray.first { $0.index == indexPath.row}?.name
        return cell
    }
    // cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    //MARK: - get data when view controller load
    func getData() {
        mediaArray.removeAll()
        let context = getContext()
        let request = getFetchRequest()
        do {
            let response = try context.fetch(request)
            if response.count > 0 {
                fillDataToModel(response)
            }
        } catch {
            print("fetch error in get data")
        }
    }
    
    func fillDataToModel(_ response: [NSFetchRequestResult]) {
        var counter = 0
        for res in response as! [NSManagedObject] {
            let mediaModel = TableViewModel()
            if let id = res.value(forKey: "id") as? UUID {
                mediaModel.id = id
            }
            
            if let name = res.value(forKey: "galleryName") as? String {
                mediaModel.name = name
            }
            
            mediaModel.index = counter
            counter += 1
            self.mediaArray.append(mediaModel)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Core Data Usage
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func getFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    func removeData(_ context: NSManagedObjectContext, _ request: NSFetchRequest<NSFetchRequestResult>, _ id: String, _ index: Int) {
        do {
            let response = try context.fetch(request)
            if response.count > 0 {
                for res in response as! [NSManagedObject] {
                    if let mediaId = res.value(forKey: "id") as? UUID {
                        if mediaId.uuidString == id {
                            context.delete(res)
                            mediaArray.remove(at: index)
                            self.tableView.reloadData()
                            saveChanges(context)
                        }
                    }
                }
            }
        } catch {
            print("error in removeData")
        }
    }
    
    func saveChanges(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("success delete")
        } catch {
            print("error in savechanges")
        }
    }
    
    // MARK: - Remove Data From Screen And Core Data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = getContext()
            let request = getFetchRequest()
            
            let id = mediaArray.first { $0.index == indexPath.row}?.id?.uuidString
            request.predicate = NSPredicate(format: "id = %@", id!)
            
            removeData(context, request, id!, indexPath.row)
        }
    }
}

