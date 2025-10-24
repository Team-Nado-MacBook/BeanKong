//
//  RoomListView 2.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//

import SwiftUI
import CoreLocation
import SwiftData

struct BuildingListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \BuildingEntity.name, order: .forward) var buildings: [BuildingEntity]
    
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var navigateToTimetable = false
    @State private var showHelp = false
    
    var body: some View {
        NavigationStack {
            List {

                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("시간표 보기 / 추가")
                                .font(.title3.bold())
                            Text("내 시간표 관리 페이지로 이동")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .onTapGesture {
                        navigateToTimetable = true
                    }
                    .background(
                        NavigationLink("", destination: DetailMapView(), isActive: $navigateToTimetable)
                            .hidden()
                    )
                }
                

                Section("건물 목록") {
                    ForEach(sortedBuildings(), id: \.id) { building in
                        NavigationLink {
                            RoomListView(building: building)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(building.name)
                                    .font(.headline)
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
            }
            .navigationTitle("빈 강의실")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("시간표 수정") {
                            navigateToTimetable = true
                        }
                        Button("도움말") {
                            showHelp.toggle()
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showHelp) {
                            VStack {
                                Text("도움말 내용")
                                    .font(.title2.bold())
                                    .padding()
                                Spacer()
                                Button("닫기") { showHelp = false }
                                    .padding()
                            }
                        }
            .task {
                await fetchUserLocation()
            }
        }
    }
    
    
    // 거리계산
    func distanceInMeters(to building: BuildingEntity, from userLoc: CLLocationCoordinate2D) -> Double {
        let user = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let buildingLoc = CLLocation(latitude: building.lat, longitude: building.lng)
        return user.distance(from: buildingLoc)
    }
    // 거리순 정렬
    func sortedBuildings() -> [BuildingEntity] {
        guard let userLocation = userLocation else { return buildings }
        return buildings.sorted {
            distanceInMeters(to: $0, from: userLocation) < distanceInMeters(to: $1, from: userLocation)
        }
    }
    
    // 사용자 현재 위치 받아오기
    func fetchUserLocation() async {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        if let location = manager.location {
            userLocation = location.coordinate
        }
    }
}

