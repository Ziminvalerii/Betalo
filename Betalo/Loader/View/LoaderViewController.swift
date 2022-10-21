import UIKit

class LoaderViewController: BaseVC {
    
    var viewModel: LoaderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor.betanoYellow.cgColor,
            UIColor.betanoOrange.cgColor
        ]
        view.layer.addSublayer(gradient)
                
        viewModel?.setupViewModels()
        
        animateLoading(duration: Double.random(in: 2...6)) { [weak self] in
            self?.setupTabBar()
        }

    }
    
    private func setupTabBar() {
        let tabBarController = TabBarController()

        tabBarController.scheduleViewController.viewModel = viewModel?.scheduleViewModel
        tabBarController.betsViewController.viewModel = viewModel?.betsViewModel
        tabBarController.liveViewController.viewModel = viewModel?.liveViewModel
        tabBarController.settingsViewController.viewModel = viewModel?.settingsViewModel

        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = tabBarController
    }

    private func animateLoading(duration: Double, _ completion: @escaping () -> Void) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame.size = CGSize(width: 150, height: 180)
        imageView.center = view.center
        
        view.addSubview(imageView)

        func flip() {
            imageView.image = UIImage(named: "logo-inverted")
            UIView.transition(
                with: imageView,
                duration: 1.0,
                options: .transitionFlipFromLeft,
                animations: nil,
                completion: { _ in flipBack() }
            )
        }
        
        func flipBack() {
            imageView.image = UIImage(named: "logo")
            UIView.transition(
                with: imageView,
                duration: 1.0,
                options: .transitionFlipFromLeft,
                animations: nil,
                completion: { _ in flip() }
            )
        }
        
        flipBack()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration,
                                      execute: completion)
    }
    
}
