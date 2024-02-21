//
//  DatetimePicker.swift
//  iPadTesting
//
//  Created by Артём Черныш on 15.02.24.
//

import SwiftUI

public struct DatetimePicker: View {
    @Environment(\.colorScheme) var colorScheme
    
    let action: (Date) -> Void
    
    @Binding
    var selection: Date
    
    @Binding
    var selectable: [Date]?
    
    @State
    private var dialog = false
    
    @State
    private var isPortrait = true
    
    public init(selection: Binding<Date>,
                selectable: Binding<[Date]?>,
                action: @escaping (Date) -> Void) {
        self._selection = selection
        self._selectable = selectable
        self.action = action
    }
    
    public var body: some View {
        VStack {
            Button(action: {
                if isPortrait {
                    showVerticalDateTimePicker()
                } else {
                    showHorizontalDateTimePicker()
                }
            }) {
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
            .foregroundStyle(.white)
            .background(colorScheme == .light ? .gray : .clear)
            .tint(colorScheme == .light ? .white : .clear)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        }
        .preferredColorScheme(colorScheme)
        .onAppear {
            checkOrientation()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            checkOrientation()
            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.dismiss(animated: true)
            }
        }
    }
    
    private func showVerticalDateTimePicker() {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController
        else { return }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let datePicker = UIHostingController(rootView: listView(selection: $selection, selectable: $selectable, isPortrait: $isPortrait).horizontalPad)
            datePicker.title = "Details"
            datePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", primaryAction: .init(handler: { _ in
                print("Select")
            }))
            datePicker.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: .init(handler: { _ in
                print("Cancel")
                viewController.dismiss(animated: true)
            }))
            let containerController = UINavigationController(rootViewController: datePicker)
            containerController.modalPresentationStyle = .popover
            containerController.popoverPresentationController?.sourceRect = viewController.view.frame
            containerController.popoverPresentationController?.sourceView = viewController.view
            containerController.popoverPresentationController?.permittedArrowDirections = []
            containerController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.35)
            viewController.present(containerController, animated: true)
        } else {
//            let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            let okAction = UIAlertAction(title: "Select", style: .default) { _ in
//            }
//            alertVC.addAction(okAction)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//            alertVC.addAction(cancelAction)
//            
//            var datePicker = UIHostingController(rootView: listView(selection: $selection, selectable: $selectable, isPortrait: $isPortrait))
//            datePicker.view.translatesAutoresizingMaskIntoConstraints = false
//            datePicker.view.backgroundColor = .clear
//            datePicker.view.sizeToFit()
//            alertVC.view.addSubview(datePicker.view)
//            
//            NSLayoutConstraint.activate([
//                datePicker.view.topAnchor.constraint(equalTo: alertVC.view.topAnchor),
//                datePicker.view.leadingAnchor.constraint(equalTo: alertVC.view.leadingAnchor),
//                datePicker.view.trailingAnchor.constraint(equalTo: alertVC.view.trailingAnchor)
//            ])
//
//            alertVC.view.heightAnchor.constraint(equalToConstant: datePicker.view.frame.height + 74).isActive = true
//            datePicker.view.heightAnchor.constraint(equalToConstant: datePicker.view.frame.height - 50).isActive = true
//            viewController.present(alertVC, animated: true, completion: nil)
           
            
            let datePicker = UIHostingController(rootView: listView(selection: $selection, selectable: $selectable, isPortrait: $isPortrait))
            datePicker.title = "Details"
            datePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", primaryAction: .init(handler: { _ in
                print("Select")
            }))
            datePicker.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: .init(handler: { _ in
                print("Cancel")
                viewController.dismiss(animated: true)
            }))
            let controller = UINavigationController(rootViewController: datePicker)
            controller.view.backgroundColor = .gray
            if let sheetController = controller.sheetPresentationController {
                sheetController.detents = [.medium()]
            }
            viewController.present(controller, animated: true)
        }
    }
    
    private func showHorizontalDateTimePicker() {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController
        else { return }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let datePicker = UIHostingController(rootView: listView(selection: $selection, selectable: $selectable, isPortrait: $isPortrait).horizontalPad)
            datePicker.title = "Details"
            datePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", primaryAction: .init(handler: { _ in
                print("Select")
            }))
            datePicker.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: .init(handler: { _ in
                print("Cancel")
                viewController.dismiss(animated: true)
            }))
            let containerController = UINavigationController(rootViewController: datePicker)
            containerController.modalPresentationStyle = .popover
            containerController.popoverPresentationController?.sourceRect = viewController.view.frame
            containerController.popoverPresentationController?.sourceView = viewController.view
            containerController.popoverPresentationController?.permittedArrowDirections = []
            containerController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.5)
            viewController.present(containerController, animated: true)
        } else {
//            var alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            let okAction = UIAlertAction(title: "Select", style: .default) { _ in
//            }
//            alertVC.addAction(okAction)
//            let spaceAction = UIAlertAction(title: "", style: .default)
//            spaceAction.isEnabled = false
//            alertVC.addAction(spaceAction)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
//            alertVC.addAction(cancelAction)
//            
//            let datePicker = UIHostingController(rootView: listView(selection: $selection, selectable: $selectable, isPortrait: $isPortrait).horizontalPhone)
//            datePicker.view.translatesAutoresizingMaskIntoConstraints = false
//            datePicker.view.backgroundColor = .clear
//            datePicker.view.sizeToFit()
//            alertVC.view.addSubview(datePicker.view)
//            NSLayoutConstraint.activate([
//                datePicker.view.topAnchor.constraint(equalTo: alertVC.view.topAnchor),
//                datePicker.view.leadingAnchor.constraint(equalTo: alertVC.view.leadingAnchor),
//                datePicker.view.trailingAnchor.constraint(equalTo: alertVC.view.trailingAnchor)
//            ])
//
//            alertVC.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
//            viewController.present(alertVC, animated: true, completion: nil)
            let datePicker = UIHostingController(rootView: listView(selection: $selection, selectable: $selectable, isPortrait: $isPortrait).horizontalPhone)
            datePicker.title = "Details"
            datePicker.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", primaryAction: .init(handler: { _ in
                print("Select")
            }))
            datePicker.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: .init(handler: { _ in
                print("Cancel")
                viewController.dismiss(animated: true)
            }))
            let controller = UINavigationController(rootViewController: datePicker)
            controller.view.backgroundColor = .gray
            if let sheetController = controller.sheetPresentationController {
                sheetController.detents = [.large()]
            }
            viewController.present(controller, animated: true)
        }
    }
    
    private func checkOrientation() {
        if UIDevice.current.orientation.rawValue <= 4 {
            guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
            isPortrait = scene.interfaceOrientation.isPortrait
        }
    }
}

