//
//  AddClassToMyScheduleView.swift
//  BeanKong
//
//  Created by 문재윤 on 11/1/25.
//
import SwiftUI
import SwiftData

struct AddClassToMyScheduleView: View {
    @Query(sort: \ClassEntity.subject) var allClasses: [ClassEntity]
    @Query var mySchedules: [MyScheduleEntity] // 현재 내 시간표
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var filteredClasses: [ClassEntity] {
        if searchText.isEmpty { return allClasses }
        return allClasses.filter {
            $0.subject.localizedCaseInsensitiveContains(searchText) ||
            $0.building.localizedCaseInsensitiveContains(searchText) ||
            $0.room.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredClasses) { classEntity in
                HStack {
                    // 왼쪽 버튼 영역
                    VStack(spacing: 8) {
                        Button(action: {
                            // 이미 추가된 수업인지 체크
                            if mySchedules.contains(where: { $0.classId == classEntity.classId }) {
                                alertMessage = "⚠️ 이미 내 시간표에 추가된 수업입니다."
                                showAlert = true
                                return
                            }
                            
                            let mySchedule = MyScheduleEntity(classEntity: classEntity)
                            context.insert(mySchedule)
                            try? context.save()
                            alertMessage = "✅ 수업 추가됨: \(classEntity.subject)"
                            showAlert = true
                        }) {
                            Label("추가", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        
                        Button(action: {
                            // 상세보기 Alert
                            var scheduleText = ""
                            if !classEntity.schedules.isEmpty {
                                scheduleText = classEntity.schedules.map { "\($0.day) \($0.timeSlots.joined(separator: ", "))" }.joined(separator: "\n")
                            } else {
                                scheduleText = "시간표 없음"
                            }
                            
                            alertMessage = """
                            과목: \(classEntity.subject)
                            건물/강의실: \(classEntity.building)/\(classEntity.room)
                            시간표:
                            \(scheduleText)
                            """
                            showAlert = true
                        }) {
                            Label("상세", systemImage: "info.circle")
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                    }
                    
                    // 수업 정보
                    VStack(alignment: .leading, spacing: 4) {
                        Text(classEntity.subject)
                            .font(.headline)
                        Text("\(classEntity.building) / \(classEntity.room)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if !classEntity.schedules.isEmpty {
                            Text("🕒 " + classEntity.schedules.map { "\($0.day) \($0.timeSlots.joined(separator: ", "))" }.joined(separator: " | "))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            .searchable(text: $searchText, prompt: "수업 검색")
            .navigationTitle("수업 선택")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") { dismiss() }
                }
            }
            .alert("알림", isPresented: $showAlert, actions: {
                Button("확인", role: .cancel) {}
            }, message: {
                Text(alertMessage)
            })
        }
    }
}
