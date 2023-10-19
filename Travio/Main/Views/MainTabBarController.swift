

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let homeVC = HomeViewController()
        let homeNC = createNavigationController(rootViewController: homeVC, title: "Home", imageName: "house.fill")

        let visitsVC = VisitsViewController()
        let visitsNC = createNavigationController(rootViewController: visitsVC, title: "Visits", imageName: "location")

        let mapVC = MapViewController()
        let mapNC = createNavigationController(rootViewController: mapVC, title: "Map", imageName: "map")

        let menuVC = SettingsViewController()
        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "menu"), tag: 3)

        viewControllers = [homeNC, visitsNC, mapNC, menuVC]
        selectedIndex = 0

        customizeTabBarAppearance()
    }

    private func createNavigationController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)

        if let image = UIImage(named: imageName) {
            navigationController.tabBarItem = UITabBarItem(title: title, image: image, tag: viewControllers?.count ?? 0)
        } else {
            navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: viewControllers?.count ?? 0)
        }

        return navigationController
    }

    private func customizeTabBarAppearance() {
        tabBar.tintColor = AppColor.primary.color
        tabBar.unselectedItemTintColor = AppColor.secondary.color.withAlphaComponent(0.3)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tabBar.insertSubview(blurView, at: 0)

        blurView.alpha = 0.95
        blurView.backgroundColor = .clear

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.gray.cgColor

        tabBar.layer.addSublayer(topBorder)
    }
}
