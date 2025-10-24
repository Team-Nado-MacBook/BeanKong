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
    
    var body: some View {
        NavigationStack {
            List(building.rooms, id: \.id) { room in
                NavigationLink {
                    ScheduleListView(room: room)
                } label: {
                    Text(room.room)
                        .font(.headline)
                }
            }
            .navigationTitle(building.name)
        }
        .presentationBackground(.regularMaterial)
    }
    

}
