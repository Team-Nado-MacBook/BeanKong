//
//  Map.swift
//  BeanKong
//
//  Created by 문재윤 on 9/30/25.
//
import SwiftUI
import MapKit

struct DetailMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("지도")
        }
    }
}

#Preview {
    DetailMapView()
}
