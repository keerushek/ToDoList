//
//  ToDoTask.swift
//  ToDoList
//
//  Created by Keerthi Shekar G on 14/03/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

import Foundation
import RealmSwift


class ToDoTask: Object{
    dynamic var taskName = ""
    dynamic var taskCreatedAt = NSDate()
    dynamic var taskDescription = ""
    dynamic var isCompleted = false
}

