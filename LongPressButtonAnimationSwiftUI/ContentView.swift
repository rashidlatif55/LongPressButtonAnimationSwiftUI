//
//  ContentView.swift
//  LongPressButtonAnimationSwiftUI
//
//  Created by Rashid Latif on 29/07/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var count:Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(count)")
                    .font(.title).bold()
                
                LongPressButton(
                    text: "Hello there",
                    background: .red,
                    loadingTint: .white.opacity(0.3)
                ) {
                    self.count += 1
                }
            }
            .navigationTitle("Long Press Button")
        }
        
    }
    
}
#Preview {
    ContentView()
}
