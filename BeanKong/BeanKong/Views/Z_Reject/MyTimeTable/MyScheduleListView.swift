//
//  MyScheduleListView.swift
//  BeanKong
//
//  Created by 문재윤 on 11/1/25.
//

import SwiftUI
import SwiftData

struct MyScheduleListView: View {
    @Query(sort: \MyScheduleEntity.subject) var mySchedules: [MyScheduleEntity]
    @Environment(\.modelContext) private var context
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mySchedules) { schedule in
                    VStack(alignment: .leading) {
                        Text(schedule.subject)
                            .font(.headline)
                        Text("\(schedule.building) / \(schedule.room)")
                            .font(.subheadline)
                        if !schedule.schedules.isEmpty {
                            Text("🕒 " + schedule.schedules.map { "\($0.day) \($0.timeSlots.joined(separator: ", "))" }.joined(separator: " | "))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(mySchedules[index])
                    }
                    try? context.save()
                }
            }
            .navigationTitle("내 시간표")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddClassToMyScheduleView()
                    .environment(\.modelContext, context)
            }
        }
    }
}
