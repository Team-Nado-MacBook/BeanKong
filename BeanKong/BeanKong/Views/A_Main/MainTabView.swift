//
//  ContentView.swift
//  BeanKong
//
//  Created by 문재윤 on 9/30/25.
//

import SwiftUI
import SwiftData


struct MainTabView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \BuildingEntity.name, order: .forward) private var buildings: [BuildingEntity]
       
       // 수업 조회
       @Query(sort: \ClassEntity.subject, order: .forward) private var classes: [ClassEntity]
       
       @State private var searchText = ""
       
        
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house.fill") {
                            VStack {
                                if buildings.isEmpty {
                                    Text("🚫 빌딩 데이터 없음")
                                    EmptyDataView(context: context)
                                } else {
//                                    Text("✅ 빌딩 데이터 있음: \(buildings.count)개")
                                }
                                
                                if classes.isEmpty {
                                    Text("🚫 수업 데이터 없음")
                                    EmptyDataView(context: context)
                                } else {
//                                    Text("✅ 수업 데이터 있음: \(classes.count)개")
                                }
                                
                                if !buildings.isEmpty {
                                    HomeView()
                                }
                            }
                        }
            
            Tab("지도", systemImage: "map.fill") {
                MapView()
            }
            
            Tab("검색", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    SearchView(searchText: $searchText, buildings: buildings)
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
        //        .searchable(text: $searchText)
    }
        
    
}
    

#Preview {
    MainTabView()
}
