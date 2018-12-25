//
//  ViewController.swift
//  Todoey
//
//  Created by Jaime Sebastian Ginorio Ramirez on 12/20/18.
//  Copyright © 2018 Jaime Sebastian Ginorio Ramirez. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //Creates array of item objects
    var todoItems: Results<Item>?
    let realm = try! Realm()
   
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
       
        
        return cell
    }


    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("Index path row: " + String(indexPath.row) + "   Section:" + String(indexPath.section))
      //  print(itemArray[indexPath.row])
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    //This equals lo contrario of this
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }

        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            //What will happen once the user clicks the Add item Button
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        print(newItem.date!)
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving items \(error)")
                }
            }
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        loadItems()
    }
    
    
    //MARK - Model Manupulation methods
    
    
    //Si no se provee un argunmento para la funcion, usa este valor por default
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    

}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //[cd] not case[c] o acento senstive[d]
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0){
            loadItems()
            DispatchQueue.main.async {
                //No longer va estar el keyboard cuando se aprete la X
                searchBar.resignFirstResponder()
            }

        }
    }
}
