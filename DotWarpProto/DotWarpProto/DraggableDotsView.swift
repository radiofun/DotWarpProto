
import SwiftUI

struct DraggableDotsView: View {
    @State private var moverPositions: CGPoint = CGPoint(x: 100, y: 100)
    @State private var positions: [CGPoint] = []
    @State private var scales: [CGFloat] = []
    private let dotRadius: CGFloat = 20
    private let numberOfDots = 200 //how many dots?
    private let gridSpacing: CGFloat = 38 //grid spacing
    private let minScale: CGFloat = 0.3 //smallest scale
    private let maxScale: CGFloat = 1 //how far it should go

    init() { //Setting up the grid
        var initialPositions: [CGPoint] = [] //store initial positions
        var initialScales: [CGFloat] = [] //store initial scales
        let cols = 10
        let rows = numberOfDots / cols
        for row in 0..<rows {
            for col in 0..<cols {
                if initialPositions.count < numberOfDots  {
                    let x = CGFloat(col) * gridSpacing + gridSpacing / 2
                    let y = CGFloat(row) * gridSpacing + gridSpacing / 2
                    initialPositions.append(CGPoint(x: x + 0, y: y + 0))
                    initialScales.append(maxScale)
                }
            }
        }
        _positions = State(initialValue: initialPositions)
        _scales = State(initialValue: initialScales)
    } //putting dots in place

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            //This circle is moving around and affecting dots on the screen.
            Circle()
                .fill(Color.black.opacity(0.5)) // I made it black to fake it, but you can change it to any color
                .frame(width: dotRadius * 20, height: dotRadius * 20)
                .blur(radius: 100)
                .position(moverPositions)
                .onAppear{
                    updateScales()
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            moverPositions = value.location
                            updateScales()
                        }
                        .onEnded { value in
                            updateScales()
                        }
                )

            ForEach(positions.indices, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: dotRadius * 2 * scales[index], height: dotRadius * 2 * scales[index])
                    .position(positions[index])
            }
        }
    }

    private func updateScales() {
        for index in positions.indices {
            let dx = positions[index].x - moverPositions.x //delta between dots positions
            let dy = positions[index].y - moverPositions.y //horizontal and vertical
            let distance = sqrt(dx * dx + dy * dy) //pythagorean theorem
            scales[index] = max(minScale, min(maxScale, maxScale - (distance / 200))) //adjusting scale of individual dots based on distance factor (strength adjust with constant (here I have 100, higher the strogner)
        }
    }
}
#Preview{
    DraggableDotsView()
}
