//
//  BuildingListView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//


import SwiftUI
import SwiftData

struct RoomListView: View {
    @Environment(\.modelContext) private var context
    let building: BuildingEntity
    
    // MARK: - 현재 요일 가져오기
    private var currentDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE" // ex) Mon, Tue, Wed...
        return formatter.string(from: Date()).lowercased()
    }
    // MARK: - 교시 리스트 (09:00~18:00, A/B 30분)
    private let classSlots = ["1A","1B","2A","2B","3A","3B","4A","4B","5A","5B","6A","6B","7A","7B","8A","8B","9A","9B"]
    
    // MARK: - 현재 교시 계산 (간단히 예시용)
    private var currentClass: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 9..<10: return "1A"
        case 10..<11: return "1B"
        case 11..<12: return "2A"
        case 12..<13: return "2B"
        case 13..<14: return "3A"
        case 14..<15: return "3B"
        case 15..<16: return "4A"
        case 16..<17: return "4B"
        case 17..<18: return "5A"
        case 18..<19: return "5B"
        default: return "none"
        }
    }
    
    // MARK: - 현재 사용 가능 여부 계산
    private func isRoomAvailable(_ room: RoomEntity) -> Bool {
        guard let schedule = room.schedules.first(where: { $0.day == currentDay }) else {
            return true // 스케줄 없으면 항상 가능
        }
        return !schedule.classes.contains(currentClass)
    }
    // MARK: - 최대 사용 가능 시간 계산
    private func maxAvailableHours(for room: RoomEntity) -> Double {
        let todaySchedules = room.schedules.first(where: { $0.day == currentDay })?.classes ?? []
        let busyCount = todaySchedules.count
        let totalSlots = classSlots.count
        let availableSlots = totalSlots - busyCount
        return Double(availableSlots) * 0.5
    }
    
    var body: some View {
        NavigationStack {
            List(building.rooms, id: \.id) { room in
                NavigationLink {
                    ScheduleListView(room: room)
                } label: {
                    HStack {
                        Text(room.room)
                            .font(.headline)
                        
                        Spacer()
                        
                        // ✅ 현재 수업 상태
                        if isRoomAvailable(room) {
                            VStack(alignment: .trailing) {
                                Text("사용 가능")
                                    .foregroundColor(.green)
                                    .font(.subheadline)
                                Text("최대 \(maxAvailableHours(for: room), specifier: "%.1f")시간")
                                    .foregroundColor(.green)
                                    .font(.caption2)
                            }
                        } else {
                            VStack(alignment: .trailing) {
                                Text("사용 중")
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                Text("최대 \(maxAvailableHours(for: room), specifier: "%.1f")시간")
                                    .foregroundColor(.gray)
                                    .font(.caption2)
                            }
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
