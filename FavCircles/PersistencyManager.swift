//
//  PersistencyManager.swift
//  FastFavsSwift
//
//  Created by David Oliver Barreto Rodríguez on 30/4/15.
//  Copyright (c) 2015 Oliver Barreto. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    // MARK: Class Constants
    private struct Constants {
        static let MaxNumberOfUserFavs: Int = 20

        static let persistencyOptions = FastFavsPersistencyOptions.FileSystem

        static let StandardUserDefaultsKeyForFastFavsArray: String = "StandardUserDefaultsKeyForFastFavsArray"
        static let FileNameForArchivedObjects:String = "favcircles.bin"
    }
    
    // MARK: Model
    private var favs = [UserFav]()
    
    override init() {
        super.init()
        
        // Load Archived Objects data from the file system or create dummy DB if there is no previous data
        loadFastFavs()
    }

    // MARK: Save/Persist FastFavs
    private enum FastFavsPersistencyOptions {
        case FileSystem
        case NSUserDefaults
        case CoreData
    }
    
    
    func loadFastFavs() {
        switch Constants.persistencyOptions {
        case .FileSystem:
            loadFastFavsObjectFromFileSystem()  // Load from File System
            break;
        case .NSUserDefaults:
            loadFastFavsObjectFromNSUserDefaults()  // Load from NSUserDefaults
            break;
        default:
            break;
        }
    }
    
    func saveFastFavs() {
        switch Constants.persistencyOptions {
        case .FileSystem:
            // Load from File System
            saveFastFavsObjectFromFileSystem()
            break;
        case .NSUserDefaults:
            // Load from NSUserDefaults
            saveFastFavsObjectFromNSUserDefaults()
            break;
        default:
            break;
        }
    }
    
    

    // MARK: REST FastFavs
    
    func getAllUserFavs() -> [UserFav] {
        return favs
    }
    
    func getUserFavsAtIndex(index:Int) -> UserFav {
        return favs[index]
    }
    
    func addUserFavs(userFav: UserFav) {
        favs.append(userFav)
    }
    
    func addUserFavsAtIndex(userFav: UserFav, index: Int) {
        if (favs.count >= index) {
            favs.append(userFav)
        } else {
            favs.insert(userFav, atIndex: index)
        }
    }
    
    func removeUserFavsAtIndex(user: UserFav, index: Int) {
        favs.removeAtIndex(index)
    }
    
    func removeAllUserFavs() {
        favs.removeLast()
    }

    
    // MARK: Helpers & Utility Methods
    
    private func createDummyDataBaseWithNumberOfFavs(numberOfFavs: Int) {
        var tempFavs = [UserFav]()
    
        createDummyDataBase()
        for i in 0..<numberOfFavs  {
            if let user = randomUserFav() {
                tempFavs.append(user)
                println("tempDB ADD: \(user)")
            }
        }
    
        favs = tempFavs
        println("\(favs.description)")
    
    }
    
    
    // Return a random user from the database
    private func randomUserFav() -> UserFav? {
        let randomIndex = Int(arc4random_uniform(UInt32(favs.count )))
        
        if let randomUser:UserFav = self.favs[randomIndex] as UserFav? {
            return randomUser
        } else {
            return nil
        }
    }
    
    // Create a Dummy Database with contacts for Family Group
    private func createDummyDataBase() {
        
        let tmpDB: [UserFav] = [
            UserFav(name: "Oliver", lastName: "Barreto", type: "iPhone", favItem: "+34610700505", imageName: "Oliver.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "iPhone", favItem: "+34670875979", imageName: "ARAL.jpg", favGroup: "Family"),
            UserFav(name: "Ana", lastName: "Acosta", type: "Work", favItem: "+34922602083", imageName: "ARAL.jpg", favGroup: "Family"),
            UserFav(name: "Mima", lastName: "Rodríguez Pestano", type: "iPhone", favItem: "+34697414021", imageName: "Mima.jpeg", favGroup: "Family"),
            UserFav(name: "Default", lastName: "Default", type: "Default", favItem: "", imageName: "default.png", favGroup: "Family"),
            UserFav(name: "Colegio Pureza de María", lastName: "", type: "Work", favItem: "+34922277763", imageName: "purezamaria.jpeg", favGroup: "Colegio"),        

            UserFav(name: "Bulbasur", lastName: "", type: "Mikemons", favItem: "", imageName: "bulbasaur.jpg", favGroup: "Mikemons"),
            UserFav(name: "Venusaur", lastName: "", type: "Mikemons", favItem: "", imageName: "venusaur.jpg", favGroup: "Mikemons"),
            UserFav(name: "Ivysaur", lastName: "", type: "Mikemons", favItem: "", imageName: "ivysaur.jpg", favGroup: "Mikemons"),
            UserFav(name: "Wigglytuff", lastName: "", type: "Mikemons", favItem: "", imageName: "wigglytuff.jpg", favGroup: "Mikemons"),
            UserFav(name: "Jigglypuff", lastName: "", type: "Mikemons", favItem: "", imageName: "jigglypuff.jpg", favGroup: "Mikemons"),
            UserFav(name: "raichu", lastName: "", type: "Mikemons", favItem: "", imageName: "raichu.jpg", favGroup: "Mikemons"),

            UserFav(name: "Pikachu", lastName: "", type: "Mikemons", favItem: "", imageName: "pikachu.png", favGroup: "Mikemons")]
        
        favs = tmpDB
        println("DATABASE - user added: " + "\(favs.description)")
        
    }
    
    
    // MARK: Persistency wiht NSUserDefautls
    
    // Load from NSUserDefaults
    private func loadFastFavsObjectFromNSUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data: NSData = defaults.objectForKey(Constants.StandardUserDefaultsKeyForFastFavsArray) as! NSData? {
            if let unarchivedObjects = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [UserFav]? {
                favs = unarchivedObjects
            }
        } else {
            createDummyDataBaseWithNumberOfFavs(Constants.MaxNumberOfUserFavs)
        }
    }
    
    // Save to NSUserDefaults
    private func saveFastFavsObjectFromNSUserDefaults() {
        if let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(favs) as NSData? {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(data, forKey: Constants.StandardUserDefaultsKeyForFastFavsArray)
            defaults.synchronize()
        }
    }
    
    
    // MARK: PERsistency with File system
    
    private func loadFastFavsObjectFromFileSystem() {
        // Load Archived Objects data from the file system or create dummy DB if there is no previous data
        let fileManager = NSFileManager()
        
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as! [NSURL]
        if (urls.count > 0) {
            let documentFolder = urls[0]
            var error: NSError?
            let myURL = documentFolder.URLByAppendingPathComponent(Constants.FileNameForArchivedObjects)
            if let path = myURL.path {
                if fileManager.fileExistsAtPath(path) {
                    if let data = NSData(contentsOfFile: path) {
                        if let unarchivedObjects = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [UserFav]? {
                            favs = unarchivedObjects }
                    } else {
                        createDummyDataBaseWithNumberOfFavs(Constants.MaxNumberOfUserFavs)
                    }
                } else {
                    createDummyDataBaseWithNumberOfFavs(Constants.MaxNumberOfUserFavs)
                }
            }
        }
    }

    private func saveFastFavsObjectFromFileSystem() {
        // Persist using Archiving/Unarchiving Objetcs to filesystem
        if let data = NSKeyedArchiver.archivedDataWithRootObject(favs) as NSData? {

            let fileManager = NSFileManager()
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as! [NSURL]
            if (urls.count > 0) {
                let documentsFolder = urls[0]
                var error: NSError?
                // Uncomment if creating unique file names
                //let uniqueIDForFile = NSDate.timeIntervalSinceReferenceDate()
                //let url = documentsDirectory.URLByAppendingPathComponent("\(uniqueIDForFile).bin")
                let myURL = documentsFolder.URLByAppendingPathComponent(Constants.FileNameForArchivedObjects)
                let succeeded = data.writeToURL(myURL, options: NSDataWritingOptions.DataWritingAtomic, error: &error)
                if (succeeded){
                    println("Saved Objects to PATH: \(myURL)")
                } else {
                    if let theError = error{
                        println("Could not write. Error = \(theError)")
                    }
                }
                    
            }
        }
    }
}
