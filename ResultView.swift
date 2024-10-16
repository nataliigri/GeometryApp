//
//  ResultView.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 10.09.2024.
//

import SwiftUI

struct ResultView: View {
    let figure: String
    let area: CGFloat
    let perimeter: CGFloat
    let coordinates: [CGPoint]
    let radius: CGFloat
    let majorAxis: CGFloat
    let minorAxis: CGFloat
    let selectedFigure: Int
    let onClose: () -> Void // Додано параметр для функції закриття

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Figure: \(figure)")
                .font(.headline)
                .padding()
            
            Text("Area: \(area, specifier: "%.2f")")
                .padding()
            Text("Perimeter: \(perimeter, specifier: "%.2f")")
                .padding()

            // Drawing the selected figure
            GeometryDrawingView (
                selectedFigure: selectedFigure,
                coordinates: coordinates,
                radius: radius,
                majorAxis: majorAxis,
                minorAxis: minorAxis
            )
            .background(Color.white)
            .border(Color.black)
            .padding()
            
            Button("Close") {
                onClose() // Виклик функції скидання
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
    }
}
