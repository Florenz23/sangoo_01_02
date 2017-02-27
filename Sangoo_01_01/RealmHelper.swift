//
//  RealmHelper.swift
//  Sangoo_01_01
//
//  Created by Florenz Erstling on 07.02.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    var realm: Realm!
    var cookie = LocalCookie()
    
    
    func iniRealm(syncUser : SyncUser)  -> Realm {
            // Open Realm
            let configuration = Realm.Configuration(
                syncConfiguration: SyncConfiguration(user: syncUser, realmURL: URL(string: "realm://\(Constants.syncHost):9080/~/sangoo")!)
            )
            realm = try! Realm(configuration: configuration)
        
            return realm
    }
    
    func getUser(user : User) -> User {
        
        var user = user
        let userId = self.cookie.getData()
        let searchString = "userId == '\(userId)'"
        print(searchString)
        if user.realm == nil, let receivedUser = self.realm.objects(User.self).filter(searchString).first {
            user = receivedUser
        }
        return user
        
    }
    
    func getConnectListList() -> ConnectListList? {
        let connectListList = self.realm.objects(ConnectListList.self).first
        return connectListList
    }
    
    func getDescriptionGermanValue(user : ConnectUserList, value : String) -> ConnectData {
        
        var searchedObject : ConnectData?
        for description in user.userDescription {
            if description.descriptionGerman == value {
                searchedObject = description
            }
        }
        return searchedObject!
        
    }

    
}
