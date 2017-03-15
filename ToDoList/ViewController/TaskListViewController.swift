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


class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating{
    
    var taskLists : Results<ToDoTask>!
    let searchController = UISearchController(searchResultsController: nil)
    
    var todoTableView: UITableView = UITableView()
    let cellReuseIdentifier = "taskTableViewCell"
    var sortButton = UIButton(type: .custom)
    var currentCreateAction:UIAlertAction!
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
        sortButton.setTitle("Date", for: UIControlState.normal)
        sortButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sortButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        sortButton.addTarget(self, action: #selector(self.sortBy(button:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: sortButton)
        
        self.navigationItem.leftBarButtonItem = item2
       
        todoTableView.frame = CGRect(x:0,y:0,width:self.view!.frame.size.width,height:self.view!.frame.height)
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        todoTableView.tableHeaderView = searchController.searchBar
        
        self.view.addSubview(todoTableView)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ToDoTableViewCell
        
        let list = taskLists[indexPath.row]
        
        cell.taskNameLabel.text = list.taskName
        cell.taskDescriptionLabel.text = list.taskDescription
        cell.createdAtLabel.text = DateFormatter.localizedString(from: list.taskCreatedAt as Date, dateStyle: .short, timeStyle: .short)
        cell.doneImage.image = nil
        if(list.isCompleted){
            cell.doneImage.image = UIImage(named: "isDone")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.displayAlertShowTask(taskLists[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let listToBeDeleted = taskLists[indexPath.row]
            try! uiRealm.write{
                
                uiRealm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            }
        }
    }
    
    func readTasksAndUpdateUI(){
        
        taskLists = uiRealm.objects(ToDoTask.self)
        self.reloadBasedOnSortSelected()
    }
    
    func addNew() {
        
        self.displayAlertToAddTask(nil)
    }
    
    //Change the UI and Call ReloadBased on Sort
    func sortBy(button:UIButton){
        
        //Sort Based on selected Parameter
        if((button.title(for: UIControlState.normal)) == "Name"){
            
            sortButton.setTitle("Date", for: UIControlState.normal)
            
        }else if((button.title(for: UIControlState.normal)) == "Date"){
            
            sortButton.setTitle("Name", for: UIControlState.normal)
            
        }
        self.reloadBasedOnSortSelected()
        
    }
    
    func reloadBasedOnSortSelected() {
        //Sort Based on selected Parameter
        if((sortButton.title(for: UIControlState.normal)) == "Name"){
            //Query to fetch Tasks based on CreatedAt
            taskLists = taskLists!.sorted(byKeyPath: "taskName", ascending: true)
            
            
        }else if((sortButton.title(for: UIControlState.normal)) == "Date"){
            
            //Query to fetch Tasks based on TaskName
            taskLists = taskLists!.sorted(byKeyPath: "taskCreatedAt", ascending: true)
            
        }
        //Reload the table to make sort changes
        todoTableView.reloadData()
    }
    //Display Task
    func displayAlertShowTask(_ updatedTask:ToDoTask!){
        let alertController = UIAlertController(title: updatedTask.taskName, message: "\(updatedTask.taskDescription) created at \(updatedTask.taskCreatedAt)", preferredStyle: UIAlertControllerStyle.alert)
        let completeAction = UIAlertAction(title: "Complete Task", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if updatedTask != nil{
                // update mode
                try! uiRealm.write{
                    updatedTask.isCompleted = true
                    self.readTasksAndUpdateUI()
                }
            }
            
        }
        if updatedTask.isCompleted{
            completeAction.isEnabled = false
        }
        
        alertController.addAction(completeAction)
        
        
       let updateAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.default){ (action) -> Void in
            
            if updatedTask != nil{
                // update mode
                self.displayAlertToAddTask(updatedTask)
            }
            
        }
        alertController.addAction(updateAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    //Create or Edit Task
    func displayAlertToAddTask(_ updatedTask:ToDoTask!){
        
        var title = "New Task"
        var doneTitle = "Create"
        var titleDescription = "Write the name of your task with description"
        
        if updatedTask != nil{
            title = "Update Task"
            doneTitle = "Update"
            titleDescription = "Make changes to Task"
        }
        
        let alertController = UIAlertController(title: title, message: titleDescription, preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            let taskDescription = alertController.textFields?.last?.text
            
            if updatedTask != nil{
                // update mode
                try! uiRealm.write{
                    updatedTask.taskName = taskName!
                    updatedTask.taskDescription = taskDescription!
                    self.readTasksAndUpdateUI()
                }
            }
            else{
                //Create New Task
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
            if updatedTask != nil{
                textField.text = updatedTask.taskName
            }else{
                textField.placeholder = "Task Name"
            }
            
        }
        alertController.addTextField { (textField) -> Void in
            if updatedTask != nil{
                textField.text = updatedTask.taskDescription
            }else{
                textField.placeholder = "Task Description"
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

    //Search Bar Delegates
    //Search TaskName and TaskDescription
    func updateSearchResults(for searchController: UISearchController) {
        
        taskLists = uiRealm.objects(ToDoTask.self).filter("taskName contains [c] '\(searchController.searchBar.text!)' OR taskDescription contains [c] '\(searchController.searchBar.text!)'")
        
        self.reloadBasedOnSortSelected()
    }
}
