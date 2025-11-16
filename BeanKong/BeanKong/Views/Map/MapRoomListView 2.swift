//
//  MapRoomListView 2.swift
//  BeanKong
//
//  Created by 문재윤 on 11/7/25.
//


import SwiftUI
import SwiftData

struct MapRoomListView: View {
    @Environment(\.modelContext) private var context
    let building: BuildingEntity
    
    // 🔹 즐겨찾기 관리를 위해 @Query 추가
    @Query var favorites: [FavoriteRoomEntity]

    var body: some View {
        NavigationStack {
            List(building.rooms.sorted(by: { $0.room < $1.room }), id: \.id) { room in
                NavigationLink(destination: ScheduleListView(room: room)) {
                    HStack {
                        Text(room.room)
                            .font(.headline)
                        Spacer()
                        // 🔹 즐겨찾기 여부만 별로 표시
                        Image(systemName: isFavorited(room: room) ? "star.fill" : "")
                            .foregroundColor(isFavorited(room: room) ? .yellow : .primary)
                    }
                }
                .contextMenu {
                    if isFavorited(room: room) {
                        Button {
                            toggleFavorite(room: room)
                        } label: {
                            Label("즐겨찾기 제거", systemImage: "star.slash")
                        }
                    } else {
                        Button {
                            toggleFavorite(room: room)
                        } label: {
                            Label("즐겨찾기 추가", systemImage: "star")
                        }
                    }
                }
            }
            .navigationTitle(building.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - 즐겨찾기 헬퍼 함수 (RoomListView와 동일)
    
    private func toggleFavorite(room: RoomEntity) {
        if let entry = favorites.first(where: { $0.roomID == room.id }) {
            context.delete(entry)
        } else {
            context.insert(FavoriteRoomEntity(roomID: room.id))
        }
    }

    private func isFavorited(room: RoomEntity) -> Bool {
        favorites.contains { $0.roomID == room.id }
    }
}
