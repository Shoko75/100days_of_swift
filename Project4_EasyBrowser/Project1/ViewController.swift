//
//  ViewController.swift
//  Project1
//
//  Created by Shoko Hashimoto on 2020-06-01.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

	var webView: WKWebView!
	var progressView: UIProgressView!
	var websites = ["apple.com", "hackingwithwift.com"]
	
	// This view is called before viewDidLoad
	override func loadView() {
		// Prepare webview
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Navigation item setting
		setNavigationItem()
		
		// URL setting
		let url = URL(string: "https://" + websites[0])!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		
	}
	
	// NavigationItem setting
	func setNavigationItem() {
		// Top
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
		// Buttom
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		
		// Progress setting that showing how much load already done
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		
		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.isToolbarHidden = false
		
		// Observe setting to see a progress of loading
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}

	// Open tap action shwing UIAlert actionsheet
	@objc func openTapped() {
		
		let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
		
		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}
	
	// Load recieving url
	func openPage(action: UIAlertAction) {
		
		guard let actionTitle = action.title,
					let url = URL(string: "https://" + actionTitle) else { return }
		
		webView.load(URLRequest(url: url))
	}
	
	// Observe receiver. When an observed value has changed, this method is gonna called.
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func showNotAllowedAlert() {
		let al = UIAlertController(title: "Alert", message: "this page is not exist", preferredStyle: .alert)
		present(al, animated: true)
	}
}

extension ViewController: WKNavigationDelegate {
	
	// Set webpage title
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	// Decide wether to allow or cancel a navigation
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		
		if let host = url?.host {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
		}
		
		decisionHandler(.cancel)
		
	}
}


