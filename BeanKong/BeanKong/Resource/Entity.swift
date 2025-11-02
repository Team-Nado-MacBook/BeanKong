//
//  BuildingEntity.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//

import SwiftData
import Foundation

// MARK: - 수업
@Model
class ClassEntity {
    @Attribute(.unique) var classId: String
    var subject: String
    var building: String
    var room: String

    @Relationship(inverse: \ClassSchedule.classEntity)
    var schedules: [ClassSchedule] = []

    init(classId: String, subject: String, building: String, room: String) {
        self.classId = classId
        self.subject = subject
        self.building = building
        self.room = room
    }
}

// MARK: - 수업 시간
@Model
class ClassSchedule {
    var day: String
    var timeSlots: [String] = []

    var classEntity: ClassEntity?

    init(day: String, timeSlots: [String], classEntity: ClassEntity? = nil) {
        self.day = day
        self.timeSlots = timeSlots
        self.classEntity = classEntity
    }
}

import SwiftData

@Model
class MyScheduleEntity: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    var classId: String
    var subject: String
    var building: String
    var room: String
    var schedules: [ClassSchedule] = []

    init(classEntity: ClassEntity) {
        self.classId = classEntity.classId
        self.subject = classEntity.subject
        self.building = classEntity.building
        self.room = classEntity.room
        self.schedules = classEntity.schedules
    }
}
