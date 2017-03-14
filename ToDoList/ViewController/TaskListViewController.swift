//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Keerthi Shekar G on 14/03/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    let animals = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    let cellReuseIdentifier = "taskTableViewCell"
    var currentCreateAction:UIAlertAction!
    var taskLists : Results<ToDoTask>!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Nil Check
        if let taskLists = taskLists{
            return taskLists.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let list = taskLists[indexPath.row]
        
        cell.textLabel?.text = list.taskName
        cell.detailTextLabel?.text = list.taskDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func readTasksAndUpdateUI(){
        
        taskLists = uiRealm.objects(ToDoTask.self)
        tableView.reloadData()
    }
    
    func addNew() {
        print("Add new Task")
        
        self.displayAlertToAddTask(nil)
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
    
    //Create or Edit Task
    func displayAlertToAddTask(_ updatedList:ToDoTask!){
        
        let title = "New Task"
        let doneTitle = "Create"
        
        let alertController = UIAlertController(title: title, message: "Write the name of your task with description", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            let taskDescription = alertController.textFields?.last?.text
            
            if updatedList != nil{
                // update mode
                try! uiRealm.write{
                    updatedList.taskName = taskName!
                    self.readTasksAndUpdateUI()
                }
            }
            else{
                
                let newTask = ToDoTask()
                newTask.taskName = taskName!
                newTask.taskDescription = taskDescription!
                
                try! uiRealm.write{
                    
                    uiRealm.add(newTask)
                    self.readTasksAndUpdateUI()
                }
            }
            
        }
        
        alertController.addAction(createAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task Name"
        }
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task Description"
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    
}
