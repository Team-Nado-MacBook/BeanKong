//
//  MapDetailView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/25/25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct MapRoomListView: View {
    let building: BuildingEntity
    
    // MARK: - 현재 요일 가져오기
    private var currentDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE" // Mon, Tue, ...
        return formatter.string(from: Date()).lowercased()
    }
    
    // MARK: - 교시 리스트 (09:00~18:00, A/B 30분)
    private let classSlots = ["1A","1B","2A","2B","3A","3B","4A","4B","5A","5B","6A","6B","7A","7B","8A","8B","9A","9B"]
    
    // MARK: - 현재 교시 계산
    private var currentClassIndex: Int {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        let totalMinutes = (hour - 9) * 60 + minute
        let index = max(0, totalMinutes / 30)
        return min(index, classSlots.count - 1)
    }
    
    // MARK: - 현재 교시 이후 사용 가능 시간 계산
    private func maxAvailableHoursFromNow(for room: RoomEntity) -> Double {
        let todaySchedules = room.schedules.first(where: { $0.day == currentDay })?.classes ?? []
        let remainingSlots = classSlots[currentClassIndex...]
        let availableCount = remainingSlots.filter { !todaySchedules.contains($0) }.count
        return Double(availableCount) * 0.5
    }
    
    // MARK: - 현재 사용 가능 여부
    private func isRoomAvailableNow(_ room: RoomEntity) -> Bool {
        let todaySchedules = room.schedules.first(where: { $0.day == currentDay })?.classes ?? []
        return !todaySchedules.contains(classSlots[currentClassIndex])
    }
    var body: some View {
        VStack(spacing: 8) {
            Text(building.name)
                .font(.title2.bold())
                .padding(.top)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 6) {
                    ForEach(building.rooms, id: \.id) { room in
                        HStack {
                            Text(room.room)
                                .font(.headline)
                            
                            Spacer()
                            
                            let hours = maxAvailableHoursFromNow(for: room)
                            if isRoomAvailableNow(room) && hours > 0 {
                                VStack(alignment: .trailing) {
                                    Text("사용 가능")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                    Text("지금부터 \(hours, specifier: "%.1f")시간 사용 가능")
                                        .foregroundColor(.green)
                                        .font(.caption2)
                                }
                            } else {
                                VStack(alignment: .trailing) {
                                    Text("사용 중")
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                    Text("지금부터 0시간")
                                        .foregroundColor(.gray)
                                        .font(.caption2)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(.white)
                        )

                    }
                }
                .padding(.horizontal)
            }
        }
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
    }
}
