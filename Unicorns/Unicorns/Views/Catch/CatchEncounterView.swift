import SwiftUI
import CoreLocation

struct CatchEncounterView: View {
    let unicorn: Unicorn
    let spawn: SpawnedUnicorn
    let userLocation: CLLocationCoordinate2D?

    @Environment(\.dismiss) private var dismiss
    @Environment(SpawnManager.self) private var spawnManager
    @Environment(CatchStorageManager.self) private var catchStorage

    @State private var phase: EncounterPhase = .ready
    @State private var attemptsRemaining: Int = 0
    @State private var ringScale: CGFloat = 2.0
    @State private var ringAnimating = false

    // Ball throw state
    @State private var ballPosition: CGPoint = .zero
    @State private var ballResting: CGPoint = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var throwInProgress = false

    // Wobble state
    @State private var wobbleCount = 0
    @State private var wobbleAngle: Double = 0
    @State private var ballScale: CGFloat = 1.0

    // Result
    @State private var lastAccuracy: ThrowAccuracy = .miss
    @State private var showResult = false
    @State private var caught = false

    private let difficulty: CatchDifficulty
    private let targetCenter: CGPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.3)

    init(unicorn: Unicorn, spawn: SpawnedUnicorn, userLocation: CLLocationCoordinate2D?) {
        self.unicorn = unicorn
        self.spawn = spawn
        self.userLocation = userLocation
        self.difficulty = CatchDifficulty.forRarity(unicorn.rarity)
    }

    var body: some View {
        ZStack {
            backgroundGradient

            if phase == .ready || phase == .throwing {
                encounterContent
            } else if phase == .wobbling {
                wobbleContent
            } else if phase == .escaped {
                escapedContent
            }
        }
        .fullScreenCover(isPresented: $showResult) {
            CatchResultView(
                unicorn: unicorn,
                caught: caught,
                accuracy: lastAccuracy,
                catchCount: catchStorage.catchCount(for: unicorn.id),
                totalCaught: catchStorage.uniqueCaughtCount,
                totalUnicorns: allUnicorns.count
            )
        }
        .onAppear {
            attemptsRemaining = difficulty.maxAttempts
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            ballResting = CGPoint(x: screenWidth / 2, y: screenHeight * 0.82)
            ballPosition = ballResting
            startRingAnimation()
        }
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: unicorn.element.gradient.map { $0.opacity(0.4) } + [Color(.systemBackground)],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Encounter Content

    private var encounterContent: some View {
        ZStack {
            VStack {
                headerBar
                Spacer()
            }

            // Target area with unicorn
            ZStack {
                // Shrinking ring
                Circle()
                    .stroke(ringColor, lineWidth: 3)
                    .frame(width: 120 * ringScale, height: 120 * ringScale)

                // Static target circle
                Circle()
                    .stroke(unicorn.color.opacity(0.3), lineWidth: 2)
                    .frame(width: 120, height: 120)

                Text("🦄")
                    .font(.system(size: 80))
                    .shadow(color: unicorn.color.opacity(0.8), radius: 20)
            }
            .position(targetCenter)

            // Ball
            if !throwInProgress {
                ballView
                    .position(
                        x: ballResting.x + dragOffset.width,
                        y: ballResting.y + dragOffset.height
                    )
                    .gesture(throwGesture)
            }

            // Throw arc ball
            if throwInProgress {
                ballView
                    .position(ballPosition)
                    .scaleEffect(ballScale)
            }

            // Accuracy flash
            if phase == .throwing, lastAccuracy != .miss {
                accuracyLabel
            }
        }
    }

    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(unicorn.name)
                    .font(.title2.weight(.bold))
                HStack(spacing: 4) {
                    ForEach(0..<unicorn.rarity.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(unicorn.rarity.color)
                    }
                    Text(unicorn.rarity.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(unicorn.rarity.color)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    ForEach(0..<attemptsRemaining, id: \.self) { _ in
                        Circle()
                            .fill(.purple)
                            .frame(width: 10, height: 10)
                    }
                    ForEach(0..<(difficulty.maxAttempts - attemptsRemaining), id: \.self) { _ in
                        Circle()
                            .stroke(.purple.opacity(0.3), lineWidth: 1)
                            .frame(width: 10, height: 10)
                    }
                }
                Text("\(attemptsRemaining) throws left")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                spawnManager.removeSpawn(spawn)
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 8)
        }
        .padding()
    }

    private var ballView: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .purple.opacity(0.8)],
                        center: .init(x: 0.35, y: 0.35),
                        startRadius: 2, endRadius: 22
                    )
                )
                .frame(width: 44, height: 44)
                .shadow(color: .purple.opacity(0.4), radius: 6, y: 3)

            Circle()
                .stroke(.white.opacity(0.6), lineWidth: 2)
                .frame(width: 44, height: 44)

            // Highlight
            Circle()
                .fill(.white.opacity(0.5))
                .frame(width: 12, height: 12)
                .offset(x: -6, y: -6)
        }
    }

    private var accuracyLabel: some View {
        Text(lastAccuracy.rawValue)
            .font(.title.weight(.heavy))
            .foregroundStyle(accuracyColor)
            .shadow(color: accuracyColor.opacity(0.5), radius: 10)
            .position(x: targetCenter.x, y: targetCenter.y + 90)
            .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Wobble Content

    private var wobbleContent: some View {
        ZStack {
            VStack {
                headerBar
                Spacer()
            }

            ZStack {
                Circle()
                    .fill(.purple.opacity(0.2))
                    .frame(width: 80, height: 80)

                ballView
                    .scaleEffect(0.9)
                    .rotationEffect(.degrees(wobbleAngle))
            }
            .position(targetCenter)
        }
    }

    // MARK: - Escaped Content

    private var escapedContent: some View {
        VStack(spacing: 20) {
            Text("🦄💨")
                .font(.system(size: 80))
            Text("\(unicorn.name) fled!")
                .font(.title.weight(.bold))
            Text("Better luck next time...")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                spawnManager.removeSpawn(spawn)
                dismiss()
            } label: {
                Text("Return to Map")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(.purple))
            }
            .padding(.top, 20)
        }
    }

    // MARK: - Ring Color

    private var ringColor: Color {
        if ringScale < 1.2 { return .green }
        if ringScale < 1.5 { return .yellow }
        return .orange
    }

    private var accuracyColor: Color {
        switch lastAccuracy {
        case .excellent: return .green
        case .great: return .cyan
        case .nice: return .yellow
        case .miss: return .red
        }
    }

    // MARK: - Ring Animation

    private func startRingAnimation() {
        ringScale = 2.0
        ringAnimating = true
        withAnimation(.linear(duration: 1.8).repeatForever(autoreverses: false)) {
            ringScale = 0.8
        }
    }

    // MARK: - Throw Gesture

    private var throwGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                dragOffset = value.translation
            }
            .onEnded { value in
                isDragging = false
                let velocity = value.predictedEndTranslation
                // Only count upward swipes
                if velocity.height < -80 {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    performThrow(from: CGPoint(
                        x: ballResting.x + value.translation.width,
                        y: ballResting.y + value.translation.height
                    ), horizontalDeviation: abs(value.translation.width))
                } else {
                    withAnimation(.spring(duration: 0.3)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    // MARK: - Throw Logic

    private func performThrow(from start: CGPoint, horizontalDeviation: CGFloat) {
        throwInProgress = true
        dragOffset = .zero
        ballPosition = start
        ballScale = 1.0

        let accuracy = ThrowAccuracy.fromDeviation(horizontalDeviation)
        lastAccuracy = accuracy
        attemptsRemaining -= 1

        // Animate ball arc to target
        let midPoint = CGPoint(
            x: (start.x + targetCenter.x) / 2 + CGFloat.random(in: -20...20),
            y: min(start.y, targetCenter.y) - 100
        )

        // Phase 1: Arc to midpoint
        withAnimation(.easeOut(duration: 0.25)) {
            ballPosition = midPoint
            ballScale = 0.8
        }

        // Phase 2: Arc to target
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeIn(duration: 0.2)) {
                ballPosition = targetCenter
                ballScale = 0.6
            }
        }

        // Phase 3: Evaluate hit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if accuracy == .miss {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                handleMiss()
            } else {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                startWobble(accuracy: accuracy)
            }
        }
    }

    private func handleMiss() {
        throwInProgress = false
        if attemptsRemaining <= 0 {
            phase = .escaped
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } else {
            // Reset ball
            ballPosition = ballResting
            ballScale = 1.0
        }
    }

    private func startWobble(accuracy: ThrowAccuracy) {
        throwInProgress = false
        phase = .wobbling
        wobbleAngle = 0

        let wobbles = Int.random(in: 1...3)
        wobbleSequence(remaining: wobbles, accuracy: accuracy)
    }

    private func wobbleSequence(remaining: Int, accuracy: ThrowAccuracy) {
        guard remaining > 0 else {
            evaluateCatch(accuracy: accuracy)
            return
        }

        // Wobble left
        withAnimation(.easeInOut(duration: 0.15)) {
            wobbleAngle = 20
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            // Wobble right
            withAnimation(.easeInOut(duration: 0.15)) {
                wobbleAngle = -20
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Return to center
            withAnimation(.easeInOut(duration: 0.1)) {
                wobbleAngle = 0
            }
        }
        // Suspense pause then next wobble
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            wobbleSequence(remaining: remaining - 1, accuracy: accuracy)
        }
    }

    private func evaluateCatch(accuracy: ThrowAccuracy) {
        let ringBonus = max(0.5, min(2.0, (2.0 - Double(ringScale)) / 1.0 + 0.5))
        let catchChance = difficulty.baseCatchRate * accuracy.multiplier * ringBonus
        let roll = Double.random(in: 0..<1)

        if roll < catchChance {
            // Caught!
            caught = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)

            let location = CodableCoordinate(
                userLocation ?? spawn.coordinate.clCoordinate
            )
            let record = CaughtUnicorn(
                unicornID: unicorn.id,
                location: location,
                throwAccuracy: accuracy
            )
            catchStorage.record(record)
            spawnManager.removeSpawn(spawn)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showResult = true
            }
        } else {
            // Escaped from ball
            let escapeRoll = Double.random(in: 0..<1)
            if escapeRoll < difficulty.escapeRate || attemptsRemaining <= 0 {
                phase = .escaped
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            } else {
                // Back to ready
                phase = .ready
                throwInProgress = false
                ballPosition = ballResting
                ballScale = 1.0
            }
        }
    }
}

// MARK: - Encounter Phase

private enum EncounterPhase {
    case ready
    case throwing
    case wobbling
    case escaped
}
