//
//  EmptyDataView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//

import SwiftUI
import SwiftData

struct EmptyDataView: View {
    let context: ModelContext
    let classURL = Bundle.main.url(forResource: "classes", withExtension: "json")
    var body: some View {
        VStack(spacing: 20) {
            Text("📦 데이터가 없습니다!")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Text("초기 데이터를 로드하려면 아래 버튼을 눌러주세요.")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: loadInitialData) {
                Text("데이터 불러오기")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            loadInitialData()
        }
    }
    
    private func loadInitialData() {
//        // 1️⃣ 빌딩+강의실 JSON 저장
        if let buildingURL = Bundle.main.url(forResource: "merged_buildings", withExtension: "json") {
            saveJSONToSwiftData(context: context, url: buildingURL)
        } else {
            print("❌ merged_buildings.json 파일을 찾을 수 없음")
        }
        
        // 2️⃣ 수업 JSON 저장
        if let classURL = Bundle.main.url(forResource: "classes", withExtension: "json") {
            print("제발 좀 되라 시발")
            saveClassesJSONToSwiftData(context: context, url: classURL)
            print("왜 안되냐 시발")
        } else {
            print("❌ classes.json 파일을 찾을 수 없음")
        }
    }
}
