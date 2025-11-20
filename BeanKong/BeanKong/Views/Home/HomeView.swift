//
//  HomeView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/25/25.
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
                    
                    Section(header: Text("조건에 맞는 빈강의실"))  {
                        TimeFilterSectionView(
                            selectedStartTime: $selectedStartTime,
                            selectedEndTime: $selectedEndTime,
                            selectedDay: $selectedDay,      // <- 추가
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

                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 2) {
                            Text("BeanKong")
                                .font(.headline) // 메인 제목
                            Text("나만을 위한 빈 강의실 찾기")
                                .font(.caption2) // 부제목
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("도움말") {
                                showHelp.toggle()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                        }
                    }
                    
                }
            
            // MARK: - 도움말 Sheet (개선된 부분)
            .sheet(isPresented: $showHelp) {
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // 제목 및 서론
                            VStack(alignment: .leading, spacing: 5) {
                                Text("📚 빈콩(BeanKong) 도움말 📚")
                                    .font(.title.bold())
                                    .padding(.bottom, 5)
                                Text("환영합니다! **빈콩(BeanKong)**은 사용자님의 시간을 절약하고 학습 효율을 높여줄 수 있는, **'나만을 위한 빈 강의실 찾기'** 서비스입니다. 캠퍼스 내 원하는 시간대에 비어있는 강의실을 빠르고 정확하게 찾아보세요.")
                                    .font(.callout)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            // 주요 기능 요약
                            VStack(alignment: .leading, spacing: 10) {
                                Text("🔍 주요 기능 요약")
                                    .font(.title2.bold())
                                
                                // 기능 1
                                Text("**시간/요일 필터링**")
                                    .font(.headline)
                                Text("원하는 **요일**, **시작 시간**, **종료 시간**을 설정하여 그 시간대에 강의가 없는 빈 강의실만 필터링하여 조회합니다.")
                                    .padding(.leading, 10)
                                
                                // 기능 2
                                Text("**교시(교시) 자동 변환**")
                                    .font(.headline)
                                Text("사용자가 설정한 시간을 30분 단위의 **교시** (예: 9:00은 `1A`, 17:30은 `9B` 등)로 자동으로 변환하여 정확한 공강 여부를 확인합니다.")
                                    .padding(.leading, 10)
                                
                                // 기능 3
                                Text("**현재 위치 기반 정렬**")
                                    .font(.headline)
                                Text("사용자님의 현재 위치를 기준으로 가장 **가까운 빌딩** 순서대로 빈 강의실 목록을 정렬하여 보여줍니다. (정확한 서비스 이용을 위해 위치 정보 사용에 동의해주세요.)")
                                    .padding(.leading, 10)
                                
                                // 기능 4
                                Text("**즐겨찾기**")
                                    .font(.headline)
                                Text("자주 찾는 강의실 또는 빌딩을 즐겨찾기에 등록하여 메인 화면 상단에서 빠르게 접근할 수 있습니다.")
                                    .padding(.leading, 10)
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            // 사용 방법
                            VStack(alignment: .leading, spacing: 10) {
                                Text("🛠️ 사용 방법")
                                    .font(.title2.bold())
                                
                                Text("1. **요일 및 시간 설정**: 메인 화면의 '조건에 맞는 빈강의실' 섹션에서 **요일**, **시작 시간**, **종료 시간**을 각각 탭하여 원하는 조건을 설정하세요.")
                                    .font(.callout)
                                Text("2. **빈 강의실 목록 확인**: 설정한 조건에 부합하는 빈 강의실을 보유한 **빌딩 목록**이 하단에 현재 위치 기준 가까운 순서로 정렬되어 표시됩니다.")
                                    .font(.callout)
                                Text("3. **상세 정보**: 빌딩을 탭하면 해당 빌딩 내의 층별 빈 강의실 목록을 확인할 수 있습니다.")
                                    .font(.callout)
                            }
                            .padding(.horizontal)
                            
                            Divider()
                            
                            // 기타 안내
                            VStack(alignment: .leading, spacing: 10) {
                                Text("❓ 기타 안내")
                                    .font(.title2.bold())
                                
                                Text("앱 이용 중 불편한 점이나 제안 사항이 있다면 언제든지 문의해 주세요. 빈콩은 더 나은 서비스를 제공하기 위해 지속적으로 노력하겠습니다.")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)
                            
                            Spacer().frame(height: 30) // 바닥 여백
                            
                        }
                        .padding(.top, 20)
                    }
                    .navigationTitle("도움말")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("닫기") { showHelp = false }
                        }
                    }
                }
            } // MARK: - 도움말 Sheet 끝
            
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
                    }                       .pickerStyle(.wheel)
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
