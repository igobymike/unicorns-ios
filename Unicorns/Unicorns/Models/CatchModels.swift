import Foundation
import CoreLocation

// MARK: - Catch Difficulty

struct CatchDifficulty {
    let baseCatchRate: Double
    let escapeRate: Double
    let maxAttempts: Int

    static func forRarity(_ rarity: Rarity) -> CatchDifficulty {
        switch rarity {
        case .common:
            return CatchDifficulty(baseCatchRate: 0.80, escapeRate: 0.05, maxAttempts: 5)
        case .rare:
            return CatchDifficulty(baseCatchRate: 0.50, escapeRate: 0.10, maxAttempts: 4)
        case .epic:
            return CatchDifficulty(baseCatchRate: 0.30, escapeRate: 0.20, maxAttempts: 3)
        case .legendary:
            return CatchDifficulty(baseCatchRate: 0.15, escapeRate: 0.30, maxAttempts: 2)
        }
    }
}

// MARK: - Throw Accuracy

enum ThrowAccuracy: String {
    case excellent = "Excellent"
    case great = "Great"
    case nice = "Nice"
    case miss = "Miss"

    var multiplier: Double {
        switch self {
        case .excellent: return 1.5
        case .great: return 1.3
        case .nice: return 1.0
        case .miss: return 0.0
        }
    }

    static func fromDeviation(_ deviation: CGFloat) -> ThrowAccuracy {
        if deviation < 30 { return .excellent }
        if deviation < 60 { return .great }
        if deviation < 100 { return .nice }
        return .miss
    }
}

// MARK: - Codable Coordinate

struct CodableCoordinate: Codable, Equatable {
    let latitude: Double
    let longitude: Double

    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Spawned Unicorn

struct SpawnedUnicorn: Identifiable, Equatable {
    let id: UUID
    let unicornID: String
    let coordinate: CodableCoordinate
    let spawnTime: Date
    let expiresAt: Date

    var isExpired: Bool {
        Date() >= expiresAt
    }

    static func == (lhs: SpawnedUnicorn, rhs: SpawnedUnicorn) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Caught Unicorn

struct CaughtUnicorn: Codable, Identifiable {
    let id: UUID
    let unicornID: String
    let catchDate: Date
    let location: CodableCoordinate
    let throwAccuracy: String

    init(unicornID: String, location: CodableCoordinate, throwAccuracy: ThrowAccuracy) {
        self.id = UUID()
        self.unicornID = unicornID
        self.catchDate = Date()
        self.location = location
        self.throwAccuracy = throwAccuracy.rawValue
    }
}
