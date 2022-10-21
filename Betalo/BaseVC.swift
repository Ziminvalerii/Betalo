import UIKit

class BaseVC: UIViewController {
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class BaseNC: UINavigationController {
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    private func setupAppearance() {
        navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor : UIColor.black
        ]
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.black
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
                
//        navigationBar.titleTextAttributes = [
//            .foregroundColor : UIColor.black
//        ]
//        navigationBar.largeTitleTextAttributes = [
//            .foregroundColor : UIColor.black
//        ]
    }
}

class BaseTabBarController: UITabBarController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .betanoOrange

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.opaqueSeparator
        ]

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.opaqueSeparator
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.itemWidth = tabBar.bounds.width / 4
        
        tabBar.itemPositioning = .centered
        
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 24
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

