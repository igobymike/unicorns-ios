import SwiftUI

// MARK: - Data Model

enum Element: String, CaseIterable {
    case cosmic = "Cosmic"
    case fire = "Fire"
    case ice = "Ice"
    case nature = "Nature"
    case shadow = "Shadow"
    case light = "Light"

    var icon: String {
        switch self {
        case .cosmic: return "sparkles"
        case .fire: return "flame.fill"
        case .ice: return "snowflake"
        case .nature: return "leaf.fill"
        case .shadow: return "moon.stars.fill"
        case .light: return "sun.max.fill"
        }
    }

    var gradient: [Color] {
        switch self {
        case .cosmic: return [.purple, .pink, .blue]
        case .fire: return [.red, .orange, .yellow]
        case .ice: return [.cyan, .blue, .white]
        case .nature: return [.green, .mint, .teal]
        case .shadow: return [.indigo, .purple, .black]
        case .light: return [.yellow, .orange, .white]
        }
    }
}

enum Rarity: String, CaseIterable, Comparable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"

    var color: Color {
        switch self {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }

    var stars: Int {
        switch self {
        case .common: return 1
        case .rare: return 2
        case .epic: return 3
        case .legendary: return 4
        }
    }

    private var sortOrder: Int {
        switch self {
        case .common: return 0
        case .rare: return 1
        case .epic: return 2
        case .legendary: return 3
        }
    }

    static func < (lhs: Rarity, rhs: Rarity) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}

struct UnicornStats {
    let power: Double    // 0...1
    let speed: Double
    let magic: Double
    let defense: Double
}

struct Unicorn: Identifiable {
    let id: String
    let name: String
    let title: String
    let color: Color
    let element: Element
    let rarity: Rarity
    let stats: UnicornStats
    let lore: String
    let ability: String
}

func unicornByID(_ id: String) -> Unicorn? {
    allUnicorns.first { $0.id == id }
}

// MARK: - Unicorn Database

