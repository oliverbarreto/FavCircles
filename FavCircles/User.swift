//
//  User.swift
//  FastFavsSwift
//
//  Created by David Oliver Barreto Rodríguez on 19/4/15.
//  Copyright (c) 2015 Oliver Barreto. All rights reserved.
//

import Foundation

func ==(aUser: UserFav, bUser: UserFav) -> Bool {
    return (aUser.name == bUser.name) && (aUser.lastName == bUser.lastName)
}


class UserFav: NSObject, NSCoding, Printable, Equatable {

    // Model
    var name: String!
    var lastName: String!
    var type: String!
    var favItem: String!
    var imageName: String!
    var favGroup: String!

    private struct Constants {
        // Config
        static let DefaultProfileImage:String = "default_profile_photo.png"
    }

    
    // MARK: Class Init
    init(name: String, lastName: String, type: String, favItem: String, imageName: String, favGroup: String) {
        self.name = name
        self.lastName = lastName
        self.type = type
        self.favItem = favItem
        self.imageName = imageName
        self.favGroup = favGroup

        super.init()
    }
    
    convenience override init() {
        self.init(name: "", lastName: "", type: "", favItem: "", imageName: Constants.DefaultProfileImage, favGroup: "")
    }

    
    
    // MARK: Printable Protocol
    override var description: String {
        
        var tmpDescription: String = "Name: \(name)"
        tmpDescription += " Last Name: \(lastName)"
        tmpDescription += " Type: \(type)"
        tmpDescription += " Fav Item: \(favItem)"
        tmpDescription += " Image Name: \(imageName)"
        tmpDescription += " favGroup: \(favGroup)"
        
        return tmpDescription
    }
    
    
    // MARK: NSCoding Protocol
    private struct UserFavClassNSCodingKeys {
        static let UserFavKeyForName: String = "name"
        static let UserFavKeyForLastName: String = "LastName"
        static let UserFavKeyForType: String = "type"
        static let UserFavKeyForFavItem: String = "favitem"
        static let UserFavKeyForImageName: String = "imageName"
        static let UserFavKeyForFavGroup: String = "favGroup"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.name = aDecoder.decodeObjectForKey(UserFavClassNSCodingKeys.UserFavKeyForName) as! String
        self.lastName = aDecoder.decodeObjectForKey(UserFavClassNSCodingKeys.UserFavKeyForLastName) as! String
        self.type = aDecoder.decodeObjectForKey(UserFavClassNSCodingKeys.UserFavKeyForType) as! String
        self.favItem = aDecoder.decodeObjectForKey(UserFavClassNSCodingKeys.UserFavKeyForFavItem) as! String
        self.imageName = aDecoder.decodeObjectForKey(UserFavClassNSCodingKeys.UserFavKeyForImageName) as! String
        self.favGroup = aDecoder.decodeObjectForKey(UserFavClassNSCodingKeys.UserFavKeyForFavGroup) as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: UserFavClassNSCodingKeys.UserFavKeyForName)
        aCoder.encodeObject(lastName, forKey: UserFavClassNSCodingKeys.UserFavKeyForLastName)
        aCoder.encodeObject(type, forKey: UserFavClassNSCodingKeys.UserFavKeyForType)
        aCoder.encodeObject(favItem, forKey: UserFavClassNSCodingKeys.UserFavKeyForFavItem)
        aCoder.encodeObject(imageName, forKey: UserFavClassNSCodingKeys.UserFavKeyForImageName)
        aCoder.encodeObject(favGroup, forKey: UserFavClassNSCodingKeys.UserFavKeyForFavGroup)
    }
}