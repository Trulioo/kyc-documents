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
        .package(url: "https://github.com/Trulioo/kyc-documents-capture.git", exact: "3.2.2"),
        .package(url: "https://github.com/Trulioo/trulioo-ios.git", exact: "3.2.2"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.5.2"),
    ],
    targets: [
        .binaryTarget(
            name: "TruliooKYCDocuments",
            url: "https://github.com/Trulioo/kyc-documents/releases/download/3.2.2/TruliooKYCDocuments.xcframework.zip",
            checksum: "e34e274d14389083f8531d2f484d1f74ac3ec0b21e9be64d7e9331a8bc9952b1"
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
