import UIKit

class LiveTableViewCell: EventsTableViewCell {
    
    private let leagueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .center
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var homeScoreLabel = createScoreLabel()
    private lazy var awayScoreLabel = createScoreLabel()
    
    private lazy var statusLabel = createScoreLabel()
        
    override func viewModelDidSet(_ viewModel: EventsTableViewCellViewModel) {
        super.viewModelDidSet(viewModel)
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.setLeagueTitle(model.league)
                self?.homeScoreLabel.text = "Score: " + (model.homeScore ?? "0")
                self?.awayScoreLabel.text = "Score: " + (model.awayScore ?? "0")
                
            }
            .store(in: &cancellables)
        
        addSubview(leagueLabel)
        NSLayoutConstraint.activate([
            leagueLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 12),
            leagueLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -12),
            leagueLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 12),
            
            homeTeamLabel.topAnchor.constraint(equalTo: leagueLabel.bottomAnchor,
                                               constant: 12),
            awayTeamLabel.topAnchor.constraint(equalTo: leagueLabel.bottomAnchor,
                                               constant: 12),
            
            homeTeamLabel.trailingAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: -28),
            awayTeamLabel.leadingAnchor.constraint(equalTo: centerXAnchor,
                                                   constant: 28)
        ])
        
        addSubview(homeScoreLabel)
        NSLayoutConstraint.activate([
            homeScoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -12),
            homeScoreLabel.centerXAnchor.constraint(equalTo: homeTeamLabel.centerXAnchor)
        ])
        
        addSubview(awayScoreLabel)
        NSLayoutConstraint.activate([
            awayScoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -12),
            awayScoreLabel.centerXAnchor.constraint(equalTo: awayTeamLabel.centerXAnchor)
        ])
        
    }
    
    private func setLeagueTitle(_ text: String?) {
        guard let text = text else {
            return
        }
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor : UIColor.betanoOrange,
                .font : UIFont(name: "Copperplate Bold", size: 24) ?? .boldSystemFont(ofSize: 22),
                .underlineColor : UIColor.lightGray,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]
        )
        
        leagueLabel.attributedText = attributedString
    }
    
    private func createScoreLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
    
}
