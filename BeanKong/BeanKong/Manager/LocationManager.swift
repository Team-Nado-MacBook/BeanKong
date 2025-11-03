//
//  LocationManager.swift
//  BeanKong
//
//  Created by 문재윤 on 11/2/25.
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