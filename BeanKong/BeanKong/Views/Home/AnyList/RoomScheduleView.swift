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
        List {
            ForEach(sortedSchedules, id: \.id) { schedule in
                Section(header: Text(dayToKorean(schedule.day))) {
                    
                    TimeBarView(
                        occupiedSlots: schedule.classes.isEmpty ? [] : schedule.classes,
                        scheduleDay: schedule.day
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
        // 👇 [수정됨] 1. 제목을 "빌딩이름 방번호" 형식으로 변경
        .navigationTitle("\(room.building?.name ?? "빌딩") - \(room.room)")
        // 👇 [수정됨] 3. 즐겨찾기 버튼 툴바 추가
        .toolbar {
            Button {
                toggleFavorite() // 버튼을 누르면 토글 함수 실행
            } label: {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .foregroundStyle(isFavorited ? .yellow : .gray)
            }
        }
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
    
    let occupiedSlots: [String]
    let scheduleDay: String // 👈 1. 오늘 요일인지 비교하기 위해 받음
    
    // 🔹 "빈콩" 색상
    private let beanColor = Color(.systemGray5)
    // 🔹 비어있는 슬롯 색상
    private let emptyColor = Color("beanColor")

    // 👈 2. [테스트 용] 현재 시간을 '월요일 오전 10시 15분'으로 고정 (테스트 끝나면 원복)
    private var now: Date {
            let calendar = Calendar.current
            let fakeDateComponents = DateComponents(year: 2025, month: 11, day: 10, hour: 10, minute: 15)
            return calendar.date(from: fakeDateComponents)!
        }
    // private let now = Date() // 👈 [원래 코드] 테스트 끝나면 이걸로 복구

    
    /// 캘린더에서 오늘의 요일 키(예: "mon", "tue")를 반환합니다.
    private var todayKey: String {
        let calendar = Calendar.current
        let index = calendar.component(.weekday, from: now) // 1=일, 2=월, 3=화...
        switch index {
            case 1: return "sun"
            case 2: return "mon"
            case 3: return "tue"
            case 4: return "wen"
            case 5: return "thu"
            case 6: return "fri"
            case 7: return "sat"
            default: return ""
        }
    }
    
    /// 지금 보고있는 스케줄이 오늘 요일인지 확인
    private var isToday: Bool {
        scheduleDay == todayKey
    }

    // (시작 시간, 30분 슬롯A, 30분 슬롯B)
    private let fullDaySchedule = [
        (hour: "9",  slotA: "1A",  slotB: "1B"),
        (hour: "10", slotA: "2A",  slotB: "2B"),
        (hour: "11", slotA: "3A",  slotB: "3B"),
        (hour: "12", slotA: "4A",  slotB: "4B"),
        (hour: "13", slotA: "5A",  slotB: "5B"),
        (hour: "14", slotA: "6A",  slotB: "6B"),
        (hour: "15", slotA: "7A",  slotB: "7B"),
        (hour: "16", slotA: "8A",  slotB: "8B"),
        (hour: "17", slotA: "9A",  slotB: "9B"),
        (hour: "18", slotA: "10A", slotB: "10B"),
        (hour: "19", slotA: "11A", slotB: "11B"),
        (hour: "20", slotA: "12A", slotB: "12B"),
        (hour: "21", slotA: "13A", slotB: "13B")
    ]
    
    /// 👈 3. 현재 시간(빨간 줄)의 가로(x) 위치를 계산하는 함수
    private func getRedLineOffset(gridWidth: CGFloat) -> CGFloat? {
        // (함수 내용은 수정 없음)
        guard isToday else { return nil }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        let minutesFrom9AM = (hour - 9) * 60 + minute
        
        let totalDurationInMinutes = 13 * 60
        
        guard minutesFrom9AM >= 0 && minutesFrom9AM <= totalDurationInMinutes else {
            return nil
        }
        
        let percentage = CGFloat(minutesFrom9AM) / CGFloat(totalDurationInMinutes)
        return percentage * gridWidth
    }
    
    var body: some View {
        // 👈 4. Grid를 .overlay로 감싸서 빨간 줄을 겹칠 수 있게 함
        Grid(horizontalSpacing: 4, verticalSpacing: 4) {
            
            // (GridRow 내용은 수정 없음)
            GridRow {
                ForEach(fullDaySchedule, id: \.hour) { hourData in
                    HStack(spacing: 1) {
                        let isAOccupied = occupiedSlots.contains(hourData.slotA)
                        let isBOccupied = occupiedSlots.contains(hourData.slotB)
                        
                        BarSegment(isOccupied: isAOccupied,
                                   occupiedColor: beanColor,
                                   emptyColor: emptyColor)
                        
                        BarSegment(isOccupied: isBOccupied,
                                   occupiedColor: beanColor,
                                   emptyColor: emptyColor)
                    }
                }
            }
            
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
        .overlay(
            // 👈 5. GeometryReader로 Grid의 가로폭을 얻어와서...
            GeometryReader { geometry in
                // 👈 6. 빨간 줄의 위치(offset)를 계산합니다.
                if let offset = getRedLineOffset(gridWidth: geometry.size.width) {
                    
                    let triangleWidth: CGFloat = 12
                    let triangleHeight: CGFloat = 8
                        
                    Group{
                        // 👈 7. 빨간 줄(Rectangle)을 그립니다.
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 1) // 선 두께
                            .frame(height: 40) // 콩 모양 바 높이(BarSegment의 높이)
                            .offset(y: 8) // Grid의 vertical padding(8)만큼 내려서 바와 정렬
                        
                        Path { path in
                            path.move(to: CGPoint(x: -triangleWidth / 2, y: 0)) // 상단 왼쪽
                            path.addLine(to: CGPoint(x: triangleWidth / 2, y: 0)) // 상단 오른쪽
                            path.addLine(to: CGPoint(x: 0, y: triangleHeight)) // 하단 중앙 (뾰족한 부분)
                            path.closeSubpath()
                        }
                        .fill(Color.red)
                        .offset(y:8)
                    }
                    .offset(x:offset)
                }
            }
        )
    }
}
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
