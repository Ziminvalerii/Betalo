import UIKit

final class TabBarController: BaseTabBarController {
    
    private(set) var scheduleViewController: ScheduleViewController = {
        let vc = ScheduleViewController()
        vc.title = "Schedule"
        vc.tabBarItem.image = UIImage(systemName: "list.bullet")
        return vc
    }()
    
    private(set) var betsViewController: BetsViewController = {
        let vc = BetsViewController()
        vc.navigationItem.title = "Your bets!"
        vc.tabBarItem.title = "Bets"
        vc.tabBarItem.image = UIImage(systemName: "dollarsign.circle")
        return vc
    }()
    
    private(set) var liveViewController: LiveViewController = {
        let vc = LiveViewController()
        vc.title = "Live"
        vc.tabBarItem.image = UIImage(systemName: "play.circle")
        return vc
    }()
    
    private(set) var settingsViewController: SettingsViewController = {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.tabBarItem.image = UIImage(systemName: "slider.horizontal.3")
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewControllers = [
            BaseNC(rootViewController: scheduleViewController),
            BaseNC(rootViewController: betsViewController),
            BaseNC(rootViewController: liveViewController),
            BaseNC(rootViewController: settingsViewController)
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBar.frame.origin.y += tabBar.bounds.height
        UIView.animate(withDuration: 0.25) {
            self.tabBar.frame.origin.y -= self.tabBar.bounds.height
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animateSelection(item: item)
    }
    
    private func animateSelection(item: UITabBarItem) {
        guard let itemView = item.value(forKey: "view") as? UIView else {
            return
        }
        
        itemView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2) {
            itemView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
}
