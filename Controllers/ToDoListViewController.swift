//
//  ViewController.swift
//  tableView
//
//  Created by macbook on 21 Shevat 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
 
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view, typically from a nib.
        self.loadItems()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        self.saveItems()
        
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
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = itemText.text!
            item.done = false
            self.itemArray.append(item)
            
            self.saveItems()
            
            self.tableView.reloadData()
            }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data")
        }
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)

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

