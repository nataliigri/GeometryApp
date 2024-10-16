//
//  Item.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 07.09.2024.
//

import Foundation
import SwiftData

import CoreGraphics
import CoreGraphics

extension CGPoint {
    func distance5(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}

struct Triangle {
    let vertices: [CGPoint]

    var area: CGFloat {
        guard vertices.count == 3 else { return 0 }
        let (x1, y1) = (vertices[0].x, vertices[0].y)
        let (x2, y2) = (vertices[1].x, vertices[1].y)
        let (x3, y3) = (vertices[2].x, vertices[2].y)
        return abs(x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2
    }

    var perimeter: CGFloat {
        guard vertices.count == 3 else { return 0 }
        return vertices[0].distance(to: vertices[1]) +
               vertices[1].distance(to: vertices[2]) +
               vertices[2].distance(to: vertices[0])
    }
}

struct Quadrilateral {
    let vertices: [CGPoint]

    var area: CGFloat {
        guard vertices.count == 4 else { return 0 }
        return Triangle(vertices: [vertices[0], vertices[1], vertices[2]]).area +
               Triangle(vertices: [vertices[2], vertices[3], vertices[0]]).area
    }

    var perimeter: CGFloat {
        guard vertices.count == 4 else { return 0 }
        return vertices[0].distance(to: vertices[1]) +
               vertices[1].distance(to: vertices[2]) +
               vertices[2].distance(to: vertices[3]) +
               vertices[3].distance(to: vertices[0])
    }
}

struct Circle {
    let center: CGPoint
    let radius: CGFloat

    var area: CGFloat {
        return .pi * radius * radius
    }

    var perimeter: CGFloat {
        return 2 * .pi * radius
    }
}

struct Ellipse {
    let center: CGPoint
    let majorAxis: CGFloat
    let minorAxis: CGFloat

    var area: CGFloat {
        return .pi * majorAxis * minorAxis
    }

    var perimeter: CGFloat {
        // Approximated formula for ellipse circumference
        let a = majorAxis
        let b = minorAxis
        let h = ((a - b) * (a - b)) / ((a + b) * (a + b))
        return .pi * (a + b) * (1 + (3 * h) / (10 + sqrt(4 - 3 * h)))
    }
}
