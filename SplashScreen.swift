//
//  SplashScreen.swift
//  GeometryApp
//
//  Created by Наталя Грицишин on 12.09.2024.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var showMainView: Bool
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var isAnimating: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фонове зображення, що займає весь екран
                Image("geometryApp") // Переконайтесь, що це ім'я зображення правильне
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped() // Вирізає частини зображення, які виходять за межі фрейму
                    .opacity(opacity)
                    .scaleEffect(scale) // Додаємо ефект масштабування
                    .onAppear {
                        // Затримка перед початком анімації
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isAnimating = true
                            withAnimation(.easeOut(duration: 2.0)) { // Зменшено тривалість анімації
                                opacity = 0.8 // Зменшена зміна прозорості
                                scale = 1.05 // Зменшене масштабування
                            }
                        }
                        // Затримка перед переходом до основного вмісту
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // 1 сек. затримки + 2 сек. анімації
                            showMainView = true
                        }
                    }
            }
        }
        .edgesIgnoringSafeArea(.all) // Ігнорує безпечні області (notched areas) на екранах
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(showMainView: .constant(true))
    }
}
