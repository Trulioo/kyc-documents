<!--
(C) 2026 Trulioo. All rights reserved.
-->

# Trulioo KYC Documents iOS Guide

## Audience And Scope

Use this guide when integrating the hosted Trulioo KYC Documents flow into an iOS app.

This guide covers the public Swift package, initialization, hosted UI launch, callback handling, transaction-owned configuration, and support evidence. It does not cover direct camera rendering. Use the Capture iOS guide for host-owned camera composition.

## Quick Summary

A standard iOS Docs integration looks like this:

1. add the `TruliooKYCDocuments` Swift package
2. create a `Trulioo` instance
3. call `initialize(shortcode:completion:)`
4. launch the hosted flow with either `launch(callbacks:)` for SwiftUI or `launchController(callbacks:)` for UIKit
5. handle completion and error callbacks from the hosted flow
6. call `reset()` when the host app is done with the transaction or wants to start over

## Package Or Artifact Identity

- GitHub repository: `https://github.com/Trulioo/kyc-documents`
- package name: `TruliooKYCDocuments`
- Swift package product: `TruliooKYCDocuments`
- minimum iOS version: `15.0`

The published package includes the hosted KYC Docs UI flow for iPhone and resolves its `Trulioo` and `TruliooKYCDocumentsCapture` dependencies through the package release metadata.

## Platform Requirements And Dependencies

Host applications must:

- provide a valid Docs shortcode created by the Trulioo customer handoff flow
- initialize the SDK before launching the hosted UI
- decide whether to embed the hosted flow through SwiftUI or UIKit
- handle completion and structured error callbacks

The SDK owns:

- the document and selfie capture experience
- country, document, and jurisdiction selection
- capture submission and completion screens
- the portrait presentation of the hosted flow

## Installation

Add the package:

```swift
dependencies: [
    .package(url: "https://github.com/Trulioo/kyc-documents.git", from: "X.Y.Z")
]
```

For beta builds, pin the prerelease tag explicitly:

```swift
dependencies: [
    .package(url: "https://github.com/Trulioo/kyc-documents.git", exact: "X.Y.Z-beta.N")
]
```

Then link the product:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "TruliooKYCDocuments", package: "kyc-documents")
    ]
)
```

Import the module you use:

```swift
import TruliooKYCDocuments
```

## Quick-Start Example

### SwiftUI

```swift
import SwiftUI
import TruliooKYCDocuments

struct HostedDocsView: View {
    @State private var trulioo = Trulioo()
    @State private var isLaunching = false
    @State private var transactionId: String?
    @State private var errorMessage: String?

    let shortcode: String

    var body: some View {
        Group {
            if isLaunching {
                trulioo.launch(
                    callbacks: TruliooCallbacks(
                        onComplete: { value in
                            transactionId = value
                            isLaunching = false
                            trulioo.reset()
                        },
                        onError: { result in
                            if case let .error(message, _, _, _) = result {
                                errorMessage = message
                            } else {
                                errorMessage = String(describing: result)
                            }
                            isLaunching = false
                            trulioo.reset()
                        }
                    )
                )
                .ignoresSafeArea()
            } else {
                VStack(spacing: 16) {
                    Button("Start verification") {
                        trulioo.initialize(shortcode: shortcode) { result in
                            switch result {
                            case .authorized(let transactionId):
                                self.transactionId = transactionId
                                self.isLaunching = true
                            case .error(let message, _, _, _):
                                self.errorMessage = message
                            case .complete:
                                self.errorMessage = "Unexpected completion during initialize."
                            }
                        }
                    }

                    if let transactionId {
                        Text("Initialized transaction: \(transactionId)")
                    }

                    if let errorMessage {
                        Text(errorMessage)
                    }
                }
            }
        }
    }
}
```

### UIKit

```swift
import TruliooKYCDocuments
import UIKit

final class DocsHostViewController: UIViewController {
    private let trulioo = Trulioo()

