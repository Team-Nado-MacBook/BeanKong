//
//  BuildingJSON.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//


import SwiftUI
import SwiftData

struct BuildingJSON: Codable {
    let name: String
    let lat: Double
    let lng: Double
    let rooms: [RoomJSON]
}
struct RoomJSON: Codable {
    let room: String
    let mon, tue, wen, thu, fri, sat: [String]?
}



// JSON → SwiftData 저장
func saveJSONToSwiftData(context: ModelContext, url: URL) {
    guard let data = try? Data(contentsOf: url) else { return }
    do {
        let jsonBuildings = try JSONDecoder().decode([BuildingJSON].self, from: data)
        for b in jsonBuildings {
            let buildingEntity = BuildingEntity(id: b.name, name: b.name, lat: b.lat, lng: b.lng)
            for r in b.rooms {
                let roomEntity = RoomEntity(id: "\(b.name)-\(r.room)", room: r.room, building: buildingEntity)
                if let mon = r.mon { roomEntity.schedules.append(ScheduleEntity(day: "mon", classes: mon, room: roomEntity)) }
                if let tue = r.tue { roomEntity.schedules.append(ScheduleEntity(day: "tue", classes: tue, room: roomEntity)) }
                if let wen = r.wen { roomEntity.schedules.append(ScheduleEntity(day: "wen", classes: wen, room: roomEntity)) }
                if let thu = r.thu { roomEntity.schedules.append(ScheduleEntity(day: "thu", classes: thu, room: roomEntity)) }
                if let fri = r.fri { roomEntity.schedules.append(ScheduleEntity(day: "fri", classes: fri, room: roomEntity)) }
                if let sat = r.sat { roomEntity.schedules.append(ScheduleEntity(day: "sat", classes: sat, room: roomEntity)) }
                buildingEntity.rooms.append(roomEntity)
            }
            context.insert(buildingEntity)
        }
        try context.save()
        print("✅ JSON 데이터를 SwiftData에 저장 완료")
    } catch {
        print("❌ JSON 디코딩 또는 저장 실패: \(error)")
    }
}




struct ClassJSON: Decodable {
    let subject: String
    let class_id: String
    let building: String
    let room: String
    let schedule: [ScheduleJSON]
}

struct ScheduleJSON: Decodable {
    let day: String
    let time: [String]
}

func saveClassesJSONToSwiftData(context: ModelContext, url: URL) {
    guard let data = try? Data(contentsOf: url) else {
        print("❌ JSON 파일을 읽을 수 없음: \(url)")
        return
    }
    
    do {
        let jsonClasses = try JSONDecoder().decode([ClassJSON].self, from: data)
        print("📂 JSON 디코딩 완료: \(jsonClasses.count)개의 수업 발견")
        
        for (index, c) in jsonClasses.enumerated() {
            // 1️⃣ ClassEntity 생성 & context에 추가
            let classEntity = ClassEntity(
                classId: c.class_id,
                subject: c.subject,
                building: c.building,
                room: c.room
            )
            context.insert(classEntity)
            print("✅ [\(index+1)/\(jsonClasses.count)] ClassEntity 삽입: \(classEntity.subject) (\(classEntity.building)/\(classEntity.room))")
            
            // 2️⃣ Schedule 생성, 관계 연결 후 context에 추가
            for s in c.schedule {
                let scheduleEntity = ClassSchedule(day: s.day, timeSlots: s.time)
                scheduleEntity.classEntity = classEntity
                classEntity.schedules.append(scheduleEntity)
                context.insert(scheduleEntity)
                print("   🕒 Schedule 삽입: \(s.day) \(s.time.joined(separator: ", "))")
            }
        }
        
        // 3️⃣ Context 저장
        try context.save()
        print("🎉 SwiftData 저장 완료!")
        
    } catch {
        print("❌ JSON 디코딩/저장 실패: \(error)")
    }
}
