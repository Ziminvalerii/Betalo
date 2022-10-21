import UIKit
import WebKit

class WebViewController: BaseVC {
    
    private var webView: WKWebView!
    
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        webView.load(URLRequest(url: url))
        view.addSubview(webView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
