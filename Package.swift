// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Unicorns",
    platforms: [.iOS(.v17)],
    targets: [
        .target(name: "Unicorns", path: "Unicorns/Unicorns"),
    ]
)
