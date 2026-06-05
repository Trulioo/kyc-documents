import Lottie
import Trulioo
import TruliooKYCDocumentsCapture

public enum TruliooKYCDocumentsDependencies {
    public static func forceLink() {
        _ = LottieAnimationView.self
        _ = TruliooURLSessionFactory.self
        _ = TruliooCapture.self
    }
}
