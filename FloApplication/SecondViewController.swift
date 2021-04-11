//
//  SecondViewController.swift
//  FloApplication
//
//  Created by 이수연 on 2021/03/16.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return playingLyrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = playingLyrics[indexPath.row]
        cell.textLabel?.textAlignment = .center
        self.tableView.separatorStyle = .none
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
}

