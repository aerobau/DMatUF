import Foundation


class SomeClass {
    var name: String = "No Name"
}

let a = SomeClass()
a.name = "Jeff Stevens"

let b = SomeClass()
b.name = "Mick MacCallum"

let c = SomeClass()
c.name = "Ian MacCallum"

let d = SomeClass()
d.name = "Jeff Perez"

let names = [a, b, c, d]

let maccallums = names.filter { $0.name.hasSuffix("MacCallum") }

maccallums


let jeffs = names.filter { $0.name.hasPrefix("Jeff") }

jeffs

