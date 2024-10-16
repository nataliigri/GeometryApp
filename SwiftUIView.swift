//
//  SwiftUIView.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 10.09.2024.
//

import SwiftUI

struct GeometryInputView: View {
    @Binding var coordinates: [CGPoint]

    var body: some View {
        VStack {
            ForEach(0..<coordinates.count, id: \.self) { index in
                HStack {
                    TextField("X", value: $coordinates[index].x, formatter: NumberFormatter())
                    TextField("Y", value: $coordinates[index].y, formatter: NumberFormatter())
                }
                .padding()
            }

            Button("Add Point") {
                coordinates.append(CGPoint(x: 0, y: 0))
            }
        }
    }
}
