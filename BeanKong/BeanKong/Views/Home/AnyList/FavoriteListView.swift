//
//  FavoriteListView.swift
//  BeanKong
//
//  Created by 문재윤 on 11/7/25.
//


import SwiftUI
import SwiftData

struct FavoriteListView: View {
    @Environment(\.modelContext) private var context
    
    // 🔹 즐겨찾기 목록을 가져옵니다 (최신순 정렬)
    @Query(sort: \FavoriteRoomEntity.favoritedAt, order: .reverse)
    var favorites: [FavoriteRoomEntity]
    
    // 🔹 즐겨찾기 ID와 매칭할 전체 강의실 목록
    @Query var allRooms: [RoomEntity]

    var body: some View {
        if favorites.isEmpty {

                Text("강의실을 꾹 눌러서 추가해보세요!")
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity, alignment: .center)

        } else {
            ForEach(favorites) { favorite in
                // 1. favorites 배열(roomID만 있음)을 순회하며
                // 2. allRooms 배열에서 ID가 일치하는 실제 room 객체를 찾습니다.
                if let room = findRoom(by: favorite.roomID) {
                    
                    // 3. 찾은 room 객체로 NavigationLink를 만듭니다.
                    NavigationLink(destination: ScheduleListView(room: room)) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName:"star.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.footnote)
                                Text(room.room) // 예: "401호"
                                    .font(.headline)
                                
                            }
                            Text(room.building?.name ?? "빌딩 정보 없음") // 예: "공학관"
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                    .contextMenu {
                        // 4. 길게 누르면 즐겨찾기 제거
                        Button(role: .destructive) {
                            removeFavorite(favorite: favorite)
                        } label: {
                            Label("즐겨찾기 제거", systemImage: "star.slash.fill")
                        }
                    }
                    
                } else {
                    // 5. (예외 처리) 즐겨찾기엔 있지만 RoomDB에 없는 경우
                    HStack {
                        Text("삭제된 강의실 (ID: \(favorite.roomID))")
                            .font(.caption)
                            .foregroundStyle(.red)
                        Spacer()
                        Button(role: .destructive) {
                            removeFavorite(favorite: favorite)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

 

    // 🔹 ID로 RoomEntity를 찾는 헬퍼 함수
    private func findRoom(by id: String) -> RoomEntity? {
        return allRooms.first { $0.id == id }
    }
    
    // 🔹 즐겨찾기 항목을 삭제하는 헬퍼 함수
    private func removeFavorite(favorite: FavoriteRoomEntity) {
        context.delete(favorite)
    }
}

#Preview {
    // A sample preview setup (requires a populated ModelContainer)
    FavoriteListView()
        .modelContainer(for: [FavoriteRoomEntity.self, RoomEntity.self])
}
