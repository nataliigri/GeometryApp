//
//  ContentView.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 07.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFigure: Int = 0
    @State private var coordinates: [CGPoint] = []
    @State private var radius: CGFloat = 0
    @State private var majorAxis: CGFloat = 0
    @State private var minorAxis: CGFloat = 0
    @State private var showResultView: Bool = false
    @State private var resultFigure: String = ""
    @State private var resultArea: CGFloat = 0
    @State private var resultPerimeter: CGFloat = 0
    @State private var showAboutView: Bool = false // Додано для модального вікна

    let figures = ["Triangle", "Rectangle", "Circle", "Ellipse"]

    var body: some View {
        VStack {
            Picker("Select Figure", selection: $selectedFigure) {
                ForEach(0..<figures.count, id: \.self) { index in
                    Text(figures[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedFigure == 0 { // Triangle
                Text("Enter coordinates for Triangle")
                ForEach(0..<3) { index in
                    CoordinateInputView(index: index, coordinates: $coordinates)
                }
            } else if selectedFigure == 1 { // Rectangle
                Text("Enter coordinates for Rectangle")
                ForEach(0..<4) { index in
                    CoordinateInputView(index: index, coordinates: $coordinates)
                }
            } else if selectedFigure == 2 { // Circle
                Text("Enter center and radius for Circle")
                CoordinateInputView(index: 0, coordinates: $coordinates)
                TextField("Radius", value: $radius, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else if selectedFigure == 3 { // Ellipse
                Text("Enter center and radii for Ellipse")
                CoordinateInputView(index: 0, coordinates: $coordinates)
                TextField("Major Axis", value: $majorAxis, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Minor Axis", value: $minorAxis, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            Button("Calculate") {
                calculateGeometry()
            }
            .padding()

            // Кнопка для переходу на сторінку з інформацією про розробника
            Button("About Developer") {
                showAboutView.toggle()
            }
            .padding()
            .sheet(isPresented: $showAboutView) {
                AboutDeveloperView() // Модальне вікно з інформацією про розробника
            }

            .sheet(isPresented: $showResultView) {
                ResultView(
                    figure: resultFigure,
                    area: resultArea,
                    perimeter: resultPerimeter,
                    coordinates: coordinates,
                    radius: radius,
                    majorAxis: majorAxis,
                    minorAxis: minorAxis,
                    selectedFigure: selectedFigure,
                    onClose: resetAll
                )
            }
        }
        .padding()
    }

    func calculateGeometry() {
        switch selectedFigure {
        case 0: // Triangle
            if let result = triangleAreaAndPerimeter(vertices: coordinates) {
                resultFigure = figures[selectedFigure]
                resultArea = result.area
                resultPerimeter = result.perimeter
            }
        case 1: // Rectangle
            if let result = rectangleAreaAndPerimeter(vertices: coordinates) {
                resultFigure = figures[selectedFigure]
                resultArea = result.area
                resultPerimeter = result.perimeter
            }
        case 2: // Circle
            let result = circleAreaAndPerimeter(radius: radius)
            resultFigure = figures[selectedFigure]
            resultArea = result.area
            resultPerimeter = result.perimeter
        case 3: // Ellipse
            let result = ellipseAreaAndPerimeter(majorAxis: majorAxis, minorAxis: minorAxis)
            resultFigure = figures[selectedFigure]
            resultArea = result.area
            resultPerimeter = result.perimeter
        default:
            break
        }
        showResultView = true
    }
    
    private func resetAll() {
        selectedFigure = 0
        coordinates = []
        radius = 0
        majorAxis = 0
        minorAxis = 0
        showResultView = false
    }
}

struct CoordinateInputView: View {
    let index: Int
    @Binding var coordinates: [CGPoint]

    var body: some View {
        HStack {
            Text("Vertex \(index + 1):")
            TextField("x", value: Binding(
                get: { coordinates.indices.contains(index) ? coordinates[index].x : 0 },
                set: { newValue in
                    if coordinates.indices.contains(index) {
                        coordinates[index].x = newValue
                    } else {
                        coordinates.append(CGPoint(x: newValue, y: 0))
                    }
                }
            ), formatter: NumberFormatter())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 100)
            
            TextField("y", value: Binding(
                get: { coordinates.indices.contains(index) ? coordinates[index].y : 0 },
                set: { newValue in
                    if coordinates.indices.contains(index) {
                        coordinates[index].y = newValue
                    } else {
                        coordinates.append(CGPoint(x: 0, y: newValue))
                    }
                }
            ), formatter: NumberFormatter())
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 100)
        }
        .padding()
    }
}

// Відокремлений вигляд для інформації про розробника
struct AboutDeveloperView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image("developerPhoto") // Використовуйте ім'я зображення з вашого каталогу Assets.xcassets
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Або .fill, в залежності від вашого дизайну
                            .frame(width: 200, height: 200) // Задайте розмір зображення
            
            Text("About Developer")
                .font(.headline)
                .padding()
            Text("This app was developed by Nataliia Hrytsyshyn.")
                .multilineTextAlignment(.center)
                .padding()
            Text("Feel free to contact me at [Your Email] for feedback or questions.")
                .multilineTextAlignment(.center)
                .padding()
            Link("Visit My Website", destination: URL(string: "https://yourwebsite.com")!)
                .padding()
            Button("Close") {
                // Закрити модальне вікно
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
}
