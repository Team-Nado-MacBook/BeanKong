//
//  EmptyDataView.swift
//  BeanKong
//
//  Created by 문재윤 on 10/24/25.
//

import SwiftUI
import SwiftData

struct EmptyDataView: View {
    @Query private var buildings: [BuildingEntity]   // ✅ SwiftData에 저장된 데이터 확인용
    let context: ModelContext

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
            // ✅ SwiftData에 이미 빌딩이 있으면 실행 안 함
            if buildings.isEmpty {
                print("🧩 데이터가 비어있음 → 초기 로드 실행")
                loadInitialData()
            } else {
                print("✅ 데이터가 이미 존재함 → 초기 로드 생략")
            }
        }
    }
    
    private func loadInitialData() {
        guard buildings.isEmpty else {
            print("⚠️ 이미 데이터가 존재함 — 저장 안 함")
            return
        }

        // 1️⃣ 빌딩+강의실 JSON 저장
        if let buildingURL = Bundle.main.url(forResource: "merged_buildings", withExtension: "json") {
            saveJSONToSwiftData(context: context, url: buildingURL)
        } else {
            print("❌ merged_buildings.json 파일을 찾을 수 없음")
        }
        
        // 2️⃣ 수업 JSON 저장
        if let classURL = Bundle.main.url(forResource: "classes", withExtension: "json") {
            print("📘 수업 데이터 로드 시작")
            saveClassesJSONToSwiftData(context: context, url: classURL)
            print("📗 수업 데이터 로드 완료")
        } else {
            print("❌ classes.json 파일을 찾을 수 없음")
        }

        print("✅ 초기 데이터 저장 완료")
    }
}
