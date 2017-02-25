//
//  UserDataTableViewController.swift
//  Sangoo_01_01
//
//  Created by Florenz Erstling on 29.01.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import UIKit
import RealmSwift

class EditMySharedData: UITableViewController {
    
    var notificationToken: NotificationToken!
    var realm: Realm!
    
    var textField = UISettings()
    
    let cookie = LocalCookie()
    
    var items = List<ConnectData>()
    
    var authData = AuthData()
    var user = User()
    var realmHelper = RealmHelper()
    var group : GeoData?
    var userData = List<ConnectData>()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iniDummy()
        setupUI()
        setupRealm(syncUser: SyncUser.current!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    
    func setupUI() {
        
        title = "Einstellungen"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "demoCell")
        tableView.backgroundColor = UIColor(red: 0.949,green: 0.949,blue: 0.949,alpha: 1)
        tableView.separatorStyle = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSharedData))
        
    }
    
    
    func setupRealm(syncUser : SyncUser) {
        
        DispatchQueue.main.async {
            
            self.realm = self.realmHelper.iniRealm(syncUser: syncUser)
            self.user = self.realmHelper.getUser(user: self.user)
            self.userData = self.user.userData
            self.tableView.reloadData()
            self.getUserSharedData()
            
        }
        
    }
    
    
    func addSharedData() {
        
        print("Add")
        
    }
    
    // MARK: - Table view data source
    func getUserSharedData() {
       let allUser = group?.connectList?.connectUserList
        let correctUser = getCorrectUser(connectUserList: allUser!)
        let userDataShared = correctUser.userDataShared
        print(userDataShared)
    }
    
    
    func getCorrectUser(connectUserList : List<ConnectUserList>) -> ConnectUserList{
        
        var correctUser : ConnectUserList?
        var userDescriptionWithUserId : ConnectData?
        for user in connectUserList {
            for description in user.userDescription {
                if description.descriptionGerman == "UserId" {
                   userDescriptionWithUserId = description
                }
            }
            let userId = userDescriptionWithUserId?.dataValue
            if userId == self.user.userId {
                correctUser = user
            }
        }
        return correctUser!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userData.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)
        cell.selectionStyle = .none
        
        //disableSelection
        if indexPath.row == userData.count && indexPath.row != 0 {
            cell.textLabel?.text = "Ausloggen"
            cell.textLabel?.textColor = UIColor.blue
            
        } else if indexPath.row < userData.count {
            let data = userData[indexPath.row]
            let textField = UISettings()
            textField.setupTextField(description: data.descriptionGerman, text: data.dataValue)
            cell.addSubview(textField.textField)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == userData.count{
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else if indexPath.row == 1 {
            return 60
        } else {
            return 60
        }
    }
    
    
    
    
}
