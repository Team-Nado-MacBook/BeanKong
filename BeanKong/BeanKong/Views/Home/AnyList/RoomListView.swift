//
//  BuildingListView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//

//
//import SwiftUI
//import SwiftData
//
//
//struct RoomListView: View {
//    @Environment(\.modelContext) private var context
//    let building: BuildingEntity
//    
//    let selectedDay: String
//    let startClass: String
//    let endClass: String
//
//    private let classSlots = ["1A","1B","2A","2B","3A","3B","4A","4B","5A","5B","6A","6B","7A","7B","8A","8B","9A","9B"]
//
//    private var dayKey: String {
//        switch selectedDay {
//        case "일": return "sun"
//        case "월": return "mon"
//        case "화": return "tue"
//        case "수": return "wed"
//        case "목": return "thu"
//        case "금": return "fri"
//        case "토": return "sat"
//        default: return "mon"
//        }
//    }
//
//    private func isOverlap(classTime: String) -> Bool {
//        guard
//            let startIndex = classSlots.firstIndex(of: startClass),
//            let endIndex = classSlots.firstIndex(of: endClass),
//            let targetIndex = classSlots.firstIndex(of: classTime)
//        else { return false }
//
//        return targetIndex >= startIndex && targetIndex <= endIndex
//    }
//
//    // 선택한 시간대에 비어있는 방만
//    private var availableRooms: [RoomEntity] {
//        building.rooms.filter { room in
//            guard let schedule = room.schedules.first(where: { $0.day == dayKey }) else {
//                return true
//            }
//            return !schedule.classes.contains { cls in
//                isOverlap(classTime: cls)
//            }
//        }
//    }
//
//    private func maxAvailableHours(for room: RoomEntity) -> Double {
//        let todaySchedules = room.schedules.first(where: { $0.day == dayKey })?.classes ?? []
//        let busyCount = todaySchedules.count
//        let totalSlots = classSlots.count
//        let availableSlots = totalSlots - busyCount
//        return Double(availableSlots) * 0.5
//    }
//
//    var body: some View {
//        NavigationStack {
//            List(availableRooms, id: \.id) { room in
//                NavigationLink {
//                    ScheduleListView(room: room)
//                } label: {
//                    HStack {
//                        Text(room.room)
//                            .font(.headline)
//                        Spacer()
//                        Text("최대 \(maxAvailableHours(for: room), specifier: "%.1f")시간")
//                            .foregroundColor(.green)
//                            .font(.caption2)
//                    }
//                    .padding(.vertical, 6)
//                }
//            }
//            .navigationTitle(building.name)
//        }
//        .presentationBackground(.regularMaterial)
//    }
//}
import SwiftUI
import SwiftData

struct RoomListView: View {
    @Environment(\.modelContext) private var context
    let building: BuildingEntity
    
    let selectedDay: String
    let startClass: String
    let endClass: String

    private let classSlots = [
        "1A","1B","2A","2B","3A","3B","4A","4B",
        "5A","5B","6A","6B","7A","7B","8A","8B",
        "9A","9B","10A","10B","11A","11B","12A","12B"
    ]

    private var dayKey: String {
        switch selectedDay {
        case "일": return "sun"
        case "월": return "mon"
        case "화": return "tue"
        case "수": return "wed"
        case "목": return "thu"
        case "금": return "fri"
        case "토": return "sat"
        default: return "mon"
        }
    }

    private func isOverlap(classTime: String) -> Bool {
        guard
            let startIndex = classSlots.firstIndex(of: startClass),
            let endIndex = classSlots.firstIndex(of: endClass),
            let targetIndex = classSlots.firstIndex(of: classTime)
        else { return false }
        return targetIndex >= startIndex && targetIndex <= endIndex
    }

    private func isAvailable(room: RoomEntity) -> Bool {
        let todayClasses = room.schedules
            .filter { $0.day == dayKey }
            .flatMap { $0.classes }

        print("🧩 \(room.room): \(todayClasses)")
        print("🕒 \(startClass) ~ \(endClass)")

        guard !todayClasses.isEmpty else { return true }

        return !todayClasses.contains { cls in
            isOverlap(classTime: cls)
        }
    }

    var body: some View {
        NavigationStack {
            List(building.rooms, id: \.id) { room in
                NavigationLink(destination: ScheduleListView(room: room)) {
                    HStack {
                        Text(room.room)
                            .font(.headline)
                        
                        Spacer()
                        
                        if isAvailable(room: room) {
                            Text("✅ 사용 가능")
                                .foregroundColor(.green)
                                .font(.caption)
                        } else {
                            Text("❌ 사용 중")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle(building.name)
        }
        .presentationBackground(.regularMaterial)
    }
}
