import SwiftUI
import SwiftData

struct ScheduleListView: View {
    let room: RoomEntity
    
    //즐겨찾기 기능 추가
    @Environment(\.modelContext) private var context
    @Query var favorites: [FavoriteRoomEntity]
    
    private let dayOrder = ["mon", "tue", "wen", "thu", "fri", "sat", "sun"]
    
    private var sortedSchedules: [ScheduleEntity] {
        room.schedules.sorted { a, b in
            guard
                let aIndex = dayOrder.firstIndex(of: a.day),
                let bIndex = dayOrder.firstIndex(of: b.day)
            else { return false }
            return aIndex < bIndex
        }
    }
    
    private var isFavorited: Bool {
            favorites.contains { $0.roomID == room.id }
        }
    
    private func toggleFavorite() {
            if let entry = favorites.first(where: { $0.roomID == room.id }) {
                context.delete(entry)
            } else {
                // FavoriteRoomEntity init(roomID:) 호출
                context.insert(FavoriteRoomEntity(roomID: room.id))
            }
        }
    
    var body: some View {
        // 🔹 List 스타일을 .insetGrouped로 변경하면 섹션 구분이 더 예뻐집니다.
        List {
            ForEach(sortedSchedules, id: \.id) { schedule in
                Section(header: Text(dayToKorean(schedule.day))) {
                    if schedule.classes.isEmpty {
                        Text("수업 없음 (전체 사용 가능)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        //새로 호출
                        TimeBarView(occupiedSlots: schedule.classes)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Room \(room.room)")
    }
    
    // ✅ 영어 요일 → 한글 변환 (기존 코드)
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

struct TimeBarView: View {
    
    // ["10A", "10B", "11A"] 같은 사용 중인 슬롯 리스트
    let occupiedSlots: [String]
    
    // 🔹 "빈콩" 색상
    private let beanColor = Color("beanColor")
    // 🔹 비어있는 슬롯 색상
    private let emptyColor = Color(.systemGray5)

    // (시작 시간, 30분 슬롯A, 30분 슬롯B)
    private let fullDaySchedule = [
        (hour: "9",  slotA: "1A",  slotB: "1B"),
        (hour: "10", slotA: "2A",  slotB: "2B"),
        (hour: "11", slotA: "3A",  slotB: "3B"),
        (hour: "12", slotA: "4A",  slotB: "4B"),
        (hour: "13", slotA: "5A",  slotB: "5B"), // 오후 1시
        (hour: "14", slotA: "6A",  slotB: "6B"),
        (hour: "15", slotA: "7A",  slotB: "7B"),
        (hour: "16", slotA: "8A",  slotB: "8B"),
        (hour: "17", slotA: "9A",  slotB: "9B"),
        (hour: "18", slotA: "10A", slotB: "10B"),
        (hour: "19", slotA: "11A", slotB: "11B"),
        (hour: "20", slotA: "12A", slotB: "12B"),
        (hour: "21", slotA: "13A", slotB: "13B")  // 오후 9시
    ]
    
    var body: some View {
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            
            // 1. 타임 바 (A, B 슬롯)
            GridRow {
                ForEach(fullDaySchedule, id: \.hour) { hourData in
                    HStack(spacing: 1) {
                        let isAOccupied = occupiedSlots.contains(hourData.slotA)
                        let isBOccupied = occupiedSlots.contains(hourData.slotB)
                        
                        // A 슬롯 (왼쪽)
                        BarSegment(isOccupied: isAOccupied,
                                   occupiedColor: beanColor,
                                   emptyColor: emptyColor)
                        
                        // B 슬롯 (오른쪽)
                        BarSegment(isOccupied: isBOccupied,
                                   occupiedColor: beanColor,
                                   emptyColor: emptyColor)
                    }
                }
            }
            
            // 2. 시간 라벨 (9, 10, 11...)
            GridRow {
                ForEach(fullDaySchedule, id: \.hour) { hourData in
                    Text(hourData.hour)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading) // 타임 바와 정렬
                }
            }
        }
        .padding(.vertical, 8) // 위아래로 약간의 여백
    }
}

//30분 간격 조각
struct BarSegment: View {
    let isOccupied: Bool
    let occupiedColor: Color
    let emptyColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(isOccupied ? occupiedColor : emptyColor)
            .frame(height: 40) // 콩 모양 바의 높이
    }
}
