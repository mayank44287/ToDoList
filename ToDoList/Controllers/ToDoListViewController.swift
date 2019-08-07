//
//  ViewController.swift
//  ToDoList
//
//  Created by Mayank Raj on 6/12/19.
//  Copyright © 2019 Mayank Raj. All rights reserved.
//

import UIKit
import CoreData
 
class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //let defaults = UserDefaults.standard
    //instead of using user defaults, we are going to create our own plist file
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //trying to use file for storing data instead of user defaults, so we need to print the file path
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Have Breakfast"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Have Lunch"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Have Snacks"
//        itemArray.append(newItem3)
//        
//        let newItem4 = Item()
//        newItem4.title = "Have Dinner"
//        itemArray.append(newItem4)
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        loadData()

//        if let items = defaults.array(forKey: "ToDoListArray ") as? [Item]{   //to make sure the app doesnt crash if the file                                                                      //   does not exist
//           itemArray = items
//       }
    }
    
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = (item.done == true) ? .checkmark : .none //this is equivalent to 5 lines of code below commented
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
//
        //the order of delete and remove is important. one has to delete row first frm context object and then the item array
        //otherwise segmentation fault may occur
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //this one line is same as five lines commented above
        self.saveItems()
        
       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Model Manipulation Methods
    
    func saveItems(){
 
//  we do not need this when we are using CoreData
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath! )
//        }catch{
//            print("error encoding item array ,\(error)")
//        }
        
        do{
            try self.context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        //in here with is external parameter which gets shoen in calling function
        //and request is internal parameter used inside this function
        // and the = represents default value if no parameter passed
    
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch{
//                print("the decoding error, \(error)")
//            }
//        }
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request) //this one returns an array of rows from the table
        }catch{
            print("error fercing data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK - add items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Item", message: "", preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add Item Button on UI
            //alert
            let newItem = Item(context: self.context )
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems()
           
            
        }
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create new item"
            textField = alerttextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
}

//Mark - Search Bar methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        //NSPredicate is a Foundation class that specifies how data should be fetched or filtered. Its query language, which is like a cross between a SQL WHERE clause and a regular expression, provides an expressive, natural language interface to define logical conditions on which a collection is searched
        
         //let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text! )
        //cd is used to make the text case and diacritic insensitive
        
        let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text! )
        //let sortDescr = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error in fetching data from context")
//        }
        loadData(with : request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()             //this is to reload entire list when search bar is empty
            //this method is used to take the cursor out of search bar and makes the keyboard go away when the searchbar is empty. Dispatchqueue.main make sure that this task is put on the main queue of threads so that it executes in the foreground
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

