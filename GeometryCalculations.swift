//
//  GeometryCalculations.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 10.09.2024.
//

import Foundation
import CoreGraphics

// Функція для обчислення площі і периметру трикутника
func triangleAreaAndPerimeter(vertices: [CGPoint]) -> (area: CGFloat, perimeter: CGFloat)? {
    guard vertices.count == 3 else { return nil }
    
    let a = vertices[0].distance(to: vertices[1])
    let b = vertices[1].distance(to: vertices[2])
    let c = vertices[2].distance(to: vertices[0])
    
    let s = (a + b + c) / 2
    let area = sqrt(s * (s - a) * (s - b) * (s - c))
    let perimeter = a + b + c
    
    return (area, perimeter)
}

// Функція для перевірки, чи чотири точки утворюють прямокутник
func isRectangle(vertices: [CGPoint]) -> Bool {
    guard vertices.count == 4 else { return false }
    
    // Функція для обчислення відстані між двома точками
    func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
    
    // Функція для перевірки, чи два вектори перпендикулярні
    func arePerpendicular(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> Bool {
        let v1 = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)
        let v2 = CGPoint(x: p3.x - p2.x, y: p3.y - p2.y)
        return (v1.x * v2.x + v1.y * v2.y) == 0
    }
    
    // Сортуємо точки за координатами для спрощення перевірки
    let sortedVertices = vertices.sorted { $0.x < $1.x || ($0.x == $1.x && $0.y < $1.y) }
    
    // Визначення відстаней між сусідніми точками
    let d1 = distance(sortedVertices[0], sortedVertices[1])
    let d2 = distance(sortedVertices[1], sortedVertices[2])
    let d3 = distance(sortedVertices[2], sortedVertices[3])
    let d4 = distance(sortedVertices[3], sortedVertices[0])
    
    // Перевірка, чи протилежні сторони рівні
    let isRectangleSides = abs(d1 - d3) < 1e-5 && abs(d2 - d4) < 1e-5
    
    // Перевірка, чи всі кути прямі
    let isRectangleAngles = arePerpendicular(p1: sortedVertices[0], p2: sortedVertices[1], p3: sortedVertices[2]) &&
                            arePerpendicular(p1: sortedVertices[1], p2: sortedVertices[2], p3: sortedVertices[3]) &&
                            arePerpendicular(p1: sortedVertices[2], p2: sortedVertices[3], p3: sortedVertices[0])
    
    return isRectangleSides && isRectangleAngles
}

// Функція для обчислення площі і периметру прямокутника
func rectangleAreaAndPerimeter(vertices: [CGPoint]) -> (area: CGFloat, perimeter: CGFloat)? {
    guard vertices.count == 4, isRectangle(vertices: vertices) else { return nil }
    
    // Обчислюємо довжини сторін прямокутника
    let width = vertices[0].distance(to: vertices[1])
    let height = vertices[1].distance(to: vertices[2])
    
    // Площа і периметр прямокутника
    let area = width * height
    let perimeter = 2 * (width + height)
    
    return (area, perimeter)
}

// Функція для обчислення площі і периметру кола
func circleAreaAndPerimeter(radius: CGFloat) -> (area: CGFloat, perimeter: CGFloat) {
    let area = .pi * radius * radius
    let perimeter = 2 * .pi * radius
    
    return (area, perimeter)
}

// Функція для обчислення площі і периметру еліпса
func ellipseAreaAndPerimeter(majorAxis: CGFloat, minorAxis: CGFloat) -> (area: CGFloat, perimeter: CGFloat) {
    let area = .pi * majorAxis * minorAxis
    // Периметр наближено можна розрахувати, використовуючи наближення Раману
    let h = pow((majorAxis - minorAxis) / (majorAxis + minorAxis), 2)
    let perimeter = .pi * (majorAxis + minorAxis) * (1 + (3 * h) / (10 + sqrt(4 - 3 * h)))
    
    return (area, perimeter)
}

// Extension для розрахунку відстані між точками
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}
