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
        .package(url: "https://github.com/Trulioo/kyc-documents-capture.git", exact: "3.2.1"),
        .package(url: "https://github.com/Trulioo/trulioo-ios.git", exact: "3.2.1"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.5.2"),
    ],
    targets: [
        .binaryTarget(
            name: "TruliooKYCDocuments",
            url: "https://github.com/Trulioo/kyc-documents/releases/download/3.2.1/TruliooKYCDocuments.xcframework.zip",
            checksum: "6d949f4ce1446500a3ec8a166c76dc97f3a1822a547f82f3ba024076b2224f4e"
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
