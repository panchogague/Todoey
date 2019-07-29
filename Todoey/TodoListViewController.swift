//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Gonzalez on 28/07/2019.
//  Copyright © 2019 Francisco Gonzalez. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var toDoArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            toDoArray = items
        }
    }

    //MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row].title
        
        if(toDoArray[indexPath.row].done){
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }

    //MARk: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
      
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    
    @IBAction func addItemsButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (acction) in
          
            self.toDoArray.append(Item(title: textField.text!))
            self.tableView.reloadData()
            self.defaults.set(self.toDoArray, forKey: "TodoListArray")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

