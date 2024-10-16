//
//  GeometryDrawingView.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 10.09.2024.
//

import SwiftUI

struct GeometryDrawingView: View {
    var selectedFigure: Int
    var coordinates: [CGPoint]
    var radius: CGFloat
    var majorAxis: CGFloat
    var minorAxis: CGFloat

    private let maxDimension: CGFloat = 200 // Максимальна допустима довжина або ширина для малювання фігур
    private let padding: CGFloat = 20 // Відступ для забезпечення видимості

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Coordinate System Background
                Color.white
                    .overlay(
                        GridView()
                            .stroke(Color.gray, lineWidth: 0.5)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    )
                
                // Draw the figure based on selection
                switch selectedFigure {
                case 0: // Triangle
                    drawTriangle(geometry: geometry)
                case 1: // Rectangle
                    drawRectangle(geometry: geometry)
                case 2: // Circle
                    drawCircle(geometry: geometry)
                case 3: // Ellipse
                    drawEllipse(geometry: geometry)
                default:
                    EmptyView()
                }
            }
            .padding(padding)
        }
        .aspectRatio(1, contentMode: .fit) // Maintain aspect ratio
    }

    private func drawTriangle(geometry: GeometryProxy) -> some View {
        Path { path in
            guard coordinates.count == 3 else { return }
            
            let (scaleFactor, offset) = scaleAndOffset(geometry: geometry)
            let points = coordinates.map {
                CGPoint(x: offset.x + $0.x * scaleFactor, y: offset.y - $0.y * scaleFactor)
            }
            path.move(to: points[0])
            path.addLine(to: points[1])
            path.addLine(to: points[2])
            path.closeSubpath()
        }
        .stroke(Color.blue, lineWidth: 2)
    }

    private func drawRectangle(geometry: GeometryProxy) -> some View {
        Path { path in
            // Ensure there are at least 2 coordinates to form a rectangle
            guard coordinates.count >= 2 else { return }
            
            // Find the min and max x and y values to create a bounding box
            let (minX, maxX) = (coordinates.map { $0.x }.min() ?? 0, coordinates.map { $0.x }.max() ?? 0)
            let (minY, maxY) = (coordinates.map { $0.y }.min() ?? 0, coordinates.map { $0.y }.max() ?? 0)
            
            let (scaleFactor, offset) = scaleAndOffset(geometry: geometry)
            
            let topLeft = CGPoint(x: minX * scaleFactor, y: maxY * scaleFactor)
            let topRight = CGPoint(x: maxX * scaleFactor, y: maxY * scaleFactor)
            let bottomLeft = CGPoint(x: minX * scaleFactor, y: minY * scaleFactor)
            let bottomRight = CGPoint(x: maxX * scaleFactor, y: minY * scaleFactor)
            
            let adjustedTopLeft = CGPoint(x: offset.x + topLeft.x, y: offset.y - topLeft.y)
            let adjustedTopRight = CGPoint(x: offset.x + topRight.x, y: offset.y - topRight.y)
            let adjustedBottomLeft = CGPoint(x: offset.x + bottomLeft.x, y: offset.y - bottomLeft.y)
            let adjustedBottomRight = CGPoint(x: offset.x + bottomRight.x, y: offset.y - bottomRight.y)
            
            path.move(to: adjustedTopLeft)
            path.addLine(to: adjustedTopRight)
            path.addLine(to: adjustedBottomRight)
            path.addLine(to: adjustedBottomLeft)
            path.closeSubpath()
        }
        .stroke(Color.red, lineWidth: 2)
    }

    private func drawCircle(geometry: GeometryProxy) -> some View {
        let (scaleFactor, offset) = scaleAndOffset(geometry: geometry)
        let center = CGPoint(x: offset.x + (coordinates.first?.x ?? 0) * scaleFactor,
                              y: offset.y - (coordinates.first?.y ?? 0) * scaleFactor)
        let radiusScaled = radius * scaleFactor

        return Path { path in
            path.addArc(center: center, radius: radiusScaled, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
        }
        .stroke(Color.green, lineWidth: 2)
    }

    private func drawEllipse(geometry: GeometryProxy) -> some View {
        let (scaleFactor, offset) = scaleAndOffset(geometry: geometry)
        let center = CGPoint(x: offset.x + (coordinates.first?.x ?? 0) * scaleFactor,
                              y: offset.y - (coordinates.first?.y ?? 0) * scaleFactor)
        let majorAxisScaled = majorAxis * scaleFactor
        let minorAxisScaled = minorAxis * scaleFactor

        return Path { path in
            path.addEllipse(in: CGRect(
                x: center.x - majorAxisScaled,
                y: center.y - minorAxisScaled,
                width: majorAxisScaled * 2,
                height: minorAxisScaled * 2
            ))
        }
        .stroke(Color.orange, lineWidth: 2)
    }

    private func scaleAndOffset(geometry: GeometryProxy) -> (scaleFactor: CGFloat, offset: CGPoint) {
        // Calculate the maximum extent of the coordinates
        let (minX, maxX) = (coordinates.map { $0.x }.min() ?? 0, coordinates.map { $0.x }.max() ?? 0)
        let (minY, maxY) = (coordinates.map { $0.y }.min() ?? 0, coordinates.map { $0.y }.max() ?? 0)
        
        let width = maxX - minX
        let height = maxY - minY

        // Determine scale factor
        let scaleFactor = min(
            (geometry.size.width - 2 * padding) / (width + 2 * padding),
            (geometry.size.height - 2 * padding) / (height + 2 * padding)
        )
        
        // Determine offset to center the figure
        let offsetX = (geometry.size.width - width * scaleFactor) / 2 - (minX * scaleFactor)
        let offsetY = (geometry.size.height - height * scaleFactor) / 2 - (minY * scaleFactor)
        let offset = CGPoint(x: offsetX, y: offsetY)
        
        return (scaleFactor, offset)
    }
}

// GridView helps to draw a grid as a background
struct GridView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let gridSize: CGFloat = 20
        let xCount = Int(rect.size.width / gridSize)
        let yCount = Int(rect.size.height / gridSize)

        for i in 0...xCount {
            let x = CGFloat(i) * gridSize
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.size.height))
        }

        for j in 0...yCount {
            let y = CGFloat(j) * gridSize
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.size.width, y: y))
        }

        return path
    }
}

struct GeometryDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryDrawingView(
            selectedFigure: 1,
            coordinates: [CGPoint(x: 1, y: 1), CGPoint(x: -1, y: 1), CGPoint(x: -1, y: -1), CGPoint(x: 1, y: -1)],
            radius: 0,
            majorAxis: 0,
            minorAxis: 0
        )
    }
}
