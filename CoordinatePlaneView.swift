//
//  CoordinatePlaneView.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 11.09.2024.
//

import SwiftUI

struct CoordinatePlaneView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw X and Y axes
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let center = CGPoint(x: width / 2, y: height / 2)

                    // Draw Y axis
                    path.move(to: CGPoint(x: center.x, y: 0))
                    path.addLine(to: CGPoint(x: center.x, y: height))

                    // Draw X axis
                    path.move(to: CGPoint(x: 0, y: center.y))
                    path.addLine(to: CGPoint(x: width, y: center.y))
                }
                .stroke(Color.black, lineWidth: 1)
                
                // Draw grid lines
                let gridSize: CGFloat = 20
                let xCount = Int(geometry.size.width / gridSize)
                let yCount = Int(geometry.size.height / gridSize)

                Path { path in
                    for i in -xCount...xCount {
                        let x = CGFloat(i) * gridSize
                        path.move(to: CGPoint(x: x + geometry.size.width / 2, y: 0))
                        path.addLine(to: CGPoint(x: x + geometry.size.width / 2, y: geometry.size.height))
                    }

                    for j in -yCount...yCount {
                        let y = CGFloat(j) * gridSize
                        path.move(to: CGPoint(x: 0, y: y + geometry.size.height / 2))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y + geometry.size.height / 2))
                    }
                }
                .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
