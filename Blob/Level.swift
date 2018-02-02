//
//  Level.swift
//  
//
//  Created by gieoon on 2018/02/02.
//

struct Level {
    
    let lvlNo: Int
    let lvlTitle: String
    var goals = [Goal]()
    
    func setLvlNo(lvlNo: Int) {
        self.lvlNo = lvlNo
    }
    func setLvlTitle(lvlTitle: String) {
        self.lvlTitle = lvlTitle
    }
    func addGoal(newElement: Goal){
        self.goals.append(newElement)
    }
    
}
