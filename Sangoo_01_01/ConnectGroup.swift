//
//  ConnectGroup.swift
//  Sangoo_01_01
//
//  Created by Florenz Erstling on 19.02.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import RealmSwift
import MapKit



class ConnectGroup {
    
    
    func checkIfUserIsGroupMember(userId: String, group : GeoData) -> Bool{
        let connectUserList = group.connectList?.connectUserList
        //let tanDogs = realm.objects(Dog.self).filter("color = 'tan'")
        //let tanDogsWithBNames = tanDogs.filter("name BEGINSWITH 'B'")
        for user in connectUserList! {
            for userData in user.userDescription {
                if userData.dataValue == userId {
                    return true
                }
            }
        }
        return false
    }
    
    func suscribeUserInGroup(user : User, group : GeoData, realm : Realm) {
        let connectList = group.connectList
        let connectUserList = ConnectUserList()
        let userIdDescription = ConnectData()
        let userNameConnectData = user.userData.filter("descriptionGerman == 'Vorname'").first
        userIdDescription.descriptionGerman = "UserId"
        userIdDescription.dataValue = user.userId
        connectUserList.userDescription.append(userIdDescription)
        connectUserList.userDescription.append(userNameConnectData!)
        connectUserList.userDataShared.append(user.userData[0])
        
        try! realm.write {
            connectList?.connectUserList.append(connectUserList)
        }
    }
    
    func createNewGroup(user : User, location : CLLocationCoordinate2D, realm : Realm) {
        let group = ConnectList()
        let groupDescription = ConnectData()
        let groupAdmin = user.userData[0]
        let groupAdminData = ConnectUserList()
        let userIdDescription = ConnectData()
        userIdDescription.descriptionGerman = "UserId"
        userIdDescription.dataValue = user.userId
        groupAdminData.userDescription.append(groupAdmin)
        groupAdminData.userDescription.append(userIdDescription)
        groupAdminData.userDataShared.append(groupAdmin)
        groupDescription.descriptionGerman = "Gruppenname"
        groupDescription.dataValue = "PublicAnonymousGroup"
        group.connectDescription.append(groupDescription)
        group.connectUserList.append(groupAdminData)
        let geoData = GeoData()
        // todo Check if coordinates exist, sonst warten
        geoData.lng = location.longitude
        geoData.lat = location.latitude
        geoData.connectList = group
        try! realm.write {
            user.geoData.append(geoData)
        }
    }
}
