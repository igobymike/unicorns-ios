import SwiftUI

struct Unicorn: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let color: Color
    let description: String
}

struct ContentView: View {
    let unicorns: [Unicorn] = [
        Unicorn(emoji: "🦄", name: "Sparkle", color: .purple, description: "Loves rainbows and glitter"),
        Unicorn(emoji: "🦄", name: "Stardust", color: .pink, description: "Flies through the night sky"),
        Unicorn(emoji: "🦄", name: "Moonbeam", color: .blue, description: "Grants wishes at midnight"),
        Unicorn(emoji: "🦄", name: "Crystal", color: .cyan, description: "Lives in an ice palace"),
        Unicorn(emoji: "🦄", name: "Blaze", color: .orange, description: "Runs faster than the wind"),
        Unicorn(emoji: "🦄", name: "Twilight", color: .indigo, description: "Guardian of the enchanted forest"),
    ]

    @State private var selectedUnicorn: Unicorn?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(unicorns) { unicorn in
                        UnicornCard(unicorn: unicorn)
                            .onTapGesture { selectedUnicorn = unicorn }
                    }
                }
                .padding()
            }
            .navigationTitle("Unicorns")
            .sheet(item: $selectedUnicorn) { unicorn in
                UnicornDetailView(unicorn: unicorn)
            }
        }
    }
}

struct UnicornCard: View {
    let unicorn: Unicorn

    var body: some View {
        VStack(spacing: 8) {
            Text(unicorn.emoji)
                .font(.system(size: 60))
                .shadow(color: unicorn.color.opacity(0.6), radius: 10)

            Text(unicorn.name)
                .font(.headline)
                .foregroundStyle(unicorn.color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(unicorn.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(unicorn.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct UnicornDetailView: View {
    let unicorn: Unicorn
    @Environment(\.dismiss) private var dismiss
    @State private var animate = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(unicorn.emoji)
                .font(.system(size: 120))
                .scaleEffect(animate ? 1.1 : 1.0)
                .shadow(color: unicorn.color.opacity(0.8), radius: animate ? 30 : 10)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)

            Text(unicorn.name)
                .font(.largeTitle.bold())
                .foregroundStyle(unicorn.color)

            Text(unicorn.description)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .tint(unicorn.color)
        }
        .padding(32)
        .onAppear { animate = true }
    }
}