public struct listView: View {
    
    @State
    private var isDataOpened: Bool = true
    
    @State
    private var isTimeOpened: Bool = false
    
    @Binding
    var selection: Date
    
    @Binding
    var selectable: [Date]?
    
    @Binding
    var isPortrait: Bool
    
    public var body: some View {
        VStack {
            Button(action: {
                isDataOpened = true
                isTimeOpened = false
            }, label: {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(5.0)
                        .background(Color.red)
                        .cornerRadius(10.0)
                    Text("Date")
                        .tint(.black)
                        .font(.title3)
                    Spacer()
                    Text(selection.formatted(date: .numeric, time: .omitted))
                        .font(.callout)
                }
            })
            .padding([.horizontal])
            
            if isDataOpened {
                SelectDatePicker(selection: $selection, selectable: $selectable, calendarFont: nil, calendarPadding: 1, titleFont: nil)
                    .padding([.horizontal], 20)
            }
            
            Divider()
            Button(action: {
                isDataOpened = false
                isTimeOpened = true
            }, label: {
                HStack {
                    Image(systemName:  "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(5.0)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                    Text("Time")
                        .tint(.black)
                        .font(.title3)
                    Spacer()
                    Text(selection.formatted(date: .omitted, time: .standard))
                        .font(.callout)
                }
            })
            .padding([.horizontal])
            
            if isTimeOpened {
                DatePicker("",
                           selection: $selection,
                           displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
            }
        }
        Spacer()
            .frame(height: 10)
    }
    
    @ViewBuilder
    var horizontalPhone: some View {
        HStack {
            SelectDatePicker(selection: $selection, selectable: $selectable)
            DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
        }
        .padding([.vertical])
    }
    
    @ViewBuilder
    var horizontalPad: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .padding(5.0)
                        .background(Color.red)
                        .cornerRadius(10.0)
                    Text("Date")
                        .tint(.black)
                        .font(.title3)
                    Spacer()
                    Text(selection.formatted(date: .numeric, time: .omitted))
                        .font(.callout)
                }
                .padding()
                Spacer()
                SelectDatePicker(selection: $selection, selectable: $selectable)
                Spacer()
            }
            VStack {
                HStack {
                    Image(systemName:  "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .padding(5.0)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                    Text("Time")
                        .tint(.black)
                        .font(.title3)
                    Spacer()
                    Text(selection.formatted(date: .omitted, time: .standard))
                        .font(.callout)
                }
                .padding()
                Spacer()
                DatePicker("",
                           selection: $selection,
                           displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                Spacer()
            }
        }
    }
}
