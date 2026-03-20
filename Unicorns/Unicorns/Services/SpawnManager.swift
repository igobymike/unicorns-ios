import Foundation
import CoreLocation

@Observable
class SpawnManager {
    private(set) var activeSpawns: [SpawnedUnicorn] = []
    private var spawnTimer: Timer?

    private let maxSpawns = 5
    private let spawnInterval: TimeInterval = 30
    private let minDistance: Double = 50
    private let maxDistance: Double = 500
    private let spawnLifetime: TimeInterval = 15 * 60

    func startSpawning(around location: CLLocation) {
        spawnTimer?.invalidate()
        checkAndSpawn(around: location)
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [weak self] _ in
            self?.checkAndSpawn(around: location)
        }
    }

    func stopSpawning() {
        spawnTimer?.invalidate()
        spawnTimer = nil
    }

    func updateLocation(_ location: CLLocation) {
        pruneExpired()
        if activeSpawns.count < maxSpawns {
            checkAndSpawn(around: location)
        }
    }

    func removeSpawn(_ spawn: SpawnedUnicorn) {
        activeSpawns.removeAll { $0.id == spawn.id }
    }

    private func checkAndSpawn(around location: CLLocation) {
        pruneExpired()
        let slotsAvailable = maxSpawns - activeSpawns.count
        guard slotsAvailable > 0 else { return }

        let newCount = Int.random(in: 1...min(2, slotsAvailable))
        for _ in 0..<newCount {
            if let spawn = generateSpawn(around: location.coordinate) {
                activeSpawns.append(spawn)
            }
        }
    }

    private func pruneExpired() {
        activeSpawns.removeAll { $0.isExpired }
    }

    private func generateSpawn(around center: CLLocationCoordinate2D) -> SpawnedUnicorn? {
        let distance = Double.random(in: minDistance...maxDistance)
        let bearing = Double.random(in: 0..<360) * .pi / 180.0

        let earthRadius = 6_371_000.0
        let lat1 = center.latitude * .pi / 180.0
        let lon1 = center.longitude * .pi / 180.0
        let angularDistance = distance / earthRadius

        let lat2 = asin(sin(lat1) * cos(angularDistance) + cos(lat1) * sin(angularDistance) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(angularDistance) * cos(lat1),
                                 cos(angularDistance) - sin(lat1) * sin(lat2))

        let spawnCoord = CLLocationCoordinate2D(latitude: lat2 * 180.0 / .pi, longitude: lon2 * 180.0 / .pi)

        let unicorn = pickWeightedUnicorn(distance: distance)
        let now = Date()

        return SpawnedUnicorn(
            id: UUID(),
            unicornID: unicorn.id,
            coordinate: CodableCoordinate(spawnCoord),
            spawnTime: now,
            expiresAt: now.addingTimeInterval(spawnLifetime)
        )
    }

    private func pickWeightedUnicorn(distance: Double) -> Unicorn {
        // Distance influences rarity: farther = more likely rare/epic/legendary
        let distanceFactor = (distance - minDistance) / (maxDistance - minDistance) // 0...1

        let weights: [(Rarity, Double)]
        if distanceFactor < 0.3 {
            weights = [(.common, 50), (.rare, 30), (.epic, 15), (.legendary, 5)]
        } else if distanceFactor < 0.6 {
            weights = [(.common, 35), (.rare, 30), (.epic, 25), (.legendary, 10)]
        } else {
            weights = [(.common, 20), (.rare, 25), (.epic, 30), (.legendary, 25)]
        }

        let targetRarity = weightedPick(weights)
        let candidates = allUnicorns.filter { $0.rarity == targetRarity }
        return candidates.randomElement() ?? allUnicorns.randomElement()!
    }

    private func weightedPick(_ weights: [(Rarity, Double)]) -> Rarity {
        let total = weights.reduce(0.0) { $0 + $1.1 }
        var roll = Double.random(in: 0..<total)
        for (rarity, weight) in weights {
            roll -= weight
            if roll <= 0 { return rarity }
        }
        return weights.last!.0
    }
}
