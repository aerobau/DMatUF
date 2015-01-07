import Foundation


//extension String {
//    subscript(pattern: String) -> Bool {
//    get {
//    let range = self.rangeOfString(pattern)
//    
//    return range.isEmpty
//    }
//    }
//}
//
//var aString = "We ❤ Swift"
//aString["❤"]
//aString["Hello World"]

extension Int {
    subscript(i: Int) -> Int? {
        let digits = reverse(String(self))
            
        if i >= digits.count {
            return nil
        }
        return String(digits[i]).toInt()
    }
}

6493[3]


func greeting (language: String, greeting: String) -> (String, String) {
    
    var found = ("\(language)", "\(greeting)")
    
    return found
}

let foo = greeting("English", "some greeting")

foo.0
foo.1