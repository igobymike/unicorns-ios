import Foundation

@Observable
class CatchStorageManager {
    private static let storageKey = "caughtUnicorns"
    private(set) var caughtUnicorns: [CaughtUnicorn] = []

    init() {
        load()
    }

    func record(_ caught: CaughtUnicorn) {
        caughtUnicorns.append(caught)
        save()
    }

    func catchCount(for unicornID: String) -> Int {
        caughtUnicorns.filter { $0.unicornID == unicornID }.count
    }

    func hasCaught(_ unicornID: String) -> Bool {
        caughtUnicorns.contains { $0.unicornID == unicornID }
    }

    var uniqueCaughtCount: Int {
        Set(caughtUnicorns.map(\.unicornID)).count
    }

    var totalCaughtCount: Int {
        caughtUnicorns.count
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(caughtUnicorns) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([CaughtUnicorn].self, from: data)
        else { return }
        caughtUnicorns = decoded
    }
}
