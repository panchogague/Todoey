//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Francisco Gonzalez on 06/08/2019.
//  Copyright © 2019 Francisco Gonzalez. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
  

    let real = try! Realm()
    var categories : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    //MARk: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = categories[indexPath.row];
        }
    }
   

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (acction) in
            let newItem = Category()
            newItem.name = textField.text!
            self.saveItem(category: newItem)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveItem (category:Category){
        
        do {
            try real.write {
                real.add(category)
            }
        }catch{
            print ("Error ctm")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItem () {
        
        categories = real.objects(Category.self)
        tableView.reloadData()
    }
}
