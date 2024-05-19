//
//  Test.swift
//  Chmod_SwiftUI
//
//  Created by Jack Allie on 11/5/2024.
//

import Foundation

class Permissions {
    public let user = UserPermissions()
    public let group = UserPermissions()
    public let other = UserPermissions()
    public let special = SpecialPermissions()
}

enum AccessType: Int {
    case read = 4
    case write = 2
    case execute = 1
}

enum SpecialType: Int {
    case setupId = 4
    case setupGrid = 2
    case sticky = 1
}

enum Operation {
    case add, remove
}

class IndividualPermissions {
    public var value = 0 {
        didSet {
            print("SET VALUE \(value)")
        }
    }

    public func changeValue(operation: Operation, access: AccessType) {
        changeValue(operation: operation, by: access.rawValue)
    }

    public func changeValue(operation: Operation, access: SpecialType) {
        changeValue(operation: operation, by: access.rawValue)
    }

    public func changeValue(operation: Operation, by increment: Int) {
        if operation == .add {
            value += increment
        } else {
            value -= increment
        }

        updateToggles()
    }

    func updateToggles() {}
}

class UserPermissions: IndividualPermissions {
    public var read = false
    public var write = false
    public var execute = false

    override func updateToggles() {
        var num = value

        if num >= 4 { 
            read = true
            num -= 4
        }
        if num >= 2 {
            write = true
            num -= 2
        }
        if num >= 1 {
            execute = true
            num -= 1
        }
    }
}

class SpecialPermissions: IndividualPermissions {
    public var setupId = false
    public var setgrid = false
    public var sticky = false

    override func updateToggles() {
        var num = value

        if num >= 4 { 
            setupId = true
            num -= 4
        }
        if num >= 2 {
            setgrid = true
            num -= 2
        }
        if num >= 1 {
            sticky = true
            num -= 1
        }
    }
}
