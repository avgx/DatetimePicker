//
//  YearPicker.swift
//  iPadTesting
//
//  Created by Артём Черныш on 15.02.24.
//

import SwiftUI

struct YearPicker: View {
    
    @Binding
    var selectable: [Date]?
    
    @Binding
    var monthToPresent: Date

    @State
    var selectedYear: YearMonth
    
    var pickableLiat: [YearMonth] {
        get {
            var arr = Set<YearMonth>()
            for date in selectable ?? [] {
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                arr.insert(YearMonth(year: year, month: month))
            }
            return arr.sorted(by: { ($0.month < $1.month && $0.year == $1.year) || $0.year < $1.year })
        }
    }
    
    init(selectable: Binding<[Date]?>, monthToPresent: Binding<Date>) {
        self._selectable = selectable
        self._monthToPresent = monthToPresent
        let year = Calendar.current.component(.month, from: monthToPresent.wrappedValue) - 1
        let month = Calendar.current.component(.year, from: monthToPresent.wrappedValue)
        self._selectedYear = State(initialValue: YearMonth(year: year, month: month))
    }
    
    var body: some View {
        HStack {
            Picker("Years and months", selection: $selectedYear) {
                ForEach(pickableLiat, id: \.self) { date in
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Text("\(date.year.description) \(Calendar.current.monthSymbols[date.month - 1])")
                        Spacer()
                    }
                    .tag(date as YearMonth)
                }
            }
            .pickerStyle(.wheel)
        }
        .onChange(of: selectedYear) { newDate in
            let month = Calendar.current.component(.month, from: monthToPresent)
            monthToPresent = Calendar.current.date(byAdding: .month, value: newDate.month - month, to: monthToPresent) ?? Date()
            let year = Calendar.current.component(.year, from: monthToPresent)
            monthToPresent = Calendar.current.date(byAdding: .year, value: newDate.year - year, to: monthToPresent) ?? Date()
        }
    }
    
    struct YearMonth: Hashable {
        var year: Int
        var month: Int
    }
}
