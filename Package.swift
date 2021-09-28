// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "swift-prelude",
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
    .target(name: "Prelude"),
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
