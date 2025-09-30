//
//  ContentView.swift
//  BeanKong
//
//  Created by 문재윤 on 9/30/25.
//

import SwiftUI


struct MainTabView: View {
    var body: some View {
        @State var searchText = ""
        TabView {
            Tab("홈", systemImage: "house.fill") {
                HomeView()
            }
            Tab("지도", systemImage: "map.fill") {
                DetailMapView()
            }
            // 시간표 수정아닐때 빈강의실 찾기
            if ( 1+1 == 3) {
                
                Tab("Four", systemImage: "magnifyingglass", role: .search) {
                    NavigationStack {
                        
                    }
                }
            }
            // 시간표 수정일때 강의 검색하기
            if ( 1+1 == 2) {
                
                Tab("Four", systemImage: "magnifyingglass", role: .search) {
                    NavigationStack {
                        
                    }
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
        .searchable(text: $searchText)
        
        
    }
}
    

#Preview {
    MainTabView()
}
