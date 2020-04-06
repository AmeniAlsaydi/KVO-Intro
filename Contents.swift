import UIKit

// KVO - Key Value observing

// KVO is part of the observer pattern
// NotificationCenter is also an observer pattern
// NotifcationCenter.postNotification(name: "API ready")

// KVO is a one to mnay pattern relaionshop as opposed to delegation which is one-to-one

// in delegation pattern
// class ViewController: UIViewController {}
// eg. tableView.dataSource = self

// KVO is an Objective-C runtime api
// Along with KVO being an objective-c runtime some essentionls are required
// 1. The object being observed needs to be a class
// 2. The class needs to inherit from NCObkect, NSObject is the top abstract class in objective -c. the class also needs to be marked with @objc
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic. dynamic means that the property is being dynamically dispatched (at runtime the compiler verifies the underlying property)
// In swift types are statically dispatched which means they arey checked at compile time vs objective-c which is dynamically dispatched and checked at runtime

//

// Static vs dynamic

// https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d

// Dog class (class being observed)- will have a property to be observed

// The dog is the subject
@objc class Dog: NSObject { // conforms to NSObject and marked as @objc -> Now is KVO compliant
    
    // the property that will be observed needs to be marked with @objc
    var name: String
    @objc dynamic var age: Int // age is an observable property
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
}

// Observer class one

class DogWalker {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // similiar to a listener in firebase - a handle for the property being observed i.e age property
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    
    private func configureBirthdayObservation() {
        // \.age syntax to show this is what is to be oberved -> key path
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // in options we specify what we want in return - and we have access to them in the change property
            
            // now we can update the UI accordingly if in a VC class
            
            guard let age = change.newValue else {return}
            print("hey \(dog.name), happy \(age) birthday from the dog walker ")
            
            print("oldValue is \(change.oldValue ?? 0)")
            print("oldValue is \(change.newValue ?? 0)")
        })
    }
}

// Observer class two

class DogGroomer {
    
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            guard let age = change.newValue else {return}
            print("hey \(dog.name), happy \(age) birthday from the dog groom ")
            
            print("oldValue is \(change.oldValue ?? 0)")
            print("oldValue is \(change.newValue ?? 0)")
        })
    }
}


// test out KVO observing on the .age property of Dog
// both classes (DogWalker and DogGroomer should get .age changes)

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy)
let dogGroomer = DogGroomer(dog: snoopy)

snoopy.age += 1


// example use -> ViewControllers observing changes from a Settings VC