let allUnicorns: [Unicorn] = [
    Unicorn(id: "sparkle", name: "Sparkle", title: "The Radiant", color: .purple,
            element: .cosmic, rarity: .legendary,
            stats: UnicornStats(power: 0.9, speed: 0.7, magic: 1.0, defense: 0.6),
            lore: "Born from the collision of two galaxies, Sparkle carries the light of a thousand suns within her crystalline horn. Ancient texts speak of her ability to weave reality itself.",
            ability: "Nova Burst — unleashes concentrated starlight that can reshape the fabric of space"),

    Unicorn(id: "stardust", name: "Stardust", title: "Night Rider", color: .pink,
            element: .cosmic, rarity: .epic,
            stats: UnicornStats(power: 0.6, speed: 0.95, magic: 0.8, defense: 0.5),
            lore: "Stardust gallops across the Milky Way each night, leaving trails of shimmering cosmic dust. She is the reason shooting stars exist — each one a hoofprint left in the sky.",
            ability: "Comet Dash — achieves light speed, leaving a trail of wishes in her wake"),

    Unicorn(id: "moonbeam", name: "Moonbeam", title: "Wish Granter", color: .blue,
            element: .light, rarity: .legendary,
            stats: UnicornStats(power: 0.7, speed: 0.6, magic: 0.95, defense: 0.8),
            lore: "When the moon is full, Moonbeam descends from the lunar plains to walk among dreamers. Every wish made at midnight passes through her horn before reaching the stars.",
            ability: "Lunar Grace — channels moonlight into pure wish energy that alters fate"),

    Unicorn(id: "crystal", name: "Crystal", title: "The Frozen Monarch", color: .cyan,
            element: .ice, rarity: .epic,
            stats: UnicornStats(power: 0.8, speed: 0.5, magic: 0.85, defense: 0.95),
            lore: "Crystal rules the Ice Palace at the top of the world, where temperatures plunge below absolute zero. Her breath creates diamonds, and her tears become glaciers.",
            ability: "Permafrost Shield — encases herself in unbreakable enchanted ice"),

    Unicorn(id: "blaze", name: "Blaze", title: "The Inferno", color: .orange,
            element: .fire, rarity: .rare,
            stats: UnicornStats(power: 0.95, speed: 0.9, magic: 0.6, defense: 0.4),
            lore: "Blaze emerged from the heart of an active volcano, her mane perpetually aflame. She races across deserts so fast the sand turns to glass beneath her hooves.",
            ability: "Solar Charge — ignites into living flame and charges at impossible speeds"),

    Unicorn(id: "twilight", name: "Twilight", title: "Forest Guardian", color: .indigo,
            element: .shadow, rarity: .epic,
            stats: UnicornStats(power: 0.75, speed: 0.65, magic: 0.9, defense: 0.85),
            lore: "The enchanted forest breathes because Twilight wills it. She walks between the seen and unseen worlds, her horn glowing faintly with ancient shadow magic.",
            ability: "Veil Walk — steps between dimensions, becoming untouchable"),

    Unicorn(id: "fern", name: "Fern", title: "Life Weaver", color: .green,
            element: .nature, rarity: .common,
            stats: UnicornStats(power: 0.4, speed: 0.5, magic: 0.7, defense: 0.6),
            lore: "Wherever Fern walks, flowers bloom and trees grow tall. She is the youngest of the unicorns but carries the oldest magic — the power of growth itself.",
            ability: "Bloom Step — causes an explosion of plant growth in a wide radius"),

    Unicorn(id: "ember", name: "Ember", title: "Volcanic Heart", color: .red,
            element: .fire, rarity: .rare,
            stats: UnicornStats(power: 0.85, speed: 0.7, magic: 0.65, defense: 0.55),
            lore: "Ember sleeps inside dormant volcanoes, keeping their fire alive. When she wakes, the earth trembles. Her horn glows like molten lava.",
            ability: "Magma Stomp — strikes the ground to create eruptions of liquid fire"),

    Unicorn(id: "glacier", name: "Glacier", title: "The Ancient", color: .white,
            element: .ice, rarity: .rare,
            stats: UnicornStats(power: 0.65, speed: 0.4, magic: 0.75, defense: 1.0),
            lore: "Glacier has existed since the last ice age. Slow and deliberate, she carries the patience of millennia. Nothing can pierce her frozen armor.",
            ability: "Eternal Frost — creates an impenetrable wall of ancient ice"),

    Unicorn(id: "nova", name: "Nova", title: "Star Forger", color: .yellow,
            element: .light, rarity: .legendary,
            stats: UnicornStats(power: 1.0, speed: 0.8, magic: 0.9, defense: 0.7),
            lore: "Nova is said to have created the first star. Her power is unmatched — a single strike from her horn releases the energy of a supernova. She appears only in times of greatest need.",
            ability: "Supernova Strike — concentrates a star's worth of energy into a single devastating blow"),

    Unicorn(id: "shade", name: "Shade", title: "The Unseen", color: .gray,
            element: .shadow, rarity: .rare,
            stats: UnicornStats(power: 0.7, speed: 0.85, magic: 0.8, defense: 0.6),
            lore: "Shade exists in the spaces between shadows. Most unicorns can only sense her presence — a chill, a whisper, a flicker at the edge of vision.",
            ability: "Shadow Meld — dissolves into darkness and strikes from impossible angles"),

    Unicorn(id: "clover", name: "Clover", title: "Fortune's Child", color: .mint,
            element: .nature, rarity: .common,
            stats: UnicornStats(power: 0.35, speed: 0.6, magic: 0.55, defense: 0.5),
            lore: "Clover brings good luck wherever she goes. Crops flourish, rain falls at the right time, and lost things are found. She's small but beloved by all.",
            ability: "Lucky Aura — bends probability in favor of her allies"),
]

// MARK: - Favorites Manager

@Observable
class FavoritesManager {
    var favoriteIDs: Set<String> = []

    func toggle(_ unicorn: Unicorn) {
        if favoriteIDs.contains(unicorn.id) {
            favoriteIDs.remove(unicorn.id)
        } else {
            favoriteIDs.insert(unicorn.id)
        }
    }

    func isFavorite(_ unicorn: Unicorn) -> Bool {
        favoriteIDs.contains(unicorn.id)
    }
}

// MARK: - Root View

struct ContentView: View {
    @State private var favorites = FavoritesManager()
    @State private var locationManager = LocationManager()
    @State private var spawnManager = SpawnManager()
    @State private var catchStorage = CatchStorageManager()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(1)

            ExploreMapView()
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }
                .tag(2)

            CompendiumView()
                .tabItem {
                    Label("Compendium", systemImage: "book.fill")
                }
                .tag(3)
        }
        .tint(.purple)
        .environment(favorites)
        .environment(locationManager)
        .environment(spawnManager)
        .environment(catchStorage)
    }
}

// MARK: - Gallery View

struct GalleryView: View {
    @Environment(FavoritesManager.self) private var favorites
    @State private var selectedUnicorn: Unicorn?
    @State private var selectedElement: Element?
    @State private var appeared = false

