//
//  NoteCoreData.swift
//  NoteKit
//
//  Created by Pin Truong on 28/09/2022.
//

import CoreData

@objc(Note)

class Note: NSManagedObject {
    @NSManaged var iD: NSNumber!
    @NSManaged var title: String!
    @NSManaged var content: String!
    @NSManaged var delDate: Date?
}
