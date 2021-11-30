//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anirudha SM on 17/10/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import CoreData
import RealmSwift



class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
      
//    let context = (UIApplication.shared.delegate as!
//                   AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
// MARK: - Table view data source
    
    // Number of items in row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category is added"
        
        return cell
        
    }
    
//MARK: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default){ (action) in

//            let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!

//            self.categories.append(newCategory)

            self.save(category: newCategory)
        }

        alert.addAction(action)

        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new category"

        }

        present(alert,animated: true, completion: nil)
        
        
        
    }
    
    
// MARK: - Table view data delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Data manipulation methods
    
//    func saveCategories(){
    func save(category: Category){
    
        do{
//            try context.save()
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("Error saving category!\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do{
//            categories = try context.fetch(request)
//        } catch{
//            print("Error loading categories\(error)")
//        }
        
    }
    
}