    var filtered: [Unicorn] {
        if let element = selectedElement {
            return allUnicorns.filter { $0.element == element }
        }
        return allUnicorns
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                // Element filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterChip(label: "All", icon: "sparkle", isSelected: selectedElement == nil) {
                            withAnimation(.spring(duration: 0.3)) { selectedElement = nil }
                        }
                        ForEach(Element.allCases, id: \.self) { element in
                            FilterChip(label: element.rawValue, icon: element.icon,
                                       isSelected: selectedElement == element) {
                                withAnimation(.spring(duration: 0.3)) {
                                    selectedElement = selectedElement == element ? nil : element
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Unicorn grid
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                    ForEach(Array(filtered.enumerated()), id: \.element.id) { index, unicorn in
                        UnicornCard(unicorn: unicorn)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 30)
                            .animation(.spring(duration: 0.5, bounce: 0.3).delay(Double(index) * 0.06), value: appeared)
                            .onTapGesture {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                selectedUnicorn = unicorn
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Unicorns")
            .fullScreenCover(item: $selectedUnicorn) { unicorn in
                UnicornDetailView(unicorn: unicorn)
            }
            .onAppear { appeared = true }
        }
    }
}

struct FilterChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption)
                Text(label)
                    .font(.caption.weight(.semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.purple : Color(.tertiarySystemFill))
            )
            .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

// MARK: - Unicorn Card

struct UnicornCard: View {
    let unicorn: Unicorn
    @Environment(FavoritesManager.self) private var favorites
    @State private var shimmer = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                // Unicorn visual
                ZStack {
                    // Glow circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [unicorn.color.opacity(0.4), unicorn.color.opacity(0)],
                                center: .center, startRadius: 5, endRadius: 50
                            )
                        )
                        .frame(width: 90, height: 90)

                    Text("🦄")
                        .font(.system(size: 54))
                        .shadow(color: unicorn.color.opacity(0.6), radius: 8)
                }

                // Favorite heart
                if favorites.isFavorite(unicorn) {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(6)
                }
            }

            Text(unicorn.name)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary)

            // Rarity stars
            HStack(spacing: 2) {
                ForEach(0..<unicorn.rarity.stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(unicorn.rarity.color)
                }
            }

            // Element badge
            HStack(spacing: 3) {
                Image(systemName: unicorn.element.icon)
                    .font(.system(size: 8))
                Text(unicorn.element.rawValue)
                    .font(.system(size: 9, weight: .medium))
            }
            .foregroundStyle(unicorn.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Capsule().fill(unicorn.color.opacity(0.12)))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [unicorn.color.opacity(0.08), unicorn.color.opacity(0.02)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            LinearGradient(
                                colors: [unicorn.color.opacity(0.4), unicorn.color.opacity(0.1)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: unicorn.color.opacity(0.15), radius: 8, y: 4)
        )
    }
}

// MARK: - Detail View

struct UnicornDetailView: View {
    let unicorn: Unicorn
    @Environment(\.dismiss) private var dismiss
    @Environment(FavoritesManager.self) private var favorites
    @State private var animate = false
    @State private var statsVisible = false
    @State private var loreExpanded = false
    @State private var sparkles: [SparkleParticle] = []

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: unicorn.element.gradient.map { $0.opacity(0.3) } + [Color(.systemBackground)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Floating sparkles
            ForEach(sparkles) { sparkle in
                Circle()
                    .fill(unicorn.color.opacity(sparkle.opacity))
                    .frame(width: sparkle.size, height: sparkle.size)
                    .position(sparkle.position)
                    .blur(radius: sparkle.size > 6 ? 1 : 0)
            }

            ScrollView {
                VStack(spacing: 28) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // Hero unicorn
                    ZStack {
                        // Outer glow rings
                        ForEach(0..<3, id: \.self) { ring in
                            Circle()
                                .stroke(unicorn.color.opacity(animate ? 0.15 : 0.05), lineWidth: 1)
                                .frame(width: CGFloat(160 + ring * 40), height: CGFloat(160 + ring * 40))
                                .scaleEffect(animate ? 1.05 : 0.95)
                                .animation(
                                    .easeInOut(duration: 2.0 + Double(ring) * 0.3)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(ring) * 0.2),
                                    value: animate
                                )
                        }

                        Text("🦄")
                            .font(.system(size: 120))
                            .scaleEffect(animate ? 1.08 : 1.0)
                            .shadow(color: unicorn.color.opacity(0.8), radius: animate ? 30 : 12)
                            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: animate)
                    }
                    .padding(.top, 10)

