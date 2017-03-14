//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Keerthi Shekar G on 14/03/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    let animals = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    let cellReuseIdentifier = "taskTableViewCell"
    
    var sortButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Setting Title and Buttons of Nav Bar
        
        self.navigationController?.navigationBar.topItem?.title = "Task List";
        
        
        let newButton = UIButton(type: .custom)
        newButton.setBackgroundImage(UIImage(named: "new"), for: .normal)
        newButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        newButton.addTarget(self, action: #selector(self.addNew), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: newButton)
        
        self.navigationItem.rightBarButtonItem = item1
        
        sortButton = UIButton(type: .custom)
        sortButton.setTitle("Name", for: UIControlState.normal)
        sortButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sortButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        sortButton.addTarget(self, action: #selector(self.sortBy(button:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: sortButton)
        
        self.navigationItem.leftBarButtonItem = item2
       
        
        
        tableView.frame = CGRect(x:0,y:0,width:self.view!.frame.size.width,height:self.view!.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = animals[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func addNew() {
        print("Add new Task")
    }
    
    func sortBy(button:UIButton){
        
        //Sort Based on selected Parameter
        if((button.title(for: UIControlState.normal)) == "Name"){
            
            sortButton.setTitle("Date", for: UIControlState.normal)
            //Query to fetch Tasks based on Date
            
        }else if((button.title(for: UIControlState.normal)) == "Date"){
            
            sortButton.setTitle("Name", for: UIControlState.normal)
            //Query to fetch Tasks based on Name
            
        }
        
        
    }
    
}
