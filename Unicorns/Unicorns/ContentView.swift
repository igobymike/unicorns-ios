import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .imageScale(.large)
                .foregroundStyle(.blue)
            Text("Unicorns")
                .font(.title)
        }
        .padding()
    }
}
