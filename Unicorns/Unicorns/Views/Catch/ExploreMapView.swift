import SwiftUI
import MapKit

struct ExploreMapView: View {
    @Environment(LocationManager.self) private var locationManager
    @Environment(SpawnManager.self) private var spawnManager
    @Environment(CatchStorageManager.self) private var catchStorage
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedSpawn: SpawnedUnicorn?
    @State private var showEncounter = false

    var body: some View {
        NavigationStack {
            ZStack {
                if locationManager.hasPermission {
                    mapContent
                } else {
                    permissionPrompt
                }
            }
            .navigationTitle("Explore")
            .fullScreenCover(isPresented: $showEncounter) {
                if let spawn = selectedSpawn, let unicorn = unicornByID(spawn.unicornID) {
                    CatchEncounterView(
                        unicorn: unicorn,
                        spawn: spawn,
                        userLocation: locationManager.location?.coordinate
                    )
                }
            }
            .onAppear {
                if locationManager.hasPermission {
                    locationManager.startUpdating()
                }
            }
            .onChange(of: locationManager.location) { _, newLocation in
                if let location = newLocation {
                    spawnManager.updateLocation(location)
                }
            }
            .onChange(of: locationManager.hasPermission) { _, hasPermission in
                if hasPermission {
                    locationManager.startUpdating()
                }
            }
        }
    }

    private var mapContent: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()

            ForEach(spawnManager.activeSpawns) { spawn in
                if let unicorn = unicornByID(spawn.unicornID) {
                    Annotation(unicorn.name, coordinate: spawn.coordinate.clCoordinate) {
                        SpawnAnnotationView(unicorn: unicorn, spawn: spawn) {
                            selectedSpawn = spawn
                            showEncounter = true
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .overlay(alignment: .top) {
            spawnCountBadge
        }
        .onAppear {
            if let location = locationManager.location {
                spawnManager.startSpawning(around: location)
            }
        }
        .onChange(of: locationManager.location) { _, newLocation in
            if let loc = newLocation, spawnManager.activeSpawns.isEmpty {
                spawnManager.startSpawning(around: loc)
            }
        }
    }

    private var spawnCountBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .foregroundStyle(.purple)
            Text("\(spawnManager.activeSpawns.count) nearby")
                .font(.subheadline.weight(.semibold))
            Text("·")
                .foregroundStyle(.secondary)
            Text("\(catchStorage.uniqueCaughtCount)/\(allUnicorns.count) caught")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: Capsule())
        .padding(.top, 8)
    }

    private var permissionPrompt: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.slash.circle.fill")
                .font(.system(size: 70))
                .foregroundStyle(.purple.opacity(0.5))

            Text("Location Required")
                .font(.title2.weight(.bold))

            Text("Unicorns spawn near your real-world location.\nEnable location access to start exploring!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                locationManager.requestPermission()
            } label: {
                Text("Enable Location")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(.purple))
            }
        }
    }
}

// MARK: - Spawn Annotation

struct SpawnAnnotationView: View {
    let unicorn: Unicorn
    let spawn: SpawnedUnicorn
    let onTap: () -> Void
    @State private var pulse = false

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(unicorn.color.opacity(0.2))
                    .frame(width: 56, height: 56)
                    .scaleEffect(pulse ? 1.3 : 1.0)
                    .opacity(pulse ? 0.0 : 0.6)
                    .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: pulse)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [unicorn.color.opacity(0.5), unicorn.color.opacity(0.1)],
                            center: .center, startRadius: 2, endRadius: 24
                        )
                    )
                    .frame(width: 48, height: 48)

                Text("🦄")
                    .font(.system(size: 28))

                // Rarity indicator
                VStack {
                    Spacer()
                    HStack(spacing: 1) {
                        ForEach(0..<unicorn.rarity.stars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 5))
                                .foregroundStyle(unicorn.rarity.color)
                        }
                    }
                }
                .frame(height: 48)
            }
        }
        .onAppear { pulse = true }
    }
}
