//
//  ViewController.swift
//  Todoey
//
//  Created by YU on 2018/11/26.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let item = ["1","Find","Buy","GGIII"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

   
}

