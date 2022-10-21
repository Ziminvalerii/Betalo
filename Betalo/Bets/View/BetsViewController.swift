import UIKit

class BetsViewController: BaseVC {
    
    var viewModel: BetsViewModel! {
        didSet {
            guard let tableViewModel = viewModel?.getTableViewModel() else {
                return
            }
            
            tableView.viewModel = tableViewModel
        }
    }
    
    private let tableView: BetsTableView = {
        let tableView = BetsTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: 200, height: 45)
        button.center = view.center
        button.backgroundColor = .betanoOrange
        button.setTitle("Add first!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowEditingDelegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.viewModel = viewModel?.getTableViewModel()
        
        if tableView.viewModel.models.isEmpty {
            tableView.isScrollEnabled = false
            showAddButton()
        } else {
            tableView.isScrollEnabled = true
            addButton.removeFromSuperview()
        }
    }
    
    @objc
    private func addButtonTapped() {
        tabBarController?.selectedIndex = 0
    }
    
    private func showAddButton() {
        addButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.addSubview(addButton)
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.45,
                       initialSpringVelocity: 10) { [weak self] in
            self?.addButton.transform = .identity
        }
    }
}

extension BetsViewController: BetsTableViewRowEditingDelegate {
    func betsTableView(_ betsTableView: BetsTableView, didRemoveRowAt index: Int) {
        if betsTableView.viewModel.models.isEmpty {
            tableView.isScrollEnabled = false
            showAddButton()
        }
    }
}
