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
        @Query(sort: \BuildingEntity.name, order: .forward) private var buildings: [BuildingEntity] // 여기서 가져오기
        @State private var searchText = ""
        
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house.fill") {
                if buildings.isEmpty {
                    EmptyDataView(context: context)
                } else {
                    BuildingListView()
                }
            }
            
            Tab("지도", systemImage: "map.fill") {
                DetailMapView()
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
    
//
//#Preview {
//    MainTabView()
//}
