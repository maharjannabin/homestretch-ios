
//
//  ViewController.swift
//  Home Strech
//
//  Created by Nabin Maharjan on 17/11/2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate{
    
    let webView: WKWebView = {
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.defaultWebpagePreferences = prefs
        configuration.allowsInlineMediaPlayback = true
        
        
        configuration.preferences = wkPreferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
                
    }()
    
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
    
        return nil
   
    }
    
    
    override func viewDidLoad() {
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        self.webView.frame = self.view.bounds
        
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://homestretch.nfmlending.com") else {
            return
        }
//
//         guard let url = URL(string: "http://192.168.1.83:3100") else {
//             return
//         }
        

        webView.load(URLRequest(url: url))
        self.webView.allowsBackForwardNavigationGestures = true
    
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
//            self.webView.evaluateJavaScript("document.body.innerHTML") { result, error in
//                guard let html = result as? String, error == nil else {
//                    return
//                }
//                //print(html)
//            }
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard
            let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
        }
        
        let string = url.absoluteString
        if (string.contains("mailto:")) || (string.contains("sms:"))  || (string.contains("facebook.com")) || (string.contains("twitter.com")){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)

            return
        }
        else if (string.contains("about:")){
            printContent(url: url)
            decisionHandler(.cancel)

            return
        }
        
        decisionHandler(.allow)
    }
    
    private func printContent(url: URL) {
        let webviewPrint = webView.viewPrintFormatter()
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = "page"
            printInfo.outputType = .general
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            printController.printFormatter = webviewPrint
            printController.present(animated: true, completionHandler: nil)
    }

}
