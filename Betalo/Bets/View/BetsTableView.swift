import UIKit

protocol BetsTableViewRowEditingDelegate: AnyObject {
    func betsTableView(_ betsTableView: BetsTableView, didRemoveRowAt index: Int)
}

class BetsTableView: UITableView {
    
    weak var rowEditingDelegate: BetsTableViewRowEditingDelegate?
    
    var viewModel: BetsTableViewModel! {
        didSet {
            guard viewModel != nil else {
                return
            }
            delegate = self
            dataSource = self
            reloadData()
        }
    }
    
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        delegate = self
        dataSource = self
        
        separatorColor = .black
        allowsSelection = false
        
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        separatorColor = .black
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        let cellClass = BetsTableViewCell.self
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BetsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: BetsTableViewCell.self), for: indexPath) as? BetsTableViewCell else {
            return BetsTableViewCell()
        }
        
        let model = viewModel.models[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130.0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()

            viewModel.removeModel(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            
            rowEditingDelegate?.betsTableView(self, didRemoveRowAt: indexPath.row)
        }
    }
}
