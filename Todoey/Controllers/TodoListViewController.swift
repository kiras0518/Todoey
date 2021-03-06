//
//  ViewController.swift
//  Todoey
//
//  Created by YU on 2018/11/26.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var itemArray : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
 
     //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        guard let colourHex = selectedCategory?.colour else {fatalError()}
            //navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory!.colour)
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        guard let originalColour = UIColor(hexString: "1D9BF6") else {
//            fatalError()}
//        navigationController?.navigationBar.barTintColor = originalColour
//        navigationController?.navigationBar.tintColor = FlatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //Navbar Setup Methods
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigationController dose not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            //print("version 1: \(CGFloat(indexPath.row / itemArray!.count))")
            //print("version 2: \(CGFloat(indexPath.row) / CGFloat(itemArray!.count))")
           
            //value = condition ? valueIfTure : valeuIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }

//    //Inserting or Deleting Table Rows
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let category = itemArray?[indexPath.row] {
//                do {
//                    try relam.write {
//                        relam.delete(category)
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//            tableView.reloadData()
//        }
//    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
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
       
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()//textField在最上面才能在action時讀取到addTextField.text

        let alert = UIAlertController(title: "Add New", message: "Hello", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (actions) in
            //print("Sucess!")
            //print(textfield.text)

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
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
            //最上面的textField=alertTextField讓action讀取到self.itemArray.append(textField.text!)存在array
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    func loadItems() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //itemArray = selectedCategory?.items as? Results
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
    
    override func editModel(at indexPath: IndexPath) {
        if let categoryForEdit = self.itemArray?[indexPath.row].title{
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
                            self.itemArray?[indexPath.row].title = editText.text!
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


//MARK: Search Bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
