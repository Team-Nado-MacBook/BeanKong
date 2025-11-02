//
//  HeaderView.swift
//  BeanKong
//
//  Created by 백주은 on 10/6/25.
//


import SwiftUI

struct HeaderView: View {
    var hasTimetable: Bool = false  // 시간표 여부 변수
    
    var body: some View {
        if hasTimetable {
            // 시간표가 있을 때
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.00, green: 0.78, blue: 0.68),
                                Color(red: 0.95, green: 0.73, blue: 0.90)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 190)
                    .padding(.horizontal, 16)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("2025년 2학기")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.85))
                    
                    HStack(spacing: 12) {
                        CardViews(icon: "doc.text", titleTop: "다음 강의", titleBottom: "자료구조")
                        CardViews(icon: "person.2.fill", titleTop: "다음 강의까지 비어있는", titleBottom: "it-5 융복합관 345", showsPlug: true)
                    }
                }
                .padding(.leading, 36)
                .padding(.trailing, 46)
                .padding(.top, 18)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 42, height: 42)
                    .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                    .offset(x: -26, y: 12)
            }
        } else {
            // 시간표가 없을 때
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                Text("시간표를 입력하세요")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)
            )
            .padding(.horizontal, 16)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
