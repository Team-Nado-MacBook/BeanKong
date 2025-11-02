//
//  Map.swift
//  BeanKong
//
//  Created by 문재윤 on 9/30/25.
//
import SwiftUI
import MapKit
import CoreLocation
import Combine
import SwiftData

@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.9, longitude: 128.6),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    private var hasSetInitialPosition = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        // 최초 1회만 위치 업데이트
        guard !hasSetInitialPosition else { return }
        
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: lastLocation.coordinate,
                distance: 2000,
                heading: 0,
                pitch: 45
            )
        )
        
        hasSetInitialPosition = true
    }
}
struct MapView: View {
    @Query(sort: \BuildingEntity.name) private var buildings: [BuildingEntity]
    @StateObject private var locationManager = LocationManager()
    @State private var isSatellite = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.5)
    // ✅ selection 바인딩에 사용할 상태 변수!
    @State private var selectedBuilding: BuildingEntity? = nil
    // @State private var isSheetPresented = false  <-- ❌ 이건 이제 필요 없어!

    var selectedMapStyle: MapStyle {
        isSatellite
            ? .hybrid(elevation: .realistic)
            : .standard(elevation: .realistic)
    }

    var body: some View {
        Map(position: $locationManager.cameraPosition, selection: $selectedBuilding) {
            ForEach(buildings) { building in
                Marker(building.name,
                       systemImage: "building.2.fill",
                       coordinate: CLLocationCoordinate2D(latitude: building.lat, longitude: building.lng))
                .tint(.blue)
                .tag(building) // ✅ 각 마커에 'tag' 추가! (building 객체 자체를 태그로)
            }
        }
        .mapStyle(selectedMapStyle)
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }

        .sheet(item: $selectedBuilding) { building in
                MapRoomListView(building: building)
                        // ✅ 2. 시트가 멈출 높이들(detents) 설정!
                        .presentationDetents(
                            [
                                .fraction(0.3), // 30% 높이
                                .fraction(0.5), // 50% 높이
                                .fraction(0.9)  // 70% 높이
                            ],
                            selection: $selectedDetent // ✅ 현재 높이를 이 변수와 연결!
                        )
            }
    }
}
