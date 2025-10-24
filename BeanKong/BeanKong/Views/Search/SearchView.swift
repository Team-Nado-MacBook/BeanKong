//
//  SearchView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//
import SwiftUI
import SwiftData

struct SearchView: View {
    @Binding var searchText: String
    let buildings: [BuildingEntity]
    
    var filteredBuildings: [BuildingEntity] {
        buildings.filter { building in
            searchText.isEmpty ||
            building.name.localizedCaseInsensitiveContains(searchText) ||
            building.rooms.contains(where: { $0.room.localizedCaseInsensitiveContains(searchText) })
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredBuildings, id: \.id) { building in
                Section(header: Text(building.name)) {
                    // roomsToShow를 미리 계산
                    let roomsToShow = searchText.isEmpty || building.name.localizedCaseInsensitiveContains(searchText)
                        ? building.rooms
                        : building.rooms.filter { $0.room.localizedCaseInsensitiveContains(searchText) }

                    ForEach(roomsToShow, id: \.id) { room in
                        NavigationLink(destination: ScheduleListView(room: room)) {
                            Text("Room \(room.room)")
                        }
                    }
                }
            }
        }
        .navigationTitle("검색")
        .searchable(text: $searchText, prompt: "건물명 또는 호실 검색")
        .listStyle(.insetGrouped)
    }
}
