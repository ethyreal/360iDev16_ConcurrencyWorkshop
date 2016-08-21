//: [⬅ GCD Groups](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: ## GCD Barriers
//: When you're using asynchronous calls you need to consider thread safety.
//: Consider the following object:

let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")

//: The `Person` class includes a method to change names:

nameChangingPerson.changeName(firstName: "Brian", lastName: "Biggles")

//: What happens if you try and use the `changeName(firstName:lastName:)` simulataneously from a concurrent queue?

let workerQueue = DispatchQueue(label: "com.ethyreal.worker", attributes: .concurrent)
let nameChangeGroup = DispatchGroup()

let nameList = [("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

for (idx, name) in nameList.enumerated() {
    
    workerQueue.async(group: nameChangeGroup) {

        usleep(UInt32(10_000 * idx))
        nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
        
        print("current name: \(nameChangingPerson.name)")
    }
}

//: __Result:__ `nameChangingPerson` has been left in an inconsistent state.

nameChangeGroup.notify(queue: DispatchQueue.main) { 
    print("final name: \(nameChangingPerson.name)")
}

//: ### Dispatch Barrier
//: A barrier allows you add a task to a concurrent queue that will be run in a serial fashion. i.e. it will wait for the currently queued tasks to complete, and prevent any new ones starting.

// TODO


print("\n=== Threadsafe ===")

let threadSafeNameGroup = DispatchGroup()

// TODO
//: [➡ Futures](@next)
