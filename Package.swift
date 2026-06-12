// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "TruliooKYCDocuments",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "TruliooKYCDocuments",
            targets: ["TruliooKYCDocuments", "TruliooKYCDocumentsDependencies"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Trulioo/kyc-documents-capture.git", exact: "3.1.0"),
        .package(url: "https://github.com/Trulioo/trulioo-ios.git", exact: "3.1.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.5.2"),
    ],
    targets: [
        .binaryTarget(
            name: "TruliooKYCDocuments",
            url: "https://github.com/Trulioo/kyc-documents/releases/download/3.1.0/TruliooKYCDocuments.xcframework.zip",
            checksum: "4b3cac5b418e121296585343ab7bddcaad7460fb86fb2e80de3277bf9264185f"
        ),
        .target(
            name: "TruliooKYCDocumentsDependencies",
            dependencies: [
                "TruliooKYCDocuments",
                .product(name: "TruliooKYCDocumentsCapture", package: "kyc-documents-capture"),
                .product(name: "Trulioo", package: "trulioo-ios"),
                .product(name: "Lottie", package: "lottie-spm"),
            ]
        ),
    ]
)
