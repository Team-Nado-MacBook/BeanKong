////
////  Home.swift
////  BeanKong
////
////  Created by 문재윤 on 9/30/25.
////
//
//import SwiftUI
//
//struct HomeView: View {
//
//    var body: some View {
//        NavigationView {
//            ZStack{
//                Color(UIColor.systemGray6).ignoresSafeArea()
//                
//                ScrollView {
//                    VStack(spacing: 12) {
//                        HeaderView()
//                        CategoryView()
//                        
//                        // 빈 강의실 카드들
//                        ForEach(1...50, id: \.self) { index in
//                            RoundedRectangle(cornerRadius: 14, style: .continuous)
//                                .fill(Color.white)
//                                .frame(height: 64)
//                                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)
//                                .overlay(
//                                    HStack {
//                                        Text("빈 강의실 \(index)")
//                                            .font(.headline)
//                                            .foregroundColor(.black)
//                                        Spacer()
//                                        Image(systemName: "chevron.right")
//                                            .foregroundColor(.gray)
//                                    }
//                                        .padding(.horizontal, 16)
//                                )
//                                .padding(.horizontal)
//                        }}
//                                   }
//                .padding(.top, 10)
//            }
//            .navigationTitle("BeanKong")
//            .navigationSubtitle(Text("Home"))
//            
////            .toolbar {
////                ToolbarItem(placement: .principal) {
////                    VStack {
////                        Text("BeanKong").font(.headline)
////                        Text("Home").font(.subheadline).foregroundColor(.gray)
////                    }
////                }
////            }
//
//        }
//
//    }
//}
//
//#Preview {
//    HomeView()
//}
