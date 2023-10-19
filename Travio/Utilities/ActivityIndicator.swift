

import UIKit

final class ActivityIndicator {
    static let shared = ActivityIndicator()
    
    private var blurEffectView: UIVisualEffectView?
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()
    
    private var isAnimating = false
    
    private init() {}
    
    func startAnimating() {
        guard !isAnimating else { return }
        
        isAnimating = true

        guard let keyWindow = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first else { return }
        
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView?.frame = keyWindow.frame
            self.blurEffectView?.alpha = 0.6
            keyWindow.addSubview(self.blurEffectView!)
                
            self.activityIndicatorView.center = keyWindow.center
            keyWindow.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func stopAnimating() {
        isAnimating = false
        
        DispatchQueue.main.async {
            self.blurEffectView?.removeFromSuperview()
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
        }
    }
}
