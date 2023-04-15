//
//  Memory.swift
//  reminiscenceplayer
//
//  Created by user on 2023/04/15.
//

import Foundation
import SwiftUI
import CoreData

// Create Core Data class for entity
@objc(Memory)
public class Memory: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var image: Data
    @NSManaged public var color: UIColor
}
