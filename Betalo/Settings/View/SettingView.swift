import UIKit

protocol SettingViewDelegate: AnyObject {
    func settingView(_ settingView: SettingView, settingDidPerformAction setting: SettingView.Setting)
}

class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate?
    
    enum Setting: Equatable {
        case notifications(Bool)
        case privacyPolicy
        case brightness(CGFloat)
        case shareApp
        
        var title: String {
            switch self {
            case .notifications:
                return "Notifications"
            case .privacyPolicy:
                return "Privacy Policy"
            case .brightness:
                return "Brightness"
            case .shareApp:
                return "Share App"
            }
        }
        
    }
    
    let type: Setting
    
    init(type: Setting, delegate: SettingViewDelegate?) {
        self.delegate = delegate
        self.type = type
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        
        switch type {
        case .notifications(let isOn):
            createSwitch(isOn: isOn)
        case .privacyPolicy:
            createButton(imageName: "chevron.right")
        case .brightness(let value):
            createStepper(value: value)
        case .shareApp:
            createButton(imageName: "arrowshape.turn.up.forward.fill")
        }
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.text = type.title
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)
        ])
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    @objc
    private func uiSwitchDidChangeValue(_ sender: UISwitch) {
        delegate?.settingView(self, settingDidPerformAction: .notifications(sender.isOn))
    }
    
    @objc
    private func buttonPressed(_ sender: UIButton) {
        delegate?.settingView(self, settingDidPerformAction: type)
    }
    
    @objc
    private func stepperDidChangeValue(_ sender: UIStepper) {
        delegate?.settingView(self, settingDidPerformAction: .brightness(sender.value))
    }
    
    private func createSwitch(isOn: Bool) {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.isOn = isOn
        uiSwitch.addTarget(self, action: #selector(uiSwitchDidChangeValue(_:)), for: .valueChanged)
        
        addSubview(uiSwitch)
        NSLayoutConstraint.activate([
            uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func createButton(imageName: String) {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 32)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        let widthConstraintMultiplier = (type == .privacyPolicy) ? 0.75 : 1.1
        addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -16),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor,
                                           multiplier: 0.6),
            button.widthAnchor.constraint(equalTo: button.heightAnchor,
                                          multiplier: widthConstraintMultiplier)
        ])
    }
    
    private func createStepper(value: Double) {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.stepValue = 0.1
        stepper.value = value
        
        stepper.addTarget(self, action: #selector(stepperDidChangeValue(_:)), for: .valueChanged)
        
        addSubview(stepper)
        NSLayoutConstraint.activate([
            stepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
