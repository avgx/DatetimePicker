//
//  DatePicker.swift
//
//
//  Created by Артём Черныш on 6.02.24.
//

import SwiftUI

struct SelectDatePicker: View {
    private let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Binding
    var selection: Date
    
    @Binding
    var selectable: [Date]?

    @State
    var monthToPresent: Date
    
    init(selection: Binding<Date>, selectable: Binding<[Date]?>) {
        self._selectable = selectable
        self._monthToPresent = State(initialValue: selection.wrappedValue)
        self._selection = selection
    }
    
    private var titleDate: String {
        get {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: monthToPresent) - 1
            let year = calendar.component(.year, from: monthToPresent)
            return calendar.monthSymbols[month] + " \(year)"
        }
    }
    
    private var extraxtedDate: [DateValue] {
        get {
            let calendar = Calendar.current
            let currentMonth = calendar.date(byAdding: .month, value: 0, to: monthToPresent)
            var days = currentMonth?.getAllDates().compactMap { date -> DateValue in
                let dateDay = Calendar.current.component(.day, from: date)
                let dateMonth = Calendar.current.component(.month, from: date)
                let dateYear = Calendar.current.component(.year, from: date)
                for select in selectable ?? [] {
                    let selectDay = Calendar.current.component(.day, from: select)
                    let selectMonth = Calendar.current.component(.month, from: select)
                    let selectYear = Calendar.current.component(.year, from: select)
                    if selectDay == dateDay && dateMonth == selectMonth && dateYear == selectYear {
                        return DateValue(date: date, isVisible: true, isSelectable: true)
                    }
                }
                return DateValue(date: date, isVisible: true, isSelectable: false)
            }
            let firstWeekday = calendar.component(.weekday, from: days?.first?.date ?? Date())
            if firstWeekday != 1 {
                for _ in 0..<firstWeekday - 2 {
                    days?.insert(DateValue(date: Date(), isVisible: false, isSelectable: false), at: 0)
                }
            }
            return days ?? []
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(titleDate)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        monthToPresent = Calendar.current.date(byAdding: .month, value: -1, to: monthToPresent) ?? monthToPresent
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                Button(action: {
                    withAnimation {
                        monthToPresent = Calendar.current.date(byAdding: .month, value: 1, to: monthToPresent) ?? monthToPresent
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                })
            }
            .padding(.horizontal)
            
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(extraxtedDate) { value in
                    if value.isSelectable {
                        CardView(value: value)
                            .onTapGesture {
                                selection = value.date
                            }
                    } else {
                        CardView(value: value)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.isVisible {
                if Calendar.current.isDate(value.date, inSameDayAs: selection) {
                    Text("\(Calendar.current.component(.day, from: value.date))")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .background(
                            Circle()
                                .fill(Color.red)
                        )
                } else {
                    Text("\(Calendar.current.component(.day, from: value.date))")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
            }
        }
    }
    
    struct DateValue: Identifiable {
        var id = UUID()
        var date: Date
        var isVisible: Bool
        var isSelectable: Bool
    }
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? Date()
        let range = calendar.range(of: .day, in: .month, for: startDate) ?? 0..<1
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
        }
    }
}
