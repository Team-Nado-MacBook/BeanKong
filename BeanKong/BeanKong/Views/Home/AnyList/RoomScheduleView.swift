//
//  RoomScheduleView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//


import SwiftUI

struct ScheduleListView: View {
    let room: RoomEntity
    
    var body: some View {
        List {
            ForEach(room.schedules, id: \.day) { schedule in
                Section(header: Text(schedule.day.capitalized)) {
                    Text(schedule.classes.joined(separator: ", "))
                }
            }
        }
        .navigationTitle("Room \(room.room)")
    }
}

