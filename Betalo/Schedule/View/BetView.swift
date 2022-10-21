import UIKit

protocol BetViewDelegate: AnyObject {
    func betView(_ betView: BetView, didCreateEventBet savedModel: SavedEventModel)
}

class BetView: UIView {
    
    weak var delegate: BetViewDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        let width = bounds.width * 0.8
        let height = width * 0.75
        
        view.frame.size = CGSize(width: width, height: height)
        view.center = CGPoint(x: center.x,
                              y: center.y - 64)
        
        view.layer.cornerRadius = 12
        
        view.backgroundColor = .secondarySystemBackground
        
        return view
    }()
    
    var textColor: UIColor = .black
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.tintColor = textColor
        button.setBackgroundImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var eventLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Copperplate Bold", size: 32)
        label.textColor = textColor
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.4
        
        return label
    }()
    
    private lazy var betLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = textColor
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.4
        
        return label
    }()
    
    private var betButtonShapeLayer: CAShapeLayer?
    
    private lazy var betButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .opaqueSeparator
        button.setTitle("Bet", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate Bold", size: 24)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(betTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray
        textField.attributedPlaceholder = NSAttributedString(
            string: "Type bet amount $",
            attributes: [
                .foregroundColor : containerView.backgroundColor ?? UIColor.lightGray
            ]
        )
        textField.textColor = textColor
        textField.textAlignment = .center
        textField.font = .boldSystemFont(ofSize: 18)
//        textField.placeholder = "Type bet amount $"
        textField.layer.cornerRadius = 4
        textField.keyboardType = .decimalPad
        textField.becomeFirstResponder()
        textField.delegate = self
        return textField
    }()
    
    private let event: EventModel
    private let team: Team
    
    init(event: EventModel, team: Team) {
        self.event = event
        self.team = team
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .black.withAlphaComponent(0.6)
        
        containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        addSubview(containerView)
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                  constant: -12),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor,
                                             constant: 12),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        eventLabel.text = event.event
        containerView.addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 16),
            eventLabel.topAnchor.constraint(equalTo: closeButton.centerYAnchor),
            eventLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor,
                                                 constant: -20),
            eventLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
        let mutableAttributedString = NSMutableAttributedString()
        
        mutableAttributedString.append(
            NSAttributedString(
                string: "Win : ",
                attributes: [
                    .foregroundColor : textColor,
                    .font : UIFont.boldSystemFont(ofSize: 22)
                ]
            )
        )
        
        mutableAttributedString.append(
            NSAttributedString(
                string:  team.string + " - ",
                attributes: [
                    .foregroundColor : textColor,
                    .font : UIFont.italicBoldSystemFont(ofSize: 22) ?? .boldSystemFont(ofSize: 22)
                ]
            )
        )
        
        mutableAttributedString.append(
            NSAttributedString(
                string: "x\( team == .home ? (event.homeOdd ?? "1.0") : (event.awayOdd ?? "1.0") )",
                attributes: [
                    .foregroundColor : textColor,
                    .font : UIFont.boldSystemFont(ofSize: 22)
                ]
            )
        )
        
        betLabel.attributedText = mutableAttributedString
        containerView.addSubview(betLabel)
        NSLayoutConstraint.activate([
            betLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            betLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                               constant: -16),
            betLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor,
                                          constant: 8),
            betLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        containerView.addSubview(betButton)
        NSLayoutConstraint.activate([
            betButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                              constant: -16),
            betButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            betButton.widthAnchor.constraint(equalToConstant: 200),
            betButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        containerView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                               constant: 32),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                constant: -32),
            textField.bottomAnchor.constraint(equalTo: betButton.topAnchor,
                                              constant: -16),
            textField.topAnchor.constraint(equalTo: betLabel.bottomAnchor,
                                           constant: 16),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        alpha = 0
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 1
            self?.containerView.transform = .identity
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if betButtonShapeLayer == nil {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 200, height: 40),
                                           cornerRadius: betButton.layer.cornerRadius).cgPath
            shapeLayer.strokeColor = UIColor.darkGray.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 1.0
            
            betButton.layer.addSublayer(shapeLayer)
            betButtonShapeLayer = shapeLayer
            
        }
    }
    
    @objc
    private func close() {
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.alpha = 0
            self?.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    @objc
    private func betTapped() {
        guard let text = textField.text,
              let amount = Double(text),
              amount > 0 else {
            
            shakeTextField()
            return
        }
        
        let savedModel = SavedEventModel(event: event,
                                         betAmount: amount,
                                         team: team)
        
        delegate?.betView(self, didCreateEventBet: savedModel)
        close()
    }
    
    private func shakeTextField() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 2, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 2, y: textField.center.y))
        
        
        textField.layer.add(animation, forKey: "position")
    }
    
    private func createLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.numberOfLines = 2
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BetView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")
    }
}