                    // Name + title
                    VStack(spacing: 6) {
                        Text(unicorn.name)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [unicorn.color, unicorn.color.opacity(0.7)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )

                        Text(unicorn.title)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .italic()
                    }

                    // Rarity + Element badges
                    HStack(spacing: 12) {
                        // Rarity badge
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

                        // Element badge
                        HStack(spacing: 5) {
                            Image(systemName: unicorn.element.icon)
                                .font(.caption)
                            Text(unicorn.element.rawValue)
                                .font(.caption.weight(.bold))
                        }
                        .foregroundStyle(unicorn.color)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(unicorn.color.opacity(0.15)))
                    }

                    // Favorite button
                    Button {
                        let generator = UINotificationFeedbackGenerator()
                        if favorites.isFavorite(unicorn) {
                            generator.notificationOccurred(.warning)
                        } else {
                            generator.notificationOccurred(.success)
                        }
                        withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                            favorites.toggle(unicorn)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: favorites.isFavorite(unicorn) ? "heart.fill" : "heart")
                                .symbolEffect(.bounce, value: favorites.isFavorite(unicorn))
                            Text(favorites.isFavorite(unicorn) ? "Favorited" : "Add to Favorites")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(favorites.isFavorite(unicorn) ? .white : unicorn.color)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(favorites.isFavorite(unicorn) ? AnyShapeStyle(unicorn.color) : AnyShapeStyle(unicorn.color.opacity(0.12)))
                        )
                    }

                    // Stats section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("STATS")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .tracking(1.5)

                        StatBar(label: "Power", value: unicorn.stats.power, color: .red, icon: "bolt.fill", animate: statsVisible)
                        StatBar(label: "Speed", value: unicorn.stats.speed, color: .blue, icon: "hare.fill", animate: statsVisible)
                        StatBar(label: "Magic", value: unicorn.stats.magic, color: .purple, icon: "wand.and.stars", animate: statsVisible)
                        StatBar(label: "Defense", value: unicorn.stats.defense, color: .green, icon: "shield.fill", animate: statsVisible)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)

                    // Ability card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "sparkle")
                                .foregroundStyle(unicorn.color)
                            Text("SPECIAL ABILITY")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.secondary)
                                .tracking(1.5)
                        }

                        Text(unicorn.ability)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [unicorn.color.opacity(0.5), unicorn.color.opacity(0.1)],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .padding(.horizontal)

                    // Lore section
                    VStack(alignment: .leading, spacing: 10) {
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                loreExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(unicorn.color)
                                Text("LORE")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                                    .tracking(1.5)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .rotationEffect(.degrees(loreExpanded ? 180 : 0))
                            }
                        }

                        if loreExpanded {
                            Text(unicorn.lore)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            animate = true
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                statsVisible = true
            }
            startSparkles()
        }
    }

    private func startSparkles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        // Generate initial sparkle particles
        for _ in 0..<20 {
            sparkles.append(SparkleParticle(
                position: CGPoint(x: .random(in: 0...screenWidth), y: .random(in: 0...screenHeight)),
                size: .random(in: 2...8),
                opacity: .random(in: 0.1...0.5)
            ))
        }
        // Animate them
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in sparkles.indices {
                sparkles[i].position.y -= .random(in: 0.3...1.5)
                sparkles[i].position.x += .random(in: -0.5...0.5)
                sparkles[i].opacity = max(0, sparkles[i].opacity - 0.002)
                if sparkles[i].position.y < -10 || sparkles[i].opacity <= 0 {
                    sparkles[i].position = CGPoint(
                        x: .random(in: 0...screenWidth),
                        y: screenHeight + 10
                    )
                    sparkles[i].opacity = .random(in: 0.2...0.5)
                }
            }
        }
    }
}

struct SparkleParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
}

struct StatBar: View {
    let label: String
    let value: Double
    let color: Color
    let icon: String
    let animate: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
                .frame(width: 16)

            Text(label)
                .font(.subheadline)
                .frame(width: 60, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.15))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: animate ? geo.size.width * value : 0)
                        .animation(.spring(duration: 0.8, bounce: 0.2), value: animate)
                }
            }
            .frame(height: 10)

            Text("\(Int(value * 100))")
                .font(.caption.weight(.bold).monospacedDigit())
                .foregroundStyle(color)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

// MARK: - Favorites View

