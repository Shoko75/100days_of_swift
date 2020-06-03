//
//  ViewController.swift
//  Project7_WhitehousePetitions
//
//  Created by Shoko Hashimoto on 2020-06-02.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var petitions = [Petition]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do fetchJSON task in the background
		performSelector(inBackground: #selector(fetchJSON), with: nil)
	}
	
	@objc func fetchJSON() {
		let urlString: String
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
			
		
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parse(json: data)
				return
			}
		}
		
		// If there is an error, show an error alert on Main thread
		performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
	
	}
	
	// Show error
	@objc func showError() {
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	// Parse the jsondata
	func parse(json: Data) {
		let decoder = JSONDecoder()

		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
				petitions = jsonPetitions.results
			
			// Update tableview on the main thread
			tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
		} else {
			// Show error on the main thread
			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
		}
	}
}

//MARK: UITableview
extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return petitions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let petition = petitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
}
