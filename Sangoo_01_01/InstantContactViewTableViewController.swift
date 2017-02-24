//
//  InstantContactViewTableViewController.swift
//  Sangoo_01_01
//
//  Created by Florenz Erstling on 23.02.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import UIKit
import UIKit
import RealmSwift
import MapKit
import GeoQueries

class InstantContactViewTableViewController: UITableViewController {
    
    var notificationToken: NotificationToken!
    var realm: Realm!
    var realmHelper = RealmHelper()
    var results : [GeoData]?
    var group : GeoData?
    var messages = List<Message>()
    var user = User()
    let cookie = LocalCookie()
    let locationManager = LocationManager()
    var currentLocation : CLLocationCoordinate2D?
    let connectGroup = ConnectGroup()
    var connects = List<ConnectUserList>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        if (!cookie.check()){
            print("nicht Eingeloggtt")
            goBackToLandingPage()
            
        } else {
            self.locationManager.getCurrentLocation { (result) in
                switch result
                {
                case .Success(let location):
                    self.currentLocation = location
                    self.setupRealm(syncUser: SyncUser.current!)
                    break
                case .Failure(let error):
                    print(error as Any)
                    /* present an error */
                    break
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    
    func setupController () {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(searchGroup))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(createGroup))
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func setupRealm(syncUser : SyncUser) {
        
        DispatchQueue.main.async {
            
            self.realm = self.realmHelper.iniRealm(syncUser: syncUser)
            self.user = self.realmHelper.getUser(user: self.user)
            print("Location")
            print(self.currentLocation)
            //self.currentLocation = CLLocationCoordinate2DMake(37.33233141, -122.0312186)
            func updateList() {
                let radius = 50.00 // 50m
                self.results = try! self.realm.findNearby(type: GeoData.self, origin: self.currentLocation!, radius: radius, sortAscending: true)
                guard let r = self.results else { return }
                if r.count != 0 {
                    self.group = r[0]
                    self.connects = (r[0].connectList?.connectUserList)!
                    self.tableView.reloadData()
                }
                self.handleSearchResults(groups: r)
                if r.count == 0 {
                    self.results = try! self.realm.findNearby(type: GeoData.self, origin: self.currentLocation!, radius: radius, sortAscending: true)
                    guard let r = self.results else { return }
                }
            }
            updateList()
            // Notify us when Realm changes
            self.notificationToken = self.user.realm?.addNotificationBlock { _ in
                updateList()
            }
        }
        
    }
    deinit {
        notificationToken.stop()
    }
    
    func searchGroup() {
        print("search")
        goToSearchGroupTableViewController()
    }
    
    func goToSearchGroupTableViewController() {
        let v = InstantGroupJSQMessagesViewController()
        navigationController?.pushViewController(v, animated: true)
    }
    
    func createGroup() {
        
        print("create")
        goToCreateTableViewController()
    }
    
    func goToCreateTableViewController() {
        
        let v = CreateGroupTableViewController()
        navigationController?.pushViewController(v,animated:true)
        
    }
    
    func goToDetailContacts(sharedData : List<ConnectData>){
        
        
        let v = DetailContactTableViewController()
        v.sharedData = sharedData
        navigationController?.pushViewController(v, animated: true)
        
    }
    
    // MARK: tableView
    func handleSearchResults(groups : [GeoData]) {
        print("Anzahl gruppen")
        print(groups.count)
        if groups.count == 0 {
            self.connectGroup.createNewGroup(user: self.user, location: self.currentLocation!, realm: self.realm)
        } else {
            self.checkIfUserIsGroupMember()
        }
    }
    
    func checkIfUserIsGroupMember() {
        
        let userId = cookie.getData()
        let group = self.group
        let userIsMember = connectGroup.checkIfUserIsGroupMember(userId: userId , group: group!)
        print(userId)
        print (userIsMember)
        if (!userIsMember) {
            connectGroup.suscribeUserInGroup(user: self.user, group: group!, realm: self.realm)
        }
        
    }

    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return connects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = connects[indexPath.row]
        let userNameConnectData = getUserName(userDescription: item.userDescription)
        //cell.textLabel?.text = item.connectList.connectDescription[0].dataValue
        cell.textLabel?.text = userNameConnectData.dataValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let connect = connects[indexPath.row].userDataShared
        goToDetailContacts(sharedData: connect)
    }
    
    func getUserName(userDescription : List<ConnectData>) -> ConnectData{
        
        return userDescription.filter("descriptionGerman == 'Vorname'").first!
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func goToGroupView(realm : Realm, connect : ConnectUserList?) {
        
        let v = GroupViewTableViewController()
        v.receivedRealm = realm
        //v.receivedGroup = connect
        navigationController?.pushViewController(v, animated: true)
        
    }

    func goBackToLandingPage(){
        
        
        let v = LandingPageTableViewController()
        self.tabBarController?.tabBar.isHidden = false
        v.tabBarController?.tabBar.isHidden = false
        // hide Navigation Bar
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(v, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
    }

}
