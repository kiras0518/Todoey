//
//  ViewController.swift
//  Todoey
//
//  Created by YU on 2018/11/26.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var item = ["1","Find","Buy","GGIII"]
    
    let defaulits = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let items = UserDefaults.standard.array(forKey: "TodoListArray")  {
            item = items as! [String]
        }
    }
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }

    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(item[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "Hello", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (actions) in
            //print("Sucess!")
            print(textfield.text)
         
            if textfield.text != "" {
                self.item.append(textfield.text!)
                self.defaulits.set(self.item, forKey: "TodoListArray")
                self.tableView.reloadData()
            } else {
                print("Empty!")
            }
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
            //print(alertTextField.text)
            print("Now")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

