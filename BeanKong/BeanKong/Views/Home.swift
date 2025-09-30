//
//  Home.swift
//  BeanKong
//
//  Created by 문재윤 on 9/30/25.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationView {
            List(1...50, id: \.self) { index in
                Text("아이템 \(index)")
            }
            .navigationTitle("홈")
        }

        
    }
}



#Preview {
    HomeView()
}
