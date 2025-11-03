//
//  CategoryView.swift
//  BeanKong
//
//  Created by 백주은 on 10/6/25.
//

import SwiftUI

struct CategoryView: View {
    // 시작 시간
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedAMPM: String = "AM"
    
    // 사용 시간 (분 단위)
    @State private var usageDuration: Int = 0
    
    // 콘센트
    @State private var hasOutlet: Bool = false
    
    // Bottom Sheet 표시 상태
    @State private var showingStartTimePicker = false
    @State private var showingDurationPicker = false
    
    //입력 여부 상태
    @State private var isStartTime: Bool = false
    @State private var isDurationTime: Bool = false
    
    let hours = Array(0...12)
    let minutes = stride(from: 0, to: 60, by: 10).map { $0 }
    let ampm = ["AM", "PM"]
    //let durations = stride(from: 0, through: 24*60, by: 10).map { $0 }
    let durations = stride(from: 0, to: 60*24, by: 10).map { $0 }
    
    var body: some View {
        HStack(spacing: 16) {
            // 시작 시간 버튼
            Button(action: { showingStartTimePicker.toggle() }) {
                let hoursPart = selectedHour
                let minutesPart = selectedMinute % 60
                let ampmPart = selectedAMPM
                
                if !isStartTime {
                    Text("시작 시간")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                } else {
                    Text(hoursPart > 0 ? "\(hoursPart): \(minutesPart) \(ampmPart)"  : "\(minutesPart)m \(ampmPart)")
                    
                
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            
            // 사용 시간 버튼
            Button(action: { showingDurationPicker = true }) {
                let hoursPart = usageDuration / 60
                let minutesPart = usageDuration % 60
                if !isDurationTime {
                    Text("시작 시간")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                } else {
                    Text(hoursPart > 0 ? "\(hoursPart)시간 \(minutesPart)분" : "\(minutesPart)분")
                
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            
            // 콘센트 버튼
            Button(action: { hasOutlet.toggle() }) {
                Text("콘센트")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(hasOutlet ? Color.green : Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(hasOutlet ? .white : .primary)
            }
        }
        .padding()
        
        // 시작 시간 Picker Bottom Sheet
        .sheet(isPresented: $showingStartTimePicker) {
            VStack {
                Text("시작 시간 선택")
                    .font(.headline)
                    .padding()
                
                HStack(spacing: 0) {
                    Picker("", selection: $selectedHour) {
                        ForEach(hours, id: \.self) { Text("\($0)시") }
                    }.pickerStyle(.wheel)
                    
                    Picker("", selection: $selectedMinute) {
                        ForEach(minutes, id: \.self) { Text("\($0)분") }
                    }.pickerStyle(.wheel)
                    
                    Picker("", selection: $selectedAMPM) {
                        ForEach(ampm, id: \.self) { Text($0) }
                    }.pickerStyle(.wheel)
                }
                .frame(height: 50)
                
                Button("완료") { showingStartTimePicker = false
                isStartTime = true}
                    .padding()
            }
            .presentationDetents([.fraction(0.5)])
        }
        // 사용 시간 Picker Bottom Sheet
        .sheet(isPresented: $showingDurationPicker) {
            VStack {
                Text("사용 시간 선택")
                    .font(.headline)
                    .padding()
                
                Picker("", selection: $usageDuration) {
                    ForEach(durations, id: \.self) { minutes in
                        let hoursPart = minutes / 60
                        let minutesPart = minutes % 60
                        Text(hoursPart > 0 ? "\(hoursPart)시간 \(minutesPart)분" : "\(minutesPart)분")
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
                
                Button("완료") { showingDurationPicker = false
                isDurationTime = true}
                    .padding()
            }
            .presentationDetents([.fraction(0.5)])

        }
    }
}
