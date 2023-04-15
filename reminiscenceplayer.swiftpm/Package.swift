// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "reminiscenceplayer",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "reminiscenceplayer",
            targets: ["AppModule"],
            bundleIdentifier: "com.test.reminiscenceplayer",
            teamIdentifier: "CZH2CMCGCZ",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .dog),
            accentColor: .presetColor(.cyan),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .fileAccess(.userSelectedFiles, mode: .readWrite),
                .fileAccess(.pictureFolder, mode: .readWrite)
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)