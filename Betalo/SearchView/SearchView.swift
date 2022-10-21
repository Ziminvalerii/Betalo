import UIKit

protocol SearchViewDelegate: AnyObject {
    func didPressSportsButton(searchView: SearchView)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
}

class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
        
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.placeholder = "Search schedules on today!"
        return searchBar
    }()
    
    private var sportsButtonShapeLayer: CAShapeLayer?
    private(set) lazy var sportsButton: UIButton = {
        let dropDownButton = UIButton()
        dropDownButton.translatesAutoresizingMaskIntoConstraints = false
        
        dropDownButton.backgroundColor = .systemGroupedBackground
        
        dropDownButton.setTitle("Title", for: .normal)
        dropDownButton.setTitleColor(.black, for: .normal)
        dropDownButton.titleLabel?.font = UIFont(name: "Copperplate Bold", size: 20)
        dropDownButton.titleLabel?.adjustsFontSizeToFitWidth = true
        dropDownButton.titleLabel?.minimumScaleFactor = 0.5
        dropDownButton.titleLabel?.numberOfLines = 2
                
        dropDownButton.layer.cornerRadius = 6
        
        dropDownButton.addTarget(self, action: #selector(dropDownButtonTapped(_:)), for: .touchUpInside)
                
        return dropDownButton
    }()
    
    init() {
        super.init(frame: .zero)
                
        addSubview(sportsButton)
        NSLayoutConstraint.activate([
            sportsButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -4),
            sportsButton.widthAnchor.constraint(equalToConstant: 120),
            sportsButton.topAnchor.constraint(equalTo: topAnchor,
                                                constant: 4),
            sportsButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -4)
        ])
        
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: sportsButton.leadingAnchor,
                                               constant: -0),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard sportsButtonShapeLayer == nil,
              sportsButton.bounds.size != .zero else {
            return
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: sportsButton.bounds,
                                       cornerRadius: sportsButton.layer.cornerRadius).cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.5
        
        sportsButton.layer.addSublayer(shapeLayer)
        
        sportsButtonShapeLayer = shapeLayer
    }
    
    @objc
    private func dropDownButtonTapped(_ sender: UIButton) {
        delegate?.didPressSportsButton(searchView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
                              
extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBar(searchBar, textDidChange: searchText)
    }
}
