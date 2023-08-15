// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "swift-prelude",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "Either",
      targets: ["Either"]
    ),
    .library(
      name: "Optics",
      targets: ["Optics"]
    ),
    .library(
      name: "Prelude",
      targets: ["Prelude"]
    ),
    .library(
      name: "Tuple",
      targets: ["Tuple"]
    ),
    .library(
      name: "ValidationSemigroup",
      targets: ["ValidationSemigroup"]
    ),
    .library(
      name: "ValidationNearSemiring",
      targets: ["ValidationNearSemiring"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-dependencies.git",
      .upToNextMajor(from: "1.0.0")
    ),
  ],
  targets: [
    // MARK: Either
    .target(
      name: "Either",
      dependencies: [
        .target(name: "Prelude")
      ]
    ),
    .testTarget(
      name: "EitherTests",
      dependencies: [
        .target(name: "Either")
      ]
    ),
    
      // MARK: Optics
    .target(
      name: "Optics",
      dependencies: [
        .target(name: "Prelude"),
        .target(name: "Either")
      ]
    ),
    .testTarget(
      name: "OpticsTests",
      dependencies: [
        .target(name: "Optics")
      ],
      resources: [
        .process("__Snapshots__")
      ]
    ),
    
      // MARK: Prelude
    .target(
      name: "Prelude",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies")
      ]
    ),
    .testTarget(
      name: "PreludeTests",
      dependencies: [
        .target(name: "Prelude")
      ]
    ),
    
      // MARK: Tuple
    .target(
      name: "Tuple",
      dependencies: [
        .target(name: "Prelude")
      ]
    ),
    .testTarget(
      name: "TupleTests",
      dependencies: [
        .target(name: "Tuple")
      ]
    ),
    
      // MARK: ValidationNearSemiring
    .target(
      name: "ValidationNearSemiring",
      dependencies: [
        .target(name: "Prelude"),
        .target(name: "Either")
      ]
    ),
    .testTarget(
      name: "ValidationNearSemiringTests",
      dependencies: [
        .target(name: "ValidationNearSemiring")
      ]
    ),
    
      // MARK: ValidationSemigroup
    .target(
      name: "ValidationSemigroup",
      dependencies: [
        .target(name: "Prelude")
      ]
    ),
    .testTarget(
      name: "ValidationSemigroupTests",
      dependencies: [
        .target(name: "ValidationSemigroup")
      ]
    ),
  ]
)
