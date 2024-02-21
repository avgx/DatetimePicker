//
//  DatePicker.swift
//  iPadTesting
//
//  Created by Артём Черныш on 15.02.24.
//

import SwiftUI

struct SelectDatePicker: View {
    let calendarFont: Font?
    let calendarPadding: CGFloat?
    let titleFont: Font?
    
    private let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Binding
    var selection: Date
    
    @Binding
    var selectable: [Date]?

    @State
    var monthToPresent: Date
    
    @State
    var isYearPickerOpened: Bool = false
    
    init(selection: Binding<Date>, selectable: Binding<[Date]?>) {
        self._selectable = selectable
        self._monthToPresent = State(initialValue: selection.wrappedValue)
        self._selection = selection
        calendarPadding = 5
        calendarFont = .title3.bold()
        titleFont = .title2
    }
    
    init(selection: Binding<Date>, selectable: Binding<[Date]?>, calendarFont: Font?, calendarPadding: CGFloat?, titleFont: Font?) {
        self._selectable = selectable
        self._monthToPresent = State(initialValue: selection.wrappedValue)
        self._selection = selection
        self.calendarFont = calendarFont
        self.titleFont = titleFont
        self.calendarPadding = calendarPadding
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
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(titleDate)
                        .font(titleFont)
                        .fontWeight(.semibold)
                }
                Button(action: {
                    withAnimation {
                        isYearPickerOpened.toggle()
                    }
                }, label: {
                    if isYearPickerOpened {
                        Image(systemName: "chevron.down")
                    } else {
                        Image(systemName: "chevron.right")
                    }
                })
                Spacer()
                if !isYearPickerOpened {
                    Button(action: {
                        withAnimation {
                            monthToPresent = Calendar.current.date(byAdding: .month, value: -1, to: monthToPresent) ?? monthToPresent
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(titleFont)
                    })
                    Button(action: {
                        withAnimation {
                            monthToPresent = Calendar.current.date(byAdding: .month, value: 1, to: monthToPresent) ?? monthToPresent
                        }
                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(titleFont)
                    })
                }
            }
            .padding([.horizontal])
            .padding(calendarPadding ?? 0)
            
            if isYearPickerOpened {
                YearPicker(selectable: $selectable, monthToPresent: $monthToPresent)
            } else {
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
                        CardView(value: value)
                            .onTapGesture {
                                value.isSelectable ? selection = value.date : nil
                            }
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
                        .font(calendarFont)
                        .foregroundColor(value.isSelectable ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, calendarPadding ?? 0)
                        .background(
                            Circle()
                                .foregroundStyle(.red)
                                .padding(-5)
                        )
                } else {
                    Text("\(Calendar.current.component(.day, from: value.date))")
                        .font(calendarFont)
                        .foregroundColor(value.isSelectable ? nil : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, calendarPadding ?? 0)
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
