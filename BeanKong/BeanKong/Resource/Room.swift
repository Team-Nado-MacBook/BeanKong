////
////  Room.swift
////  BeanKong
////
////  Created by 문재윤 on 10/24/25.
////
//import SwiftUI
//import MapKit
//
//struct Building: Identifiable, Codable, Hashable {
//    // name을 id로 사용
//    var id: String { name }
//    let name: String
//    let lat: Double
//    let lng: Double
//    let rooms: [Room]
//    
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: lat, longitude: lng)
//    }
//}
//
//struct Room: Identifiable, Codable, Hashable {
//    // room 번호를 id로 사용
//    var id: String { room }
////    let room: String
//    let mon, tue, wen, thu, fri, sat: [String]?
//}
// 
//func loadBuildings() -> [Building] {
//    guard let url = Bundle.main.url(forResource: "merged_buildings", withExtension: "json"),
//          let data = try? Data(contentsOf: url) else {
//        return []
//    }
//    
//    do {
//        let buildings = try JSONDecoder().decode([Building].self, from: data)
//        for b in buildings {
//            print(b.name, b.coordinate)
//        }
//        return buildings
//    } catch {
//        print("JSON 디코딩 실패: \(error)")
//        return []
//    }
//}
