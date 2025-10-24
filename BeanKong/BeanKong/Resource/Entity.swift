//
//  BuildingEntity.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//


import SwiftData
import Foundation

@Model
class BuildingEntity {
    @Attribute(.unique) var id: String      // JSON name
    var name: String
    var lat: Double
    var lng: Double
    var rooms: [RoomEntity] = []
    
    init(id: String, name: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}

@Model
class RoomEntity {
    @Attribute(.unique) var id: String      // JSON room
    var room: String
    var schedules: [ScheduleEntity] = []
    var building: BuildingEntity
    
    init(id: String, room: String, building: BuildingEntity) {
        self.id = id
        self.room = room
        self.building = building
    }
}

@Model
class ScheduleEntity {
    var day: String    // "mon", "tue", ...
    var classes: [String]
    var room: RoomEntity
    
    init(day: String, classes: [String], room: RoomEntity) {
        self.day = day
        self.classes = classes
        self.room = room
    }
}
