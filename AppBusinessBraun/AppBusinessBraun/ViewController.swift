//
//  ViewController.swift
//  AppBusinessBraun
//
//  Created by lpiem on 11/3/2563 BE.
//  Copyright © 2563 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var changeSort: Bool! = true
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var randomData: [String]!
    
    var items: [Item]!
    
    var dataManager : CoreDataManager {
        get {
            return CoreDataManager.shared
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if let items = dataManager.loadItems() {
            self.items = items
            tableview.reloadData()
        }
    }
    
    @IBAction func changeSort(_ sender: Any) {
        changeSort = !changeSort
        if let items = dataManager.reloadDataWithSortAction(ascending: changeSort) {
            self.items = items
            tableview.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        if(item.isFavorite){
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        dataManager.saveContext()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].isFavorite = !items[indexPath.row].isFavorite
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        dataManager.searchItems(input: sear chBar.text ?? "")
    }
}

