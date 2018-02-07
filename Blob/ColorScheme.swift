//
//  ColorScheme.swift
//  Blob
//
//  Created by gieoon on 2018/02/02.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

struct ColourScheme {
    
    static let BASE: Int = 0xFFD0C69B;            //0
    static let ORANGE: Int = 0xFFDE7921;          //1
    static let ORANGE_YELLOW: Int = 0xFFE5953B;   //2
    static let YELLOW_ORANGE: Int = 0xFFECB055;   //3
    static let YELLOW: Int = 0xFFF3CC6F;          //4
    static let YELLOW_GREEN: Int = 0xFFC5C377;    //5
    static let GREEN: Int = 0xFF98B97E;           //6
    static let AQUA: Int = 0xFF6AB086;            //7
    static let BLUE_GREEN: Int = 0xFF4E947D;      //8
    static let TEAL: Int = 0xFF317774;            //9
    static let BLUE: Int = 0xFF155B6B;            //10
    static let BG: Int = 0xFFfaf8ef;
    
    init(){}
    
    static func getColour(cut: Int) -> Int{
        if(cut < 0 && cut > 10){
            print("INVALID CUT ","Parameter value invalid");
        }
        switch (cut){
            case 0: return BASE;
            case 1: return ORANGE;
            case 2: return ORANGE_YELLOW;
            case 3: return YELLOW_ORANGE;
            case 4: return YELLOW;
            case 5: return YELLOW_GREEN;
            case 6: return GREEN;
            case 7: return AQUA;
            case 8: return BLUE_GREEN;
            case 9: return TEAL;
            case 10: return BLUE;
        default:
            return BG;
        }
    }
    
    static func getBg() -> Int{
        return self.BG;
    }
}


