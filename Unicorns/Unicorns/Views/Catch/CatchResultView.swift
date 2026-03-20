import SwiftUI

struct CatchResultView: View {
    let unicorn: Unicorn
    let caught: Bool
    let accuracy: ThrowAccuracy
    let catchCount: Int
    let totalCaught: Int
    let totalUnicorns: Int

    @Environment(\.dismiss) private var dismiss
    @State private var animate = false
    @State private var confetti: [ConfettiPiece] = []
    @State private var showStats = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: caught
                    ? [unicorn.color.opacity(0.3), .purple.opacity(0.2), Color(.systemBackground)]
                    : [Color(.systemBackground)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Confetti
            if caught {
                ForEach(confetti) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: piece.size.width, height: piece.size.height)
                        .rotationEffect(.degrees(piece.rotation))
                        .position(piece.position)
                        .opacity(piece.opacity)
                }
            }

            VStack(spacing: 24) {
                Spacer()

                if caught {
                    catchContent
                } else {
                    escapeContent
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text(caught ? "Continue" : "Return to Map")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Capsule().fill(.purple))
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                animate = true
            }
            if caught {
                spawnConfetti()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showStats = true
                    }
                }
            }
        }
    }

    // MARK: - Catch Content

    private var catchContent: some View {
        VStack(spacing: 20) {
            Text("GOTCHA!")
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [unicorn.color, .purple],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .scaleEffect(animate ? 1.0 : 0.3)
                .opacity(animate ? 1.0 : 0.0)

            ZStack {
                ForEach(0..<3, id: \.self) { ring in
                    Circle()
                        .stroke(unicorn.color.opacity(animate ? 0.2 : 0.0), lineWidth: 2)
                        .frame(width: CGFloat(140 + ring * 30), height: CGFloat(140 + ring * 30))
                        .scaleEffect(animate ? 1.1 : 0.8)
                        .animation(
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(ring) * 0.15),
                            value: animate
                        )
                }

                Text("🦄")
                    .font(.system(size: 100))
                    .shadow(color: unicorn.color.opacity(0.8), radius: animate ? 30 : 10)
                    .scaleEffect(animate ? 1.0 : 0.5)
            }

            Text(unicorn.name)
                .font(.title.weight(.bold))

            Text(unicorn.title)
                .font(.title3)
                .foregroundStyle(.secondary)
                .italic()

            // Throw quality
            HStack(spacing: 12) {
                accuracyBadge

                HStack(spacing: 4) {
                    ForEach(0..<unicorn.rarity.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                    }
                    Text(unicorn.rarity.rawValue)
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(unicorn.rarity.color)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(Capsule().fill(unicorn.rarity.color.opacity(0.15)))
            }

            if showStats {
                statsSection
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }

    private var accuracyBadge: some View {
        Text(accuracy.rawValue)
            .font(.caption.weight(.bold))
            .foregroundStyle(accuracyColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(accuracyColor.opacity(0.15)))
    }

    private var accuracyColor: Color {
        switch accuracy {
        case .excellent: return .green
        case .great: return .cyan
        case .nice: return .yellow
        case .miss: return .red
        }
    }

    private var statsSection: some View {
        VStack(spacing: 12) {
            if catchCount > 1 {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.caption)
                    Text("Caught \(catchCount) times")
                        .font(.subheadline)
                }
                .foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("\(totalCaught)/\(totalUnicorns) Discovered")
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    // MARK: - Escape Content

    private var escapeContent: some View {
        VStack(spacing: 16) {
            Text("🦄💨")
                .font(.system(size: 80))
                .scaleEffect(animate ? 1.0 : 0.5)

            Text("Oh no!")
                .font(.title.weight(.bold))

            Text("\(unicorn.name) broke free and fled!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Confetti

    private func spawnConfetti() {
        let screenWidth = UIScreen.main.bounds.width
        let colors: [Color] = [.purple, .pink, .yellow, .cyan, .orange, .mint, unicorn.color]

        for i in 0..<60 {
            let piece = ConfettiPiece(
                position: CGPoint(x: CGFloat.random(in: 0...screenWidth), y: -20),
                size: CGSize(width: CGFloat.random(in: 4...8), height: CGFloat.random(in: 8...16)),
                color: colors.randomElement()!,
                rotation: Double.random(in: 0...360),
                opacity: 1.0
            )
            confetti.append(piece)

            let delay = Double(i) * 0.02
            let endY = CGFloat.random(in: 400...900)
            let endX = piece.position.x + CGFloat.random(in: -100...100)

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeIn(duration: Double.random(in: 1.5...3.0))) {
                    if let idx = confetti.firstIndex(where: { $0.id == piece.id }) {
                        confetti[idx].position = CGPoint(x: endX, y: endY)
                        confetti[idx].rotation += Double.random(in: 180...720)
                        confetti[idx].opacity = 0
                    }
                }
            }
        }
    }
}

// MARK: - Confetti Piece

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGSize
    var color: Color
    var rotation: Double
    var opacity: Double
}
