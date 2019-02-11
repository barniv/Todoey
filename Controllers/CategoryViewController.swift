//
//  CategoryViewControllerTableViewController.swift
//  tableView
//
//  Created by macbook on 2 Adar I 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    @IBOutlet var categoryTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryNames : [Category] = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryNames[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryNames.count
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemText = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New Item"
            itemText = textField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = itemText.text!
            self.categoryNames.append(category)
            self.saveData()
            
            self.tableView.reloadData()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
        }
    

    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryNames = try self.context.fetch(request)
            categoryTableView.reloadData()
        } catch {
            print("Error fetching data")
        }
    }

}
