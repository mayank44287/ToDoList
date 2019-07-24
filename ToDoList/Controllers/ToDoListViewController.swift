//
//  ViewController.swift
//  ToDoList
//
//  Created by Mayank Raj on 6/12/19.
//  Copyright © 2019 Mayank Raj. All rights reserved.
//

import UIKit
 
class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    //let defaults = UserDefaults.standard
    //instead of using user defaults, we are going to create our own plist file
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //trying to use file for storing data instead of user defaults, so we need to print the file path
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Have Breakfast"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Have Lunch"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Have Snacks"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Have Dinner"
        itemArray.append(newItem4)
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //this one line is same as five lines commented above
        self.saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Model Manipulation Methods
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath! )
        }catch{
            print("error encoding item array ,\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("the decoding error, \(error)")
            }
        }
    }
    
    //MARK - add items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Item", message: "", preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add Item Button on UI
            //alert
            
            let newItem = Item()
            newItem.title = textField.text!
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

