//
//  RoomScheduleView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//


import SwiftUI

struct ScheduleListView: View {
    let room: RoomEntity
    
    // ✅ 요일 순서 정의
    private let dayOrder = ["mon", "tue", "wen", "thu", "fri", "sat", "sun"]
    
    // ✅ 정렬된 스케줄
    private var sortedSchedules: [ScheduleEntity] {
        room.schedules.sorted { a, b in
            guard
                let aIndex = dayOrder.firstIndex(of: a.day),
                let bIndex = dayOrder.firstIndex(of: b.day)
            else { return false }
            return aIndex < bIndex
        }
    }
    
    var body: some View {
        List {
            ForEach(sortedSchedules, id: \.id) { schedule in
                Section(header: Text(dayToKorean(schedule.day))) {
                    if schedule.classes.isEmpty {
                        Text("수업 없음")
                            .foregroundColor(.gray)
                    } else {
                        Text(schedule.classes.joined(separator: ", "))
                    }
                }
            }
        }
        .navigationTitle("Room \(room.room)")
    }
    
    // ✅ 영어 요일 → 한글 변환
    private func dayToKorean(_ day: String) -> String {
        switch day {
        case "mon": return "월요일"
        case "tue": return "화요일"
        case "wen": return "수요일"
        case "thu": return "목요일"
        case "fri": return "금요일"
        case "sat": return "토요일"
        case "sun": return "일요일"
        default: return day
        }
    }
}
