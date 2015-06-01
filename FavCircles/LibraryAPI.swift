//
//  SharedAPI.swift
//  FastFavsSwift
//
//  Created by David Oliver Barreto Rodríguez on 30/4/15.
//  Copyright (c) 2015 Oliver Barreto. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    
    // SharedInstance Singleton for API
    static let sharedInstanceAPI = LibraryAPI()
 
    // Class Vars
    private var persistencyManager: PersistencyManager!
    
    override init() {
        persistencyManager = PersistencyManager()

        super.init()
    }

    
    // MARK: REST fastfavs
    func getAllUserFavs() -> [UserFav] {
        return persistencyManager.getAllUserFavs()
    }
    
    func getUserFavsAtIndex(index:Int) -> UserFav {
        return persistencyManager.getUserFavsAtIndex(index)
    }
    
    func addUserFavs(userFav: UserFav) {
        persistencyManager.addUserFavs(userFav)
    }
    
    func addUserFavsAtIndex(userFav: UserFav, index: Int) {
        persistencyManager.addUserFavsAtIndex(userFav, index: index)
    }
    
    func removeUserFavsAtIndex(user: UserFav, index: Int) {
        persistencyManager.removeUserFavsAtIndex(user, index: index)
    }
    
    func removeAllUserFavs() {
        persistencyManager.removeAllUserFavs()
    }
    
    func saveUserFavs() {
        persistencyManager.saveFastFavs()
    }
    
}