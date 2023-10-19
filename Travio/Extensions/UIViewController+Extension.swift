

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let deleteConfirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteConfirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func showSpinner() {
        ActivityIndicator.shared.startAnimating()
    }

    func hideSpinner() {
        ActivityIndicator.shared.stopAnimating()
    }
}

