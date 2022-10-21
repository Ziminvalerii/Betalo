import UIKit

protocol DropDownViewDataSource: AnyObject {
    func numberOfRows(inDropDownView dropDownView: DropDownView) -> Int
    func dropDownView(_ dropDownView: DropDownView, buttonForRow row: Int) -> DropDownViewButton
}

protocol DropDownViewDelegate: AnyObject {
    func dropDownView(_ dropDownView: DropDownView, didSelectButton button: DropDownViewButton)
}

class DropDownView: UIStackView {

    weak var delegate: DropDownViewDelegate?

    weak var dataSource: DropDownViewDataSource? {
        didSet {
            setupButtons()
        }
    }
    
    var heightForRow: CGFloat = 40.0 {
        didSet {
            reloadData()
        }
    }
        
    var isOpen: Bool = false {
        didSet {
            setOpen(isOpen)
        }
    }
    
    private(set) lazy var heightConstraint = heightAnchor.constraint(equalToConstant: 0)

    init() {
        super.init(frame: .zero)

        axis = .vertical
        isUserInteractionEnabled = true
        
        backgroundColor = .placeholderText
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
    }
    
    func reloadData() {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        setupButtons()
    }

    private func setOpen(_ open: Bool) {
        if open { becomeFirstResponder() }
        UIView.animate(withDuration: 0.2) { [weak self] in

            self?.arrangedSubviews
                .compactMap({$0 as? DropDownViewButton})
                .forEach {
                    guard let height = self?.heightForRow else {
                        return
                    }
                    $0.heightConstraint.constant = open ? height : 0
                    $0.alpha = open ? 1 : 0
                }

            self?.heightConstraint.isActive = !open

            self?.layoutIfNeeded()
            self?.superview?.layoutIfNeeded()
        }
    }

    private func setupButtons() {
        guard let dataSource = self.dataSource else {
            return
        }

        let buttonsCount = dataSource.numberOfRows(inDropDownView: self)

        for row in 0..<buttonsCount {
            let button = dataSource.dropDownView(self, buttonForRow: row)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = row

            button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)

            addArrangedSubview(button)
            button.alpha = 0
            button.heightConstraint.isActive = true
        }
    }
    
    @objc
    private func tapped(_ sender: DropDownViewButton) {
        delegate?.dropDownView(self, didSelectButton: sender)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropDownViewButton: UIButton {
    private(set) lazy var heightConstraint = heightAnchor.constraint(equalToConstant: 0)
}
