import UIKit
//import AuthenticationServices

class SettingsViewController: BaseVC {
    
    var viewModel: SettingsViewModel! {
        didSet {
            photoImageView.image = viewModel?.userImage()
        }
    }
    
    private var photoShapeLayer: CAShapeLayer?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "male-avatar")
        return imageView
    }()
    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .italicBoldSystemFont(ofSize: 32)
//        label.textColor = .black
//        label.text = "Aram Khangeldyan"
//        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .center
//        return label
//    }()
    
    private var stackViewShapeLayer: CAShapeLayer?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        stackView.backgroundColor = .gray
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let cameraButton = UIBarButtonItem(
            image: UIImage(systemName: "camera.fill"),
            style: .done,
            target: self,
            action: #selector(cameraTapped)
        )
        cameraButton.tintColor = .black
        navigationItem.rightBarButtonItem = cameraButton
        
        view.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: 16),
            photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                  multiplier: 0.4),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor)
        ])
        
//        view.addSubview(nameLabel)
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor,
//                                           constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
//                                               constant: 32),
//            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
//                                                constant: -32)
//        ])
        
        let stackViewBottomConstraint = stackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -32
        )
        stackViewBottomConstraint.priority = .defaultLow
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor,
                                           constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -32),
            stackViewBottomConstraint
        ])
        
        
        
        let settings: [SettingView.Setting] = [
            .notifications(viewModel.notificationsEnabled),
            .brightness(UIScreen.main.brightness),
            .privacyPolicy,
            .shareApp
        ]
        
        settings.forEach { setting in
            stackView.addArrangedSubview(SettingView(type: setting, delegate: self))
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if photoShapeLayer == nil, photoImageView.bounds.size != .zero {
            photoShapeLayer = addShape(
                to: photoImageView,
                cornerRadius: photoImageView.bounds.width / 2,
                strokeColor: UIColor.black.cgColor
            )
        }
        
        if stackViewShapeLayer == nil, stackView.bounds.size != .zero {
            stackViewShapeLayer = addShape(
                to: stackView,
                cornerRadius: 16,
                strokeColor: stackView.backgroundColor?.cgColor ?? UIColor.black.cgColor
            )
        }

    }
    
    private func addShape(to view: UIView, cornerRadius: CGFloat, strokeColor: CGColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds,
                                       cornerRadius: cornerRadius).cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
        
        view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    @objc
    private func cameraTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    
        present(imagePickerController, animated: true)
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            photoImageView.image = image
            viewModel?.saveUserImage(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension SettingsViewController: SettingViewDelegate {
    func settingView(_ settingView: SettingView, settingDidPerformAction setting: SettingView.Setting) {
        switch setting {
        case .privacyPolicy:
            guard let url = URL(string: viewModel.privacyPolicyLink) else {
                return
            }
            let webController = WebViewController(url: url)
            webController.modalPresentationStyle = .formSheet
            webController.modalTransitionStyle = .coverVertical
            present(webController, animated: true)
        case .shareApp:
            guard let link = URL(string: viewModel.appStoreLink) else {
                return
            }
            let activityVC = UIActivityViewController(activityItems: [link],
                                                      applicationActivities: nil)
            present(activityVC, animated: true)
        case .brightness(let value):
            UIScreen.main.brightness = value
        case .notifications(let isOn):
            viewModel.notificationsEnabled = isOn
        }
    }
}


//    private let signInButton = ASAuthorizationAppleIDButton()


//        signInButton.frame.size = CGSize(width: 250, height: 50)
//        signInButton.center = view.center
//        view.addSubview(signInButton)
//
//        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)

//    @objc
//    private func signInTapped() {
//        let provider = ASAuthorizationAppleIDProvider()
//        let request = provider.createRequest()
//        request.requestedScopes = [.fullName]
//
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }

//extension SettingsViewController: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print(error)
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            return
//        }
//
//        let userID = credential.user
//        let name = credential.fullName?.givenName ?? "No"
//        let lastName = credential.fullName?.familyName ?? "No"
//        let email = credential.email ?? "No"
//
//        print("User ID: \(userID)")
//        print("Name: \(name)")
//        print("Last name: \(lastName)")
//        print("Email: \(email)")
//    }
//}
//
//extension SettingsViewController: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return view.window!
//    }
//}