struct FavoritesView: View {
    @Environment(FavoritesManager.self) private var favorites
    @State private var selectedUnicorn: Unicorn?

    var favoriteUnicorns: [Unicorn] {
        allUnicorns.filter { favorites.isFavorite($0) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoriteUnicorns.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundStyle(.quaternary)
                        Text("No Favorites Yet")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text("Tap a unicorn in the Gallery\nand hit the heart to add it here")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                            ForEach(favoriteUnicorns) { unicorn in
                                UnicornCard(unicorn: unicorn)
                                    .onTapGesture {
                                        let generator = UIImpactFeedbackGenerator(style: .medium)
                                        generator.impactOccurred()
                                        selectedUnicorn = unicorn
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Favorites")
            .fullScreenCover(item: $selectedUnicorn) { unicorn in
                UnicornDetailView(unicorn: unicorn)
            }
        }
    }
}

// MARK: - Compendium View

struct CompendiumView: View {
    @Environment(CatchStorageManager.self) private var catchStorage
    @State private var sortByRarity = true

    var sortedUnicorns: [Unicorn] {
        if sortByRarity {
            return allUnicorns.sorted { $0.rarity > $1.rarity }
        }
        return allUnicorns.sorted { $0.name < $1.name }
    }

    var body: some View {
        NavigationStack {
            List {
                // Collection progress
                Section {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("\(catchStorage.uniqueCaughtCount)/\(allUnicorns.count) Discovered")
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        if catchStorage.totalCaughtCount > 0 {
                            Text("\(catchStorage.totalCaughtCount) total catches")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(.purple.opacity(0.15))
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * CGFloat(catchStorage.uniqueCaughtCount) / CGFloat(allUnicorns.count))
                        }
                    }
                    .frame(height: 8)
                    .listRowBackground(Color.clear)
                }

                Section {
                    HStack(spacing: 20) {
                        CompendiumStat(value: "\(allUnicorns.count)", label: "Total", icon: "number", color: .purple)
                        CompendiumStat(value: "\(allUnicorns.filter { $0.rarity == .legendary }.count)", label: "Legendary", icon: "crown.fill", color: .orange)
                        CompendiumStat(value: "\(Set(allUnicorns.map(\.element)).count)", label: "Elements", icon: "leaf.fill", color: .green)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }

                Section("Unicorns") {
                    ForEach(sortedUnicorns) { unicorn in
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(unicorn.color.opacity(catchStorage.hasCaught(unicorn.id) ? 0.15 : 0.05))
                                    .frame(width: 44, height: 44)
                                Text("🦄")
                                    .font(.title2)
                                    .opacity(catchStorage.hasCaught(unicorn.id) ? 1.0 : 0.3)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(unicorn.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(catchStorage.hasCaught(unicorn.id) ? .primary : .secondary)
                                Text(unicorn.title)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 3) {
                                HStack(spacing: 2) {
                                    ForEach(0..<unicorn.rarity.stars, id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 8))
                                            .foregroundStyle(unicorn.rarity.color)
                                    }
                                }
                                if catchStorage.hasCaught(unicorn.id) {
                                    let count = catchStorage.catchCount(for: unicorn.id)
                                    HStack(spacing: 3) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 9))
                                            .foregroundStyle(.green)
                                        if count > 1 {
                                            Text("×\(count)")
                                                .font(.system(size: 10, weight: .medium).monospacedDigit())
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                } else {
                                    HStack(spacing: 3) {
                                        Image(systemName: unicorn.element.icon)
                                            .font(.system(size: 9))
                                        Text(unicorn.element.rawValue)
                                            .font(.system(size: 10))
                                    }
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section("Element Distribution") {
                    ForEach(Element.allCases, id: \.self) { element in
                        let count = allUnicorns.filter { $0.element == element }.count
                        HStack {
                            Image(systemName: element.icon)
                                .foregroundStyle(allUnicorns.first { $0.element == element }?.color ?? .gray)
                                .frame(width: 20)
                            Text(element.rawValue)
                            Spacer()
                            Text("\(count)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.medium).monospacedDigit())
                        }
                    }
                }
            }
            .navigationTitle("Compendium")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            withAnimation { sortByRarity = true }
                        } label: {
                            Label("Sort by Rarity", systemImage: "star.fill")
                        }
                        Button {
                            withAnimation { sortByRarity = false }
                        } label: {
                            Label("Sort by Name", systemImage: "textformat")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
            }
        }
    }
}

struct CompendiumStat: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.weight(.bold).monospacedDigit())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
