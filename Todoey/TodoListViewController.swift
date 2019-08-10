//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Gonzalez on 28/07/2019.
//  Copyright © 2019 Francisco Gonzalez. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoArray = [Item]()
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
      
        saveItem()
    }
    
    //MARK: - Add new items
    
    @IBAction func addItemsButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (acction) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectCategory
            self.toDoArray.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveItem (){
        
        do {
           try context.save()
        }catch{
            print ("Error ctm")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItem (with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
                request.predicate = categoryPredicate
        }
        
        do {
            toDoArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print ("Error ctm")
        }
    }
    
    
    
    
}
//MARK - Searchbard methods

extension TodoListViewController : UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title LIKE[CD] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request, predicate: predicate)
        
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
