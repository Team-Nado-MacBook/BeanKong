//
//  MyTimeTable.swift
//  BeanKong
//
//  Created by 문재윤 on 10/25/25.
//
import SwiftUI

struct MyTimeTableView: View {
    var body: some View {
        HStack {
            // 왼쪽: 시간표 추가 안내
            NavigationLink(destination: MyScheduleListView()) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("시간표 보기 / 추가")
                        .font(.title3.bold())
                    Text("내 시간표 관리 페이지로 이동")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider() // 좌우 구분선
            
            // 오른쪽: 강의실 추천 안내
            VStack(alignment: .leading, spacing: 6) {
                Text("다음 강의실 추천을 받으려면")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("시간표를 추가하세요")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

    }
}
