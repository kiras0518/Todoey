//
//  ViewController.swift
//  Todoey
//
//  Created by YU on 2018/11/26.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        loadItems()
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Bug"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Sell"
//        itemArray.append(newItem3)
//
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath Call")
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //value = condition ? valueIfTure : valeuIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }

    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
//        if item[indexPath.row].done == false {
//            item[indexPath.row].done = true
//        } else {
//            item[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "Hello", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (actions) in
            //print("Sucess!")
            //print(textfield.text)
        let newItem = Item()
        newItem.title = textfield.text!
            self.itemArray.append(newItem)
            self.saveItems()
//        if textfield.text != "" {
//            self.itemArray.append(newItem)
//            self.saveItems()
//        } else {
//            print("Empty!")
//        }
            
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
            print(alertTextField.text)
            print("Now")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let dencoder = PropertyListDecoder()
            do {
                itemArray = try dencoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding \(error)")
            }
        }
    }
    
}


