import SwiftUI
import SwiftData
import MapKit

struct RoomListView: View {
    @Environment(\.modelContext) private var context
    let building: BuildingEntity
    let selectedDay: String
    let startClass: String
    let endClass: String


    @Query var favorites: [FavoriteRoomEntity]

    private let classSlots = [
        "1A","1B","2A","2B","3A","3B","4A","4B",
        "5A","5B","6A","6B","7A","7B","8A","8B",
        "9A","9B","10A","10B","11A","11B","12A","12B"
    ]

    private var dayKey: String {
        switch selectedDay {
        // 🔹 (수정) 'return' 키워드 추가
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
        guard let s = classSlots.firstIndex(of: startClass),
              let e = classSlots.firstIndex(of: endClass),
              let t = classSlots.firstIndex(of: classTime) else { return false }
        return t >= s && t <= e
    }

    private func isAvailable(room: RoomEntity) -> Bool {
        let today = room.schedules
            .filter { $0.day == dayKey }
            .flatMap { $0.classes }

        guard !today.isEmpty else { return true }
        return !today.contains { isOverlap(classTime: $0) }
    }

    private func toggleFavorite(room: RoomEntity) {
        if let entry = favorites.first(where: { $0.roomID == room.id }) {
            context.delete(entry)
        } else {
            // 🔹 FavoriteRoomEntity init(roomID:) 호출 (favoritedAt은 기본값 사용)
            context.insert(FavoriteRoomEntity(roomID: room.id))
        }
    }

    private func isFavorited(room: RoomEntity) -> Bool {
        favorites.contains { $0.roomID == room.id }
    }

    var body: some View {
        List() {

//                Map(
//                    coordinateRegion: .constant(
//                        MKCoordinateRegion(
//                            center: CLLocationCoordinate2D(latitude: building.lat, longitude: building.lng),
//                            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//                        )
//                    ),
//                    annotationItems: [building]
//                ) { b in
//                    MapMarker(
//                        coordinate: CLLocationCoordinate2D(latitude: b.lat, longitude: b.lng),
//                        tint: .red
//                    )
//                }
//                .frame(height: 150)
//                .cornerRadius(8)
//                .listRowBackground(Color.clear)
            
            Section {
                ForEach(building.rooms.sorted(by: { $0.room < $1.room }), id: \.id) { room in
                    
                    
                    
                    NavigationLink(destination: ScheduleListView(room: room)) {
                        HStack {
                            Text(room.room)
                                .font(.headline)
                            
                            if (isFavorited(room: room)) {
                                Image(systemName:"star.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.footnote)
                                
                            }
                            Spacer()
                            
                            
                            //                    Image(systemName: "circle.fill")
                            //                        .foregroundColor(isAvailable(room: room) ? .green : .red)
                            //                        .font(.caption)
                            //                    Text(isAvailable(room: room) ? "사용 가능" : "사용 중")
                            //                        .font(.footnote)
                            //                        .foregroundColor(isAvailable(room: room) ? .green : .red)
                            HStack {
                                Spacer()
//                                Text(isAvailable(room: room) ? "사용 가능" : "사용 중")
//                                    .font(.footnote)
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.white)
//                                    .padding(.vertical, 4)
//                                    .frame(width: 70) // 👈 가로 길이 고정 (적당히 깔끔한 폭)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(isAvailable(room: room) ? Color.green : Color.red)
//                                    )
                                Circle()
                                    .fill(isAvailable(room: room) ? Color.green : Color.red)
                                    .frame(width: 15, height: 15)
                            }
                            
                            
                        }
                        .padding(.vertical, 6)
                    }
                    // 🔹 row를 길게 누르면(contextMenu) 즐겨찾기 메뉴가 나옵니다.
                    .contextMenu {
                        if isFavorited(room: room) {
                            Button {
                                toggleFavorite(room: room)
                            } label: {
                                Label("즐겨찾기 제거", systemImage: "star.slash.fill")
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
            }
        }
        .navigationTitle(building.name)
    }
}
