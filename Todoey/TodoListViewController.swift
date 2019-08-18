//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Gonzalez on 28/07/2019.
//  Copyright © 2019 Francisco Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let real = try! Realm()
    var items : Results<Item>!
    var selectCategory : Category? {
        didSet{
            loadItem()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row]{
             cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    //MARk: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]{
            do{
                try real.write {
                  item.done = !item.done
                }
            }
            catch{
                print("Error updating")
            }
            
        }
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

      
    }
    
    //MARK: - Add new items
    
    @IBAction func addItemsButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (acction) in
            
            if let currentCategory = self.selectCategory {
                do {
                    try self.real.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving new item. \(error)")
                }
            }
             self.tableView.reloadData()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveItem (item:Item){
        
        do {
            try real.write {
                real.add(item)
            }
        }catch{
            print ("Error ctm")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItem () {
       
        items = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    
    
}
//MARK - Searchbard methods

extension TodoListViewController : UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
