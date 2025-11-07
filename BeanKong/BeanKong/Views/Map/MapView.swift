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

struct MapView: View {
    @Query(sort: \BuildingEntity.name) private var buildings: [BuildingEntity]
    @StateObject private var locationManager = LocationManager()
    @State private var isSatellite = false
    @State private var selectedDetent: PresentationDetent = .fraction(0.5)
    @State private var selectedBuilding: BuildingEntity? = nil

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
                .tint(.red)
                .tag(building)
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
                        //시트높이 설정
                        .presentationDetents(
                            [
                                .fraction(0.3),
                                .fraction(0.5),
                                .fraction(0.9)
                            ],
                            selection: $selectedDetent
                        )
            }
    }
}
