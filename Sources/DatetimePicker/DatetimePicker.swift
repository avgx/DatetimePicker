// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct DatetimePicker: View {
    /// current datetime selected
    @Binding var selection: Date
    /// possible dates
    @Binding var selectable: [Date]?
    /// start and end dates
    @Binding var dateRange: ClosedRange<Date>
    
    let action: (Date) -> Void
    
    @State var dialog = false
    
    public init(selection: Binding<Date>,
                selectable: Binding<[Date]?>,
                dateRange: Binding<ClosedRange<Date>>,
                action: @escaping (Date) -> Void) {
        self._selection = selection
        self._selectable = selectable
        self._dateRange = dateRange
        self.action = action
    }
    
    public var body: some View {
        Button(action: { dialog.toggle() }) {
            HStack {
                Image(systemName: "calendar")
                VStack {
                    Text(selection.formatted(date: .omitted, time: .standard))
                    Text(selection.formatted(date: .numeric, time: .omitted))
                        .font(.footnote)
                }
            }
            .padding(8)
        }
        .sheet(isPresented: $dialog, content: {
            VStack {
                Text("TODO: show dialog with date and time selection controls. with select and cancel buttons.")
                Button(action: {
                    action(Date()) //TODO: real selected datetime value
                    dialog = false
                }) {
                    Text("Select")
                }
                Button(action: { dialog = false }) {
                    Text("Cancel")
                }
            }
        })
        .buttonStyle(.plain)
        .background(.ultraThinMaterial)
        .controlSize(.large)                  //TODO: неработает
        .buttonBorderShape(.roundedRectangle) //TODO: неработает
    }
}

#Preview {
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
                selection: .constant(Date()),
                selectable: .constant([ Date(), Date().addingTimeInterval(-TimeInterval(3600*24))]),
                dateRange: .constant((Date().addingTimeInterval(-TimeInterval(3600*24*7)) ...  Date())),
                action: { dt in print("\(dt)") }
            )
                .border(.red)
        }
    }
    .padding()
    .preferredColorScheme(.dark)
    .accentColor(.orange)
//    .environment(\.layoutDirection, .rightToLeft)
//    .environment(\.locale, Locale(identifier: "ar"))
    .environment(\.locale, Locale(identifier: "en"))
}
