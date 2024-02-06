// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct DatetimePicker: View {
    let action: (Date) -> Void
    
    @Binding
    var selection: Date

    @Binding
    var selectable: [Date]?
    
    @State
    private var isDataOpened: Bool = false
    
    @State
    private var isTimeOpened: Bool = false
    
    @State
    private var dialog = false
    
    @State
    private var isPortrait = false
    
    public init(selection: Binding<Date>,
                selectable: Binding<[Date]?>,
                action: @escaping (Date) -> Void) {
        self._selection = selection
        self._selectable = selectable
        self.action = action
    }
    
    public var body: some View {
        VStack {
            Spacer()
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
            .padding()
            .buttonStyle(.plain)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(.black)
        .overlay(alignment: .bottom, content: {
            if dialog {
                VStack {
                    HStack {
                        Button(action: {
                            dialog = false
                            isDataOpened = false
                            isTimeOpened = false
                        }, label: {
                            Text("Cancel")
                        })
                        .padding()
                        Spacer()
                        Button(action: {
                            action(selection)
                            dialog = false
                            isDataOpened = false
                            isTimeOpened = false
                        }, label: {
                            Text("Select")
                        })
                        .padding()
                    }
                    Spacer()
                    if isPortrait {
                        verticalList
                    } else {
                        horizontalList
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 400, alignment: .bottom)
                .background(.ultraThinMaterial)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                .animation(.easeIn(duration: 0.3))
                .onAppear {
                    checkOrientation()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    checkOrientation()
                }
            }
        })
    }
    
    @ViewBuilder
    private var verticalList: some View {
        List {
            Button(action: {
                isDataOpened.toggle()
                isTimeOpened = false
            }, label: {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Open data")
                        }
                        Text(selection.formatted(date: .numeric, time: .omitted))
                            .font(.footnote)
                    }
                    .animation(.bouncy)
                    if isDataOpened {
                        SelectDatePicker(selection: $selection, selectable: $selectable)
                    }
                }
            })
            .padding()
            .listRowBackground(Color(UIColor.lightGray))
            
            Button(action: {
                isTimeOpened.toggle()
                isDataOpened = false
            }, label: {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName:  "clock")
                            Text("Open time")
                        }
                        Text(selection.formatted(date: .omitted, time: .standard))
                            .font(.footnote)
                    }
                    .animation(.bouncy)
                    if isTimeOpened {
                        DatePicker("",
                            selection: $selection,
                            displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                    }
                }
            })
            .padding()
            .listRowBackground(Color(UIColor.lightGray))
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var horizontalList: some View {
        HStack {
            SelectDatePicker(selection: $selection, selectable: $selectable)
            DatePicker("",
                selection: $selection,
                displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
    
    private func checkOrientation() {
        if UIDevice.current.orientation.rawValue <= 4 {
            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
            isPortrait = scene.interfaceOrientation.isPortrait
        }
    }

}

#Preview {
    DatetimePicker(selection: .constant(Date()),
                   selectable: .constant([Date().addingTimeInterval(-TimeInterval(3600*144)), Date(), Date().addingTimeInterval(-TimeInterval(3600*24)), Date().addingTimeInterval(+TimeInterval(3600*24))]),
                   action: { dt in print("\(dt)") })
}
