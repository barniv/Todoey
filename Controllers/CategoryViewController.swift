//
//  CategoryViewControllerTableViewController.swift
//  tableView
//
//  Created by macbook on 2 Adar I 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    @IBOutlet var categoryTableView: UITableView!

    var categoryNames : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryNames?[indexPath.row].name ?? "No Categories Exists"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryNames?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDoListView = segue.destination as! ToDoListViewController
        
        if let index = categoryTableView.indexPathForSelectedRow {
            toDoListView.selectedCategory = self.categoryNames[index.row]
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
            let category = Category()
            category.name = itemText.text!
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(category)
                }
            } catch {
                print("Error saving using Realm")
            }
            self.tableView.reloadData()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
        }
    

    func loadCategories() {
        do {
            let realm = try Realm()
            categoryNames = realm.objects(Category.self)
            categoryTableView.reloadData()
        } catch {
            print("Error loading data from realm")
        }
    }

}
