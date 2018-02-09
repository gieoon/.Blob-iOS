//
//  Level.swift
//  
//
//  Created by gieoon on 2018/02/02.
//

struct Level {
    
    var lvlNo: Int
    var lvlTitle: String
    var goals = Array<Goals>()
    
    //init is a keyword that allows usage of "self" it seems
    init(lvlNo: Int, lvlTitle: String, goals: Array<Goals>){
        self.lvlNo = lvlNo
        self.lvlTitle = lvlTitle
        self.goals = goals
    }

    mutating func setLvlNo(lvlNoq: Int) {
        self.lvlNo = lvlNoq
    }
    mutating func setLvlTitle(lvlTitle: String) {
        self.lvlTitle = lvlTitle
    }
    mutating func addGoal(newElement: Goals){
        self.goals.append(newElement)
    }
    
}
