//
//  LongPressButton.swift
//  LongPressButtonAnimationSwiftUI
//
//  Created by Rashid Latif on 29/07/2024.
//

import SwiftUI

struct LongPressButton: View {
    
    var text:String
    var paddingHorizontal:CGFloat = 25
    var paddingVertically: CGFloat = 15
    var duration:CGFloat = 1
    var background:Color
    var loadingTint:Color
    var foregroundColor:Color = .white
    var scale:CGFloat = 0.95
    
    var shape:AnyShape = .init(.capsule)
    var action: ()->()
    
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var timerCount :CGFloat = 0
    @State private var progress :CGFloat = 0
    @State private var isHolding:Bool = false
    @State private var isComplated:Bool = false
    
    var body: some View {
        Text(self.text)
            .padding(.vertical, self.paddingVertically)
            .padding(.horizontal, self.paddingHorizontal)
            .foregroundStyle(foregroundColor)
            .background {
                
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(background.gradient)
                    GeometryReader {
                        let size = $0.size
                        if !isComplated {
                            Rectangle()
                                .fill(loadingTint)
                            //increase with progress
                                .frame(width: size.width * progress)
                        }
                    }
                }
            
            }
            .clipShape(self.shape)
            .contentShape(self.shape)
            .gesture(self.longPressGesture)
            .gesture(self.dragGesture)
            .scaleEffect(isHolding ? scale : 1)
            .animation(.snappy, value: isHolding)
            .onReceive(timer) { _ in
                if isHolding && progress != 1 {
                    self.timerCount += 0.01
                    progress = max(min(timerCount/duration, 1), 0)
                    
                }
            }
            .onAppear(perform: {
                self.cancelTimer()
            })
    }
    
    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: duration)
            .onChanged {
                isComplated = false
                reset()
                
                self.isHolding = $0
                self.addTimer()
            }
            .onEnded { status in
                isHolding = false
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isComplated = status
                }
                action()
            }
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { _ in
                guard !isComplated else {return}
                cancelTimer()
                withAnimation(.snappy) {
                    self.reset()
                }
            }
    }
    
    func addTimer(){
        self.timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    
    func cancelTimer(){
        self.timer.upstream.connect().cancel()
    }
    
    func reset(){
        isHolding = false
        progress = 0
        timerCount = 0
    }
}

#Preview {
    ContentView()
}
