import SwiftUI
import CoreLocation
import SwiftData

struct BuildingListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \BuildingEntity.name, order: .forward) var buildings: [BuildingEntity]
    
    var userLocation: CLLocationCoordinate2D?
    var startClass: String
    var endClass: String

    let classSlots = ["1A","1B","2A","2B","3A","3B","4A","4B","5A","5B","6A","6B","7A","7B","8A","8B","9A","9B"]
    
    var body: some View {
        ForEach(sortedBuildings(), id: \.id) { building in
            NavigationLink {
                RoomListView(building: building)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(building.name)
                            .font(.headline)
                        Spacer()
                        Text("사용 가능 \(availableRoomsCount(for: building))개")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    
                    if let userLocation = userLocation {
                        let distance = distanceInMeters(to: building, from: userLocation)
                        Text("(\(Int(distance))m)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("위치 불러오는 중...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }

    // MARK: 거리 계산
    func distanceInMeters(to building: BuildingEntity, from userLoc: CLLocationCoordinate2D) -> Double {
        let user = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let buildingLoc = CLLocation(latitude: building.lat, longitude: building.lng)
        return user.distance(from: buildingLoc)
    }

    // MARK: 거리순 정렬
    func sortedBuildings() -> [BuildingEntity] {
        guard let userLocation = userLocation else { return buildings }
        return buildings.sorted {
            distanceInMeters(to: $0, from: userLocation) < distanceInMeters(to: $1, from: userLocation)
        }
    }

    // MARK: 빈 강의실 계산
    func availableRoomsCount(for building: BuildingEntity) -> Int {
        let today = currentDayKey()
        return building.rooms.filter { room in
            guard let schedule = room.schedules.first(where: { $0.day == today }) else {
                return true
            }
            return !schedule.classes.contains { cls in
                isOverlap(classTime: cls)
            }
        }.count
    }

    // MARK: 겹치는 교시 판별
    func isOverlap(classTime: String) -> Bool {
        guard
            let startIndex = classSlots.firstIndex(of: startClass),
            let endIndex = classSlots.firstIndex(of: endClass),
            let targetIndex = classSlots.firstIndex(of: classTime)
        else { return false }

        return targetIndex >= startIndex && targetIndex <= endIndex
    }

    // MARK: 오늘 요일 문자열 변환
    func currentDayKey() -> String {
        let weekdays = ["sun","mon","tue","wed","thu","fri","sat"]
        let weekday = Calendar.current.component(.weekday, from: Date())
        return weekdays[weekday - 1]
    }
}
