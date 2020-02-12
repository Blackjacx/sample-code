import Foundation
import StoreKit

final class StoreKitController: NSObject {

    // Create a store product view controller.
    let storeProductViewController = SKStoreProductViewController()
    // Completion to tell caller when view controller dismissed
    var completion: (() -> Void)?

    // Launches the store product view controller.
    func displayStoreProductViewController(for appId: NSNumber,
                                           on parent: UIViewController,
                                           completion: @escaping () -> Void) {
        self.completion = completion
        self.storeProductViewController.delegate = self

        // Create a product dictionary using the App Store's iTunes identifer.
        let parametersDict = [SKStoreProductParameterITunesItemIdentifier: appId]

        /* Attempt to load it, present the store product view controller if success
         and print an error message, otherwise. */
        storeProductViewController.loadProduct(withParameters: parametersDict, completionBlock: { (status: Bool, error: Error?) -> Void in
            guard status else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            parent.present(self.storeProductViewController, animated: true, completion: nil)
        })
    }
}

extension StoreKitController: SKStoreProductViewControllerDelegate {

    // Let's dismiss the presented store product view controller.
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.presentingViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.completion?()
        })
    }
}
