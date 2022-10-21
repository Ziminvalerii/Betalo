import UIKit

class BetsTableViewCell: UITableViewCell {
    
    let sportLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 24)
        label.textColor = .betanoOrange
        label.textAlignment = .left
        return label
    }()
    
    let betLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    }()
    
    let eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .betGreen
        label.textAlignment = .right
        
        return label
    }()
    
    
    func configure(with model: SavedEventModel) {
        let sportAttributedString = NSAttributedString(
            string: model.sport,
            attributes: [
                .foregroundColor : UIColor.betanoOrange,
                .font : UIFont(name: "Copperplate Bold", size: 26) ?? .boldSystemFont(ofSize: 24),
                .underlineColor : UIColor.lightGray,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]
        )
        sportLabel.attributedText = sportAttributedString
        addSubview(sportLabel)
        NSLayoutConstraint.activate([
            sportLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 12),
            sportLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: 12)
        ])
        
        betLabel.text = "Win: \(model.betTeam.string)"
        addSubview(betLabel)
        NSLayoutConstraint.activate([
            betLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -12),
            betLabel.topAnchor.constraint(equalTo: sportLabel.bottomAnchor,
                                          constant: 0),
            betLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        eventLabel.text = model.event
        addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 12),
            eventLabel.trailingAnchor.constraint(equalTo: betLabel.leadingAnchor,
                                                 constant: -20),
            eventLabel.topAnchor.constraint(equalTo: sportLabel.bottomAnchor,
                                            constant: 12)
        ])
        
        let odd = String(describing: model.betTeam == .home ? (model.homeOdd ?? "") : (model.awayOdd ?? "") )
        amountLabel.text = String(describing: model.betAmount) + "$ " + "x\(odd)"
        addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: betLabel.trailingAnchor),
            amountLabel.topAnchor.constraint(equalTo: betLabel.bottomAnchor,
                                             constant: 12),
            amountLabel.widthAnchor.constraint(equalTo: betLabel.widthAnchor)
        ])
    }
    
}