    func startVerification(shortcode: String) {
        trulioo.initialize(shortcode: shortcode) { [weak self] result in
            guard let self else { return }

            switch result {
            case .authorized:
                let controller = self.trulioo.launchController(
                    callbacks: TruliooCallbacks(
                        onComplete: { _ in
                            self.dismiss(animated: true)
                            self.trulioo.reset()
                        },
                        onError: { _ in
                            self.dismiss(animated: true)
                            self.trulioo.reset()
                        }
                    )
                )
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            case .error(let message, _, _, _):
                print("Initialize failed:", message)
            case .complete:
                print("Unexpected completion during initialize.")
            }
        }
    }
}
```

## Public Entrypoints And When To Use Them

Main entry points:

- `Trulioo.initialize(shortcode:completion:)`
  Start or resume the active Docs transaction and authorize the hosted flow.
- `Trulioo.launch(callbacks:)`
  Return the hosted Docs SwiftUI view after initialization succeeds.
- `Trulioo.launchController(callbacks:)`
  Return a hosted `UIViewController` for UIKit presentation after initialization succeeds.
- `Trulioo.reset()`
  Clear local Docs state after completion, error, or abandonment.

Main result and callback types:

- `TruliooResult.authorized(transactionId:)`
  Returned from `initialize(...)` when the transaction is ready to launch.
- `TruliooResult.complete(transactionId:)`
  Used by the SDK callback surface when the hosted flow completes.
- `TruliooResult.error(message:details:code:transactionId:)`
  Used by the SDK callback surface when the hosted flow ends with a structured product error.
- `TruliooCallbacks`
  Host-provided completion and error handlers for the launched flow.

## Initialization Flow

`initialize(shortcode:completion:)`:

1. authorizes the active Docs transaction from the shortcode
2. loads transaction configuration for the hosted flow
3. prepares the internal Capture-backed UI state
4. returns `.authorized(transactionId:)` when the flow is ready to launch

Initialization must succeed before calling `launch(...)` or `launchController(...)`.

## Launch Flow

The standard hosted-flow sequence is:

1. create a `Trulioo` instance
2. call `initialize(shortcode:completion:)`
3. wait for `.authorized(transactionId:)`
4. launch the hosted flow using SwiftUI or UIKit
5. wait for `onComplete` or `onError`
6. call `reset()`

The host application does not manage camera rendering directly in the Docs SDK. The hosted flow owns that UI internally.

## Device Send Flow And Debug Wait Flow

The Device Intelligence send and debug wait paths do not apply to the hosted Docs SDK. The hosted flow owns capture, submission, and completion for the active Docs transaction. The host application handles the terminal callback result.

## Caller-Owned Versus SDK-Owned Data

The host application owns:

- the shortcode
- SwiftUI or UIKit presentation state around the hosted flow
- completion, error, retry, and navigation behavior
- deciding when to call `reset()`

The SDK owns:

- authorization of the active Docs transaction
- hosted document and selfie capture UI
- transaction-scoped selection and capture rules
- hosted-flow completion and structured error callbacks

## Polling Defaults

The public iOS Docs contract does not require host-side polling configuration.

Important defaults:

- `initialize(...)` must return `.authorized(transactionId:)` before launch
- the hosted flow owns document and selfie capture sequencing
- transaction configuration controls locale, branding, capture requirements, and desktop-to-mobile behavior
- `reset()` clears local SDK state and should be called before starting a new transaction

## Result Handling

Use `TruliooCallbacks` to react to the launched flow:

```swift
let callbacks = TruliooCallbacks(
    onComplete: { transactionId in
        print("Completed transaction:", transactionId ?? "missing")
    },
    onError: { result in
        print("Hosted flow error:", result)
    }
)
```

Recommended host behavior:

- treat `onComplete` as the terminal success callback
- treat `onError` as the terminal handled-error callback
- call `reset()` after either path once the host app is done with the transaction

## Desktop To Mobile Workflow

The iOS Docs SDK can participate in desktop-to-mobile flows when the transaction is configured for cross-device handoff.

In that flow:

- the user starts on desktop
- the user scans the QR code with a mobile device
- the mobile device launches the hosted Docs flow
- the hosted flow continues the document and selfie steps on iPhone

Desktop-to-mobile behavior is configured through the Trulioo customer transaction, not through a separate iOS SDK flag.

## Customization

The hosted Docs SDK does not accept direct host-side theme or locale objects through the public iOS launch surface.

These settings come from the transaction configuration associated with the shortcode:

- locale
- theme colors and branding
- selection and capture rules
- desktop-to-mobile enablement

## Environment And Shortcode Rules

- always initialize with a shortcode created for the active Docs transaction
- do not reuse a stale shortcode after `reset()`
- shortcode environment is selected by the Trulioo customer handoff flow

## Common Mistakes

- calling `launch(...)` before `initialize(...)`
- presenting the hosted controller before initialization returns `.authorized`
- forgetting to call `reset()` after the flow completes or fails
- assuming the host app must render Capture cameras directly when using the Docs SDK

## Troubleshooting

- Initialization fails immediately:
  Verify the shortcode is valid and belongs to the expected environment.
- The hosted UI does not appear:
  Confirm `launch(...)` or `launchController(...)` is only used after `.authorized`.
- The flow completes but the host stays on the SDK screen:
  Handle `onComplete` and dismiss or swap screens in the host app.
- The flow returns an error result:
  Log the returned `message`, `code`, and `transactionId` when present.

## Diagnostic Capture Checklist

When escalating an iOS Docs issue, collect:

- Docs SDK version
- iPhone model and iOS version
- shortcode environment used for testing
- returned transaction id when available
- whether the flow was pure mobile or desktop-to-mobile
- whether the host used SwiftUI or UIKit launch
- the final `TruliooResult` or callback payload

## Support Handoff Checklist

When handing an issue to Trulioo support, include:

- the package version and release channel
- the shortcode environment, without sharing secrets in public tickets
- device model, iOS version, and host presentation mode
- whether initialization reached `.authorized(transactionId:)`
- final callback result and transaction id when available
- whether `reset()` was called before retrying the transaction
