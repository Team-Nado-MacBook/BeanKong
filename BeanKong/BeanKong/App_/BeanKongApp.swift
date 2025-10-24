//
//  BeanKongApp.swift
//  BeanKong
//
//  Created by 문재윤 on 9/30/25.
//

//import SwiftUI
//import SwiftData
//
//@main
//struct BeanKongApp: App {
//    var body: some Scene {
//        WindowGroup {
//            MainTabView()
//
//        }
//
//    }
//}
import SwiftUI
import SwiftData

@main
struct BeanKongApp: App {
    @State private var container: ModelContainer
    
    init() {
        let schema = Schema([BuildingEntity.self, RoomEntity.self, ScheduleEntity.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {

                MainTabView()
                    .modelContainer(container)

        }
    }
}
