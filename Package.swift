// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NvimVoice",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/argmaxinc/WhisperKit", from: "0.9.0"),
    ],
    targets: [
        .executableTarget(
            name: "NvimVoice",
            dependencies: ["WhisperKit"],
            path: "NvimVoice",
            exclude: ["Resources/AppInfo.plist"]
        ),
    ]
)
