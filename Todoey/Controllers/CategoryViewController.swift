//
//  CategoryViewController.swift
//  Todoey
//
//  Created by YU on 2018/12/5.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var cateArray = [Categroy]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Categroy(context: self.context)
            
            newCategory.name = textField.text!
            self.cateArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = cateArray[indexPath.row].name
        
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = cateArray[indexPath.row]
        }
    }
    
    //Data Manipulation Methods
    func saveCategories(){
        do {
        try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Categroy> = Categroy.fetchRequest()
        do {
            cateArray = try context.fetch(request)
        } catch {
            print("Error fetching data form context \(error)")
        }
        tableView.reloadData()
    }
    
}
