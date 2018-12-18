//
//  CategoryViewController.swift
//  Todoey
//
//  Created by YU on 2018/12/5.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var cateArray : Results<Category>?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            //self.cateArray.append(newCategory)
            self.save(category: newCategory)
            
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
        return cateArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = cateArray?[indexPath.row] {
            
            //cell.textLabel?.text = cateArray?[indexPath.row].name ?? "No Categories"
            cell.textLabel?.text = category.name
            guard let categoryColur = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColur
            cell.textLabel?.textColor = ContrastColorOf(categoryColur, returnFlat: true)
            
        }
        
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = cateArray?[indexPath.row]
        }
    }
    
    //Data Manipulation Methods
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        cateArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        //super.updateModel(at: indexPath)
        if let categroyForDeletion = self.cateArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categroyForDeletion)
                }
            } catch {
                print("Error deleting cateArray, \(error)")
            }
        }
    }
    
    override func editModel(at indexPath: IndexPath) {
        if let categoryForEdit = self.cateArray?[indexPath.row].name{
            var editText = UITextField()
            
            let alert = UIAlertController(title: "Edit", message: "Change the name of this Category", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = categoryForEdit
                editText = textField
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
                if editText.text != nil {
                    
                    do{
                        try self.realm.write {
                            self.cateArray?[indexPath.row].name = editText.text!
                        }
                    }catch{
                        print("Error editing Category \(error)")
                    }
                    self.tableView.reloadData()
                }else{
                    let blankAlert = UIAlertController(title: "Need some text to change title", message: "", preferredStyle: .actionSheet)
                    let gotItAction = UIAlertAction(title: "Got it", style: .default, handler: { (gotItAction) in
                        self.present(alert,animated: true,completion: nil)
                    })
                    blankAlert.addAction(gotItAction)
                    self.present(blankAlert,animated: true,completion: nil)
                }
            }
            alert.addAction(saveAction)
            
            present(alert, animated: true, completion: nil)      
        }
    }
    
}
