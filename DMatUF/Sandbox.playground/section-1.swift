typealias Switch = Bool


var dict: [String: Int] = ["12-12-12": 6, "11-11-11": 5, "10-10-10": 4]

let someKey = "9-9-9"
let someValue = 4

dict.updateValue((dict[someKey] ?? 0) + someValue, forKey: someKey)

dict[someKey]
dict

if (dict[someKey] != nil) {
    println("key exists")
    dict[someKey] = dict[someKey]! + someValue
}


func table() -> [String: [Any]]? {
    return ["test": ["test", 1, 2, 3], "test2" : ["tesg", 1, 2, 3]]
}





