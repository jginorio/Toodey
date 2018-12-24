//
//  ViewController.swift
//  Todoey
//
//  Created by Jaime Sebastian Ginorio Ramirez on 12/20/18.
//  Copyright © 2018 Jaime Sebastian Ginorio Ramirez. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {

    //Creates array of item objects
    var itemArray = [Item]()
   
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    /* Creating the context object that is inside the App Delegate(Singleton),
     * Context es el intermediario between DataBase y el app
     * App ==> Context ==> DataBase(PersistentContainer)
     */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
       
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }


    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("Index path row: " + String(indexPath.row) + "   Section:" + String(indexPath.section))
      //  print(itemArray[indexPath.row])
        
        //This equals lo contrario of this
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default)
        { (action) in
            //What will happen once the user clicks the Add item Button
            
            //Initializing the Core Data object
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //Write the data inside the plist
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Model Manupulation methods
    func saveItems(){
        do{
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //Si no se provee un argunmento para la funcion, usa este valor por default
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        do{
           itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    

}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item>  = Item.fetchRequest()
        //[cd] not case[c] o acento senstive[d]
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        //tableView.reloadData()
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
