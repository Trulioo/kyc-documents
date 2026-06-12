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
            checksum: "1511aa8cf83d2bb987512b11631c93b4552c50a5d36185aa884d6ad0aaf6b88c"
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
