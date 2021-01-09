//
//  Extensions.swift
//  MachineTest
//
//  Created by SD on 08/01/21.
//

import Foundation

extension NSObject {
    class var string: String {
        return String(describing: self);
    }
}

//Protocal that copyable class should conform
extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

//Array extension for elements conforms the Copying protocol
extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
