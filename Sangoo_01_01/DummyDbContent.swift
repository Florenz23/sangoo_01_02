//
//  DummyDbConten.swift
//  Sangoo_01_01
//
//  Created by Florenz Erstling on 09.02.17.
//  Copyright © 2017 Florenz. All rights reserved.
//

import Foundation


class DummyDbContent {
    
    var authDataList = AuthDataList()
    var userList = UserList()
    var connectListList = ConnectListList()
    var geoData = GeoData()
    var trumpAuth = AuthData()
    var hillaryAuth = AuthData()
    var trumpUser = User()
    var hillaryUser = User()
    var trumpPublicConnectList = ConnectList()
    
    func iniAuth() {
        
        trumpAuth.userName = "Trump23"
        trumpAuth.userPassword = "asdfasdf"
        
        hillaryAuth.userName = "Hillary23"
        hillaryAuth.userPassword = "asdfasdf"
        
    }
    
    func iniUser() {
        
        //ini Ids
        
        trumpUser.userId = trumpAuth.userId
        hillaryUser.userId = hillaryAuth.userId
        
        //connectData
        
        let userDataFirstName = createUserData(description: "Vorname",value: "Donald")
        trumpUser.userData.append(userDataFirstName)
        let userDataLastName = createUserData(description: "Nachname",value: "Trump")
        trumpUser.userData.append(userDataLastName)
        let userDataPhone = createUserData(description: "Telefonnummer",value: "111111")
        trumpUser.userData.append(userDataPhone)
        let userDataEmail = createUserData(description: "Email",value: "Trump@maga.com")
        trumpUser.userData.append(userDataEmail)
        let userDataId = createUserData(description: "UserId",value: trumpAuth.userId)
        trumpUser.userData.append(userDataId)
        
        let userDataFirstName1 = createUserData(description: "Vorname",value: "Hillary")
        hillaryUser.userData.append(userDataFirstName1)
        let userDataLastName1 = createUserData(description: "Nachname",value: "Clinton")
        hillaryUser.userData.append(userDataLastName1)
        let userDataPhone1 = createUserData(description: "Telefonnummer",value: "222222")
        hillaryUser.userData.append(userDataPhone1)
        let userDataEmail1 = createUserData(description: "Email",value: "hillary@war.com")
        hillaryUser.userData.append(userDataEmail1)
        let userDataId1 = createUserData(description: "UserId",value: hillaryAuth.userId)
        hillaryUser.userData.append(userDataId1)
        
        // trumpsPulbicListConnectData
        let trumpGroupDescription = createUserData(description: "Gruppenname",value: "Maga")
        trumpPublicConnectList.connectDescription.append(trumpGroupDescription)
        
        // add Messages in the Group
        let message1 = Message()
        message1.messageText = "Hi Hillary"
        let message2 = Message()
        message2.messageText = "Hi Donald"
        
        //add UserData
        
        message1.userData = trumpUser.userData
        message2.userData = hillaryUser.userData
        
        //add UserId
        
        
        
        //ConnectUserList
        
        let trumpConnectUserList = ConnectUserList()
        let hillaryConnectUserList = ConnectUserList()
        // Description
        trumpConnectUserList.userDescription.append(userDataFirstName)
        hillaryConnectUserList.userDescription.append(userDataFirstName1)
        // dataShared
        trumpConnectUserList.userDataShared.append(userDataFirstName)
        trumpConnectUserList.userDataShared.append(userDataLastName)
        hillaryConnectUserList.userDataShared.append(userDataPhone1)
        hillaryConnectUserList.userDataShared.append(userDataEmail1)

        
        //  ConnectList
        let trumpConnectList = ConnectList()

        //add description
        trumpConnectList.connectDescription.append(userDataFirstName)
        //add add UserLists
        trumpConnectList.connectUserList.append(trumpConnectUserList)
        trumpConnectList.connectUserList.append(hillaryConnectUserList)
        //addMessages
        trumpConnectList.message.append(message1)
        trumpConnectList.message.append(message2)
        
        //GeoData
        let trumpGeoData = GeoData()
        // ConnectList
        trumpGeoData.connectList = trumpConnectList
        
        // User add to Group
        trumpUser.geoData.append(trumpGeoData)
        hillaryUser.geoData.append(trumpGeoData)
        
        //AuthDataList
        authDataList.authDataItems.append(trumpAuth)
        authDataList.authDataItems.append(hillaryAuth)
        
        //UserDataList
        userList.userDataItems.append(trumpUser)
        userList.userDataItems.append(hillaryUser)
        
        
        
    }
    
    func createUserData(description : String, value : String) -> ConnectData {
        
        let userData = ConnectData()
        userData.descriptionGerman = description
        userData.dataValue = value
        return userData
        
    }
    
}
