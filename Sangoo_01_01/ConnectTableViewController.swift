//
//  ContactTableViewController.swift
//  Sangoo_01_01
//
//  Created by Florenz Erstling on 29.01.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import UIKit
import RealmSwift


class ConnectTableViewController: UITableViewController {
    
    // MARK: Model
    
    var items = List<ConnectData>()
    var notificationToken: NotificationToken!
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRealm()
    }
    
    func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createGroup))
    }
    
    
    
    func setupRealm() {
        
        setRealm(user: SyncUser.current!)
        defineUpdateList()
        
    }
    
    func setRealm(user : SyncUser) {
        
        DispatchQueue.main.async {
            // Open Realm
            let configuration = Realm.Configuration(
                syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://10.0.1.4:9080/~/sangoo")!)
            )
            self.realm = try! Realm(configuration: configuration)
            
        }
        
    }
    
    func defineUpdateList() {
        
        DispatchQueue.main.async {
            // Show initial tasks
            if self.items.realm == nil, let list = self.realm.objects(User.self).first {
                self.items = list.userData
            }
            self.tableView.reloadData()
        }
    }

    func createGroup() {
        
        print("create")
    }
    
    
    
    // MARK: tableView
    
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.descriptionGerman
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! items.realm?.write {
            items.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                let item = items[indexPath.row]
                realm.delete(item)
            }
        }
    }
    
    
    // MARK: Functions
}
