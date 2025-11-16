import SwiftUI
import CoreLocation
import SwiftData

struct BuildingListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \BuildingEntity.name, order: .forward) var buildings: [BuildingEntity]
    
    var userLocation: CLLocationCoordinate2D?
    var startClass: String
    var endClass: String
    var selectedDay: String

    // 🔹 표준 교시 슬롯 (순서 중요!)
    let classSlots = [
        "1A","1B","2A","2B","3A","3B","4A","4B",
        "5A","5B","6A","6B","7A","7B","8A","8B","9A","9B",
        "10A","10B","11A","11B","12A","12B"
    ]

    var body: some View {
        ForEach(filteredBuildings(), id: \.id) { building in
            NavigationLink {
                RoomListView(
                    building: building,
                    selectedDay: selectedDay,
                    startClass: startClass,
                    endClass: endClass
                )
            } label: {
                
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(building.name)
                                .font(.headline)
                            if let userLocation = userLocation {
                                let distance = distanceInMeters(to: building, from: userLocation)
                                Text("(\(Int(distance))m)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
//                        Image(systemName: "circle.fill")
//                            .foregroundColor(.green)
//                            .font(.caption)
//                        Text("\(availableRoomsCount(for: building)) 사용가능")
//                            .font(.footnote)
//                            .foregroundColor(.green)
                        HStack(spacing: 4) {
                            let count = availableRoomsCount(for: building)

                            Text("\(count)")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 22, height: 22)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .fill(count == 0 ? Color.red : Color.green)
                                )
                            
                        }
                        
                    }
                    
                                    
//                .padding(.vertical, 6)
            }
        }
    }

    // ✅ 특정 요일 + 시간대 기준으로 빈 강의실 있는 빌딩만 표시
    func filteredBuildings() -> [BuildingEntity] {
        sortedBuildings().filter { building in
            availableRoomsCount(for: building) > 0
        }
    }

    // ✅ 사용 가능한 강의실 수 계산
    func availableRoomsCount(for building: BuildingEntity) -> Int {
        let dayKey = convertDayToEng(selectedDay)
        return building.rooms.filter { room in
            let todayClasses = room.schedules
                .filter { $0.day == dayKey }
                .flatMap { $0.classes }

            guard !todayClasses.isEmpty else { return true }

            // 선택 구간과 겹치면 사용 불가
            return !todayClasses.contains { cls in
                isOverlap(classTime: cls)
            }
        }.count
    }

    // ✅ 요일 변환
    func convertDayToEng(_ day: String) -> String {
        switch day {
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

    // ✅ 교시 겹침 판별
    func isOverlap(classTime: String) -> Bool {
        guard
            let startIndex = classSlots.firstIndex(of: startClass),
            let endIndex = classSlots.firstIndex(of: endClass),
            let targetIndex = classSlots.firstIndex(of: classTime)
        else { return false }

        return targetIndex >= startIndex && targetIndex <= endIndex
    }

    // ✅ 거리 정렬 유지
    func sortedBuildings() -> [BuildingEntity] {
        guard let userLocation = userLocation else { return buildings }
        return buildings.sorted {
            distanceInMeters(to: $0, from: userLocation) < distanceInMeters(to: $1, from: userLocation)
        }
    }

    func distanceInMeters(to building: BuildingEntity, from userLoc: CLLocationCoordinate2D) -> Double {
        let user = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let buildingLoc = CLLocation(latitude: building.lat, longitude: building.lng)
        return user.distance(from: buildingLoc)
    }
}
