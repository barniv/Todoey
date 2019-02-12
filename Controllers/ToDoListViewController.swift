//
//  ViewController.swift
//  tableView
//
//  Created by macbook on 21 Shevat 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
 
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            self.loadItems()
        }
    }
    
    var itemArray : Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items"
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        do {
            let realm = try Realm()
            
            try realm.write {
                if let item = itemArray?[indexPath.row] {
                    item.done = !item.done
                }
            }
            
        } catch {
            print("error using realm")
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemText = UITextField()
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "New Item"
            itemText = textField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (_) in
            if let currentCategory = self.selectedCategory {
                do{
                    let realm = try Realm()
                    try realm.write {
                        let item = Item()
                        item.title = itemText.text!
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("error with Realm")
                }

            self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(with request : String = "") {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItems(with: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count ==  0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

