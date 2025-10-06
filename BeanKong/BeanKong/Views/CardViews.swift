//
//  CardViews.swift
//  beanKong
//
//  Created by 백주은 on 10/6/25.
//

import SwiftUI


struct CardViews: View {
var icon: String
var titleTop: String
var titleBottom: String
var showsPlug: Bool = false


var body: some View {
HStack(alignment: .top, spacing: 10) {
Image(systemName: icon)
.font(.title3)
.frame(width: 44, height: 44)


VStack(alignment: .leading, spacing: 6) {
Text(titleTop)
.font(.caption)
.foregroundColor(.black.opacity(0.6))


HStack(alignment: .center, spacing: 6) {
Text(titleBottom)
.font(.subheadline)
.fontWeight(.semibold)
.lineLimit(2)


if showsPlug {
Image(systemName: "plug.fill")
.foregroundColor(.green)
}
}
}


Spacer(minLength: 0)
}
.padding(12)
.background(Color.white)
.cornerRadius(14)
.shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)
.frame(minWidth: 0, maxWidth: .infinity)
}
}

