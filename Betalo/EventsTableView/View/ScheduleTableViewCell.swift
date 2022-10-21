import UIKit
import Combine

class EventsTableViewCell: UITableViewCell {
    
    var cancellables = Set<AnyCancellable>()

    var viewModel: EventsTableViewCellViewModel! {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            viewModelDidSet(viewModel)
        }
    }
    
    let homeTeamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.35
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let awayTeamLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.35
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    func viewModelDidSet(_ viewModel: EventsTableViewCellViewModel) {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.homeTeamLabel.text = model.homeTeam
                self?.awayTeamLabel.text = model.awayTeam
            }
            .store(in: &cancellables)
        
        addSubview(homeTeamLabel)
        NSLayoutConstraint.activate([
            homeTeamLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 16),
            homeTeamLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addSubview(awayTeamLabel)
        NSLayoutConstraint.activate([
            awayTeamLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -16),
            awayTeamLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

class ScheduleTableViewCell: EventsTableViewCell {
    
    let oddButtonAction = PassthroughSubject<(EventModel, Team), Never>()
              
    private var homeOddButtonGradient: CAGradientLayer?
    private lazy var homeOddButton: UIButton = createButton(.home)
        
    private var awayOddButtonGradient: CAGradientLayer?
    private lazy var awayOddButton: UIButton = createButton(.away)

    private lazy var timeLabel: UILabel = createLabel(aligment: .center, italic: true)
    
    override func viewModelDidSet(_ viewModel: EventsTableViewCellViewModel) {
        super.viewModelDidSet(viewModel)
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.timeLabel.text = model.eventTime
                self?.homeOddButton.setTitle(model.homeOdd, for: .normal)
                self?.awayOddButton.setTitle(model.awayOdd, for: .normal)
            }
            .store(in: &cancellables)
        
        backgroundColor = .white
        
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: homeTeamLabel.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 100),
            
            timeLabel.leadingAnchor.constraint(equalTo: homeTeamLabel.trailingAnchor,
                                               constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: awayTeamLabel.leadingAnchor,
                                                constant: -8),
            
            homeTeamLabel.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 12),
            awayTeamLabel.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 12)
        ])
        
        addSubview(homeOddButton)
        NSLayoutConstraint.activate([
            homeOddButton.centerXAnchor.constraint(equalTo: homeTeamLabel.centerXAnchor),
            homeOddButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -16),
            homeOddButton.widthAnchor.constraint(equalToConstant: 100),
            homeOddButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        addSubview(awayOddButton)
        NSLayoutConstraint.activate([
            awayOddButton.centerXAnchor.constraint(equalTo: awayTeamLabel.centerXAnchor),
            awayOddButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -16),
            awayOddButton.widthAnchor.constraint(equalToConstant: 100),
            awayOddButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if homeOddButtonGradient == nil, homeOddButton.bounds.size != .zero {
            homeOddButtonGradient = addGradient(to: homeOddButton)
        }
        
        if awayOddButtonGradient == nil, awayOddButton.bounds.size != .zero {
            awayOddButtonGradient = addGradient(to: awayOddButton)
        }
    }

    @objc
    private func oddButtonTapped(_ sender: UIButton) {
        guard let team = Team(rawValue: sender.tag),
              let viewModel = viewModel else {
            return
        }
        
        oddButtonAction.send((viewModel.model, team))
    }

    private func createLabel(aligment: NSTextAlignment, italic: Bool = false) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = italic ? .italicSystemFont(ofSize: 18) : .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = aligment
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.35
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    private func createButton(_ team: Team) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.tag = team.rawValue
        button.addTarget(self, action: #selector(oddButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func addGradient(to view: UIView) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor.betanoYellow.cgColor,
            UIColor.betanoOrange.cgColor
        ]
        gradient.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}
