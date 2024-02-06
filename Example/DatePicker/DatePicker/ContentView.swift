//
//  ContentView.swift
//  DatePicker
//
//  Created by Артём Черныш on 1.02.24.
//

import SwiftUI
import DatetimePicker

struct ContentView: View {
    
    @State
    var selection: Date = Date()
    
    @State
    var selectable: [Date]? = [Date().addingTimeInterval(-TimeInterval(3600*144)), Date(), Date().addingTimeInterval(-TimeInterval(3600*24)), Date().addingTimeInterval(+TimeInterval(3600*24))]
    
    var body: some View {
        Group {
            VStack {

                Text("Select datetime")
                    .font(.title)
                
                Divider()
                Text("buildin")
                    .font(.footnote)
                
                
                DatePicker("From",
                           selection: .constant(Date()),
                           in: (Date().addingTimeInterval(-TimeInterval(3600*24*7)) ...  Date()))
                
                Divider()
                Text("open dialog on tap")
                    .font(.footnote)
                
                DatetimePicker(
                    selection: $selection,
                    selectable: $selectable,
                    action: { dt in print("\(dt)") }
                )
            }
        }
        .preferredColorScheme(.dark)
        .accentColor(.orange)
    //    .environment(\.layoutDirection, .rightToLeft)
    //    .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.locale, Locale(identifier: "en"))
    }
}

#Preview {
    ContentView()
}
