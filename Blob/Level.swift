//
//  Level.swift
//  
//
//  Created by gieoon on 2018/02/02.
//

struct Level {
    
    var lvlNo: Int
    var lvlTitle: String
    var goals = [Goal]()
    
    //init is a keyword that allows usage of "self" it seems
    init(lvlNo: Int, lvlTitle: String, goals: [Goal]){
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
    mutating func addGoal(newElement: Goal){
        self.goals.append(newElement)
    }
    
}
