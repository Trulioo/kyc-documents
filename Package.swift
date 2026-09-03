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
        .package(url: "https://github.com/Trulioo/kyc-documents-capture.git", exact: "4.0.0"),
        .package(url: "https://github.com/Trulioo/trulioo-ios.git", exact: "4.0.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.5.2"),
    ],
    targets: [
        .binaryTarget(
            name: "TruliooKYCDocuments",
            url: "https://github.com/Trulioo/kyc-documents/releases/download/4.0.0/TruliooKYCDocuments.xcframework.zip",
            checksum: "a99a23fe4bac1c8b12ae92bd9043ef4a54f93ec4095387a3a05305aec52a01e2"
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
