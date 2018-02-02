/*
 Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Goals {
    public var pos : String?
    public var start : Int?
    public var length : Int?
    public var cut : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let goals_list = Goals.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Goals Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Goals]
    {
        var models:[Goals] = []
        for item in array
        {
            models.append(Goals(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let goals = Goals(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Goals Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        pos = dictionary["pos"] as? String
        start = dictionary["start"] as? Int
        length = dictionary["length"] as? Int
        cut = dictionary["cut"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.pos, forKey: "pos")
        dictionary.setValue(self.start, forKey: "start")
        dictionary.setValue(self.length, forKey: "length")
        dictionary.setValue(self.cut, forKey: "cut")
        
        return dictionary
    }
    
}

