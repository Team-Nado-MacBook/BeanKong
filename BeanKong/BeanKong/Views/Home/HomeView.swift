//
//  HomeView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/25/25.
//

import SwiftUI
import CoreLocation
import SwiftData

struct HomeView: View {
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var showHelp = false
    @State private var selectedDay: String = {
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        let calendar = Calendar.current
        let index = calendar.component(.weekday, from: Date()) - 1
        return weekdays[index]
    }()
    
    @State private var selectedStartTime: String = {
        let now = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        // 30분 단위로 올림
        let roundedMinute = minute < 30 ? 0 : 30
        if roundedMinute == 30 && minute >= 30 {
            // 30분 이상이면 그대로
        } else if roundedMinute == 0 && minute >= 30 {
            hour += 1
        }
        
        return "\(hour):\(roundedMinute == 0 ? "00" : "30")"
    }()
    
    @State private var selectedEndTime: String = "17:30"
    @State private var showStartSheet: Bool = false
    @State private var showEndSheet: Bool = false
    @State private var showDaySheet: Bool = false
    
    @State private var startClass = "1A"
    @State private var endClass = "3B"
    @State private var isLoading = true
    
    // 시작용 시간 리스트
    let startTimeSlots = (9...17).flatMap { hour in
        ["\(hour):00", "\(hour):30"]
    }

    // 끝용 시간 리스트
    let endTimeSlots = (9...18).flatMap { hour in
        ["\(hour):30", "\(hour+1):00"].filter { $0 != "19:00" } // 18:30까지
    }
    
    // 시간 → 교시 변환 함수
    func timeToClass(_ time: String) -> String {
        switch time {
        case "9:00": return "1A"
        case "9:30": return "1B"
        case "10:00": return "2A"
        case "10:30": return "2B"
        case "11:00": return "3A"
        case "11:30": return "3B"
        case "12:00": return "4A"
        case "12:30": return "4B"
        case "13:00": return "5A"
        case "13:30": return "5B"
        case "14:00": return "6A"
        case "14:30": return "6B"
        case "15:00": return "7A"
        case "15:30": return "7B"
        case "16:00": return "8A"
        case "16:30": return "8B"
        case "17:00": return "9A"
        case "17:30": return "9B"
        default: return "1A"
        }
    }
    
    func endTimeToClass(_ time: String) -> String {
        switch time {
        case "9:30": return "1A"
        case "10:00": return "1B"
        case "10:30": return "2A"
        case "11:00": return "2B"
        case "11:30": return "3A"
        case "12:00": return "3B"
        case "12:30": return "4A"
        case "13:00": return "4B"
        case "13:30": return "5A"
        case "14:00": return "5B"
        case "14:30": return "6A"
        case "15:00": return "6B"
        case "15:30": return "7A"
        case "16:00": return "7B"
        case "16:30": return "8A"
        case "17:00": return "8B"
        case "17:30": return "9A"
        case "18:00": return "9B"
        default: return "1A"
        }
    }
    var body: some View {
        NavigationStack {
    
                List() {
                    // 빌딩 리스트
                    Section(header: Text("즐겨찾기")) {
                        FavoriteListView()
                    }
                    
                    Section(header: Text("조건에 맞는 빈강의실"))  {
                        TimeFilterSectionView(
                            selectedStartTime: $selectedStartTime,
                            selectedEndTime: $selectedEndTime,
                            selectedDay: $selectedDay,      // <- 추가
                            showStartSheet: $showStartSheet,
                            showEndSheet: $showEndSheet, showDaySheet: $showDaySheet
                        )
                        BuildingListView(
                            userLocation: userLocation,
                            startClass: startClass,
                            endClass: endClass,
                            selectedDay: selectedDay 
                        )
                    }
                }
                .scrollIndicators(.hidden)
                .background(Color(.secondarySystemBackground))
                .navigationTitle("빈강의실 찾기")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {                        Button("도움말") {
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
            .sheet(isPresented: $showStartSheet) {
                VStack {
                    Text("시작 교시 선택")
                        .font(.headline)
                        .padding(.top)
                    Divider()
                    Picker("시작 시간", selection: $selectedStartTime) {
                        ForEach(startTimeSlots, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 200)
                    .onChange(of: selectedStartTime) { newTime in
                        startClass = timeToClass(newTime)
                    }
                    Spacer()
                }
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showEndSheet) {
                VStack {
                    Text("끝 교시 선택")
                        .font(.headline)
                        .padding(.top)
                    Divider()
                    Picker("끝 시간", selection: $selectedEndTime) {
                        ForEach(endTimeSlots, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 200)
                    .onChange(of: selectedEndTime) { newTime in
                        endClass = endTimeToClass(newTime)
                    }
                    Spacer()
                }
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showDaySheet) {
                VStack {
                    Text("요일 선택")
                        .font(.headline)
                        .padding(.top)
                    Divider()
                    Picker("요일", selection: $selectedDay) {
                        ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                            Text(day).tag(day)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 200)
                    Spacer()
                }
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
            }
            .task {
                await fetchUserLocation()
                try? await Task.sleep(for: .seconds(0.8)) // 로딩 표시용
                isLoading = false
            }
        }
    }
    
    // 위치 가져오기
    func fetchUserLocation() async {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        if let location = manager.location {
            userLocation = location.coordinate
        }
    }
}
#Preview {
    MainTabView()
}
