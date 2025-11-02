////
////  Time_filter.swift
////  BeanKong
////
////  Created by 문재윤 on 10/25/25.



import SwiftUI

struct TimeFilterSectionView: View {
    @Binding var selectedStartTime: String
    @Binding var selectedEndTime: String
    @Binding var selectedDay: String  
    @Binding var showStartSheet: Bool
    @Binding var showEndSheet: Bool
    @Binding var showDaySheet: Bool

    var body: some View {
        HStack(spacing: 4) {
            
            Text("\(selectedDay)요일 ")
                .font(.subheadline.bold())
                .foregroundColor(.blue)
                .onTapGesture {
                    showDaySheet = true
                }
            

            // 2. 시작 시간 (파란색, 탭 가능)
            Text(selectedStartTime)
                .font(.subheadline.bold())
                .foregroundColor(.blue)
                .onTapGesture {
                    showStartSheet = true
                }

            // 3. "부터" (일반 텍스트)
            Text("부터")
                .font(.subheadline)
                .foregroundColor(.primary)

            // 4. 끝 시간 (파란색, 탭 가능)
            Text(selectedEndTime)
                .font(.subheadline.bold())
                .foregroundColor(.blue)
                .onTapGesture {
                    showEndSheet = true
                }

            // 5. "까지 빈강의실" (일반 텍스트)
            Text("까지 빈강의실")
                .font(.subheadline)
                .foregroundColor(.primary)
        }

    }
}
#Preview {
    MainTabView()
}
