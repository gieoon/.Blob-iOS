//
//  Codable.swift
//  Blob
//
//  Created by gieoon on 2018/02/16.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

import Foundation

//iOS version of local storage
//alternatively, can also use UserDefaults...which is much easier
class DataToSave: NSObject, NSCoding {
    
    //MARK: Properties
    var totalSlices: Int?
    var currentLevel: Int?
    var unlockedLvl: Int?
    //currentPage = currentLevel / 9
    
    //MARK: Archiving Paths
    //static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendPathComponent("save")
    
    init(totalSlices: Int, currentLevel: Int, unlockedLvl: Int){
        self.totalSlices = totalSlices
        self.currentLevel = currentLevel
        self.unlockedLvl = unlockedLvl
    }
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.totalSlices = aDecoder.decodeObject(forKey: "totalSlices") as? Int
        self.currentLevel = aDecoder.decodeObject(forKey: "currentLevel") as? Int
        self.unlockedLvl = aDecoder.decodeObject(forKey: "unlockedLvl") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.totalSlices, forKey: "totalSlices")
        aCoder.encode(self.currentLevel, forKey: "currentLevel")
        aCoder.encode(self.unlockedLvl, forKey: "unlockedLvl")
    }
}

class DataStorage {
    static let _sharedInstance = DataStorage()
    private init(){}
    //holds current data state
    //init to these values before loading.
    var dataToSave = DataToSave(totalSlices: 0, currentLevel: 0, unlockedLvl: 0)// = DataToSave(totalSlices: totalSlices, currentLevel: currentLevel, unlockedLvl: unlockedLvl)
    
    var filePath: String {
        var manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        //print("URL path in Document Directory is: \(url)")
        return (url!.appendingPathComponent("Save").path)
    }
    
    //save data to storage
    public func saveData(){
        print("saving data: ", DataStorage._sharedInstance.dataToSave)
        NSKeyedArchiver.archiveRootObject(DataStorage._sharedInstance.dataToSave, toFile: filePath)
    }
    
    //load data from storage
    public func loadData(){
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataToSave {
            DataStorage._sharedInstance.dataToSave = data
        }
    }
}
