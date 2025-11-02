//
//  BuildingEntity.swift
//  BeanKong
//
//  Created by 문재윤 on 11/2/25.
//


import SwiftData
import Foundation

// MARK: - 건물
@Model
class BuildingEntity {
    @Attribute(.unique) var id: String
    var name: String
    var lat: Double
    var lng: Double

    @Relationship(inverse: \RoomEntity.building)
    var rooms: [RoomEntity] = []

    init(id: String, name: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - 강의실
@Model
class RoomEntity {
    @Attribute(.unique) var id: String
    var room: String

    @Relationship(inverse: \ScheduleEntity.room)
    var schedules: [ScheduleEntity] = []

    var building: BuildingEntity?

    init(id: String, room: String, building: BuildingEntity? = nil) {
        self.id = id
        self.room = room
        self.building = building
    }
}

// MARK: - 시간표
@Model
class ScheduleEntity {
    var day: String
    var classes: [String] = []

    var room: RoomEntity?

    init(day: String, classes: [String], room: RoomEntity? = nil) {
        self.day = day
        self.classes = classes
        self.room = room
    }
}

