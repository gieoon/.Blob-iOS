//
//  ColorScheme.swift
//  Blob
//
//  Created by gieoon on 2018/02/02.
//  Copyright © 2018 shunkagaya. All rights reserved.
//

public class ColourScheme {
    
    let BASE: Int = 0xFFD0C69B;            //0
    let ORANGE: Int = 0xFFDE7921;          //1
    let ORANGE_YELLOW: Int = 0xFFE5953B;   //2
    let YELLOW_ORANGE: Int = 0xFFECB055;   //3
    let YELLOW: Int = 0xFFF3CC6F;          //4
    let YELLOW_GREEN: Int = 0xFFC5C377;    //5
    let GREEN: Int = 0xFF98B97E;           //6
    let AQUA: Int = 0xFF6AB086;            //7
    let BLUE_GREEN: Int = 0xFF4E947D;      //8
    let TEAL: Int = 0xFF317774;            //9
    let BLUE: Int = 0xFF155B6B;            //10
    let BG: Int = 0xFFfaf8ef;
    
    func getColour(cut: Int) -> Int{
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
    
    func getBg() -> Int{
        return self.BG;
    }
}


