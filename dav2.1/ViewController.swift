//
//  ViewController.swift
//  d
//
//  Created by AMK on 09/01/16.
//  Copyright © 2016 AMK. All rights reserved.
//
//test

import UIKit
import RealmSwift

class Sticker: Object {
    dynamic var stickerId = ""
    dynamic var stickerName = ""
    dynamic var backgroundColor = ""
    dynamic var xPosition: Float = 0.0
    dynamic var yPosition: Float = 0.0
    dynamic var width: Float = 0.0
    dynamic var height: Float = 0.0
    dynamic var text: String? = nil
    dynamic var dateCreated: NSDate? = nil
    dynamic var dateUpdated: NSDate? = nil
    dynamic var fileName: StickerFile?
    var owningFile: [StickerFile]{
        return linkingObjects(StickerFile.self, forProperty: "stickers")
    }
    
}

class StickerFile: Object {
    dynamic var fileName = ""
    dynamic var dateCreated: NSDate? = nil
    dynamic var dateUpdated: NSDate? = nil
    let stickers = List<Sticker>()
    override static func indexedProperties() -> [String] {
        return ["fileName"]
    }

    
}



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var stickerDictionary = [UIView]()
    let allFilesTableView = UITableView()
    var retrievedFileNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSaveButton()
        makeButtonCreateSticker()
        makeViewAllFilesButton()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int)->Int{
        return self.retrievedFileNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell{
        let cell:UITableViewCell = allFilesTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.retrievedFileNames[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        let pathToIndex = tableView.indexPathForSelectedRow
        let tappedCell = tableView.cellForRowAtIndexPath(pathToIndex!)! as UITableViewCell
        
        let newFile = tappedCell.textLabel?.text
        
        let predicate = NSPredicate(format: "fileName == %@", newFile!)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count == 0){
            for view in self.view.subviews{
                if (view.tag == 5){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = "File With File Name ("+newFile!+") does not exist"
                        }
                    }
                }
            }
            
            for view in self.view.subviews{
                if (view.tag == 4){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = "File With File Name ("+newFile!+") does not exist"
                        }
                    }
                }
            }

            
            for view in self.view.subviews{
                if (view.tag == 1){
                    for case let button as UIButton in view.subviews{
                        if (button.tag == 20){
                            let currentButtonState = "Cannot Add Stickers to The Current File:  ("+newFile!+") does not exist"
                            button.setTitle(currentButtonState, forState: UIControlState.Normal)
                            
                        }
                    }
                }
            }
            
            
        }
        
        
        if(retrievedFileNames.count != 0){
            for view in self.stickerDictionary{
                view.removeFromSuperview()
            }
            stickerDictionary.removeAll()
            
            let firstFile = retrievedFileNames.first?.stickers
            for sticker in firstFile! {
                makeStickerFromFile(sticker)// Adds stickers to the dictionary
            }
            
            for (index,sticker) in stickerDictionary.enumerate(){
                sticker.tag = index
                for case let textField as UITextField in sticker.subviews{
                    if (textField.tag == 2){
                        textField.text = "Sticker Number "+String(index+1)
                    }
                    self.view.addSubview(sticker)
                }
            }
            
            //Update view all files pane
            for view in self.view.subviews{
                if (view.tag == 4){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = newFile!
                        }
                    }
                }
            }
            
            
            //Update view all files pane
            for view in self.view.subviews{
                if (view.tag == 5){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = "Currently Viewing"+"("+newFile!+")"
                        }
                    }
                }
            }
            
            //Update Button text
                    for case let button as UIButton in self.view.subviews{
                        if (button.tag == 20){
                            let currentButtonState = "Add Stickers to The Current File:"+"("+newFile!+")"
                            button.setTitle(currentButtonState, forState: UIControlState.Normal)
                            
                        }
                    }
            
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.redColor()
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonCreateSticker(){
        //Search for the current file name
        var currentFileName = ""
        for view in self.view.subviews{
            if (view.tag == 4){
                for case let textField as UITextField in view.subviews{
                    if (textField.tag == 5){
                        currentFileName = textField.text!
                    }
                }
            }
        }
        let currentFile = "Add Stickers to The Current File: ("+currentFileName+")"
        let buttonCreateSticker:UIButton! = UIButton(type: .System)
        buttonCreateSticker.frame = CGRectMake(180, 30, 160, 30)
        buttonCreateSticker.layer.cornerRadius = 5
        buttonCreateSticker.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonCreateSticker.titleLabel?.numberOfLines = 0
        buttonCreateSticker.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonCreateSticker.backgroundColor = UIColor.greenColor()
        buttonCreateSticker.setTitle(currentFile, forState: UIControlState.Normal)
        buttonCreateSticker.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonCreateSticker.addTarget(self, action: "buttonCreateStickerPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonCreateSticker)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        buttonCreateSticker.addGestureRecognizer(gesture)
        buttonCreateSticker.userInteractionEnabled = true
        buttonCreateSticker.tag = 20
        
    }
    
    
    //Button action method
    func buttonCreateStickerPressed(sender: UIButton!){
        let stickerName = "Sticker Number "+String(stickerDictionary.count+1)
        let stickerNumber = stickerDictionary.count+1
        makeSticker(stickerName, stickerNumber: stickerNumber)
        for (index,sticker) in stickerDictionary.enumerate(){
            sticker.tag = index
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 2){
                    textField.text = "Sticker Number "+String(index+1)
                }
                self.view.addSubview(sticker)
            }
        }
    }
    
    
    func buttonOrangeColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.backgroundColor = UIColor.orangeColor()
        // Hidden text field to keep track of current color as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 7){
                textField.text = "orange"
            }
        }

    }
    
    
    func buttonGreenColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.backgroundColor = UIColor.greenColor()
        // Hidden text field to keep track of current color as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 7){
                textField.text = "green"
            }
        }
    }
    
    
    func buttonRedColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.backgroundColor = UIColor.redColor()
        // Hidden text field to keep track of current color as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 7){
                textField.text = "red"
            }
        }
        
    }
    
    
    func buttonDeletePressed(sender: UIButton!){
        let sentView = sender.superview
        let tag: Int! = sentView?.tag
        stickerDictionary.removeAtIndex(tag)
        sentView?.removeFromSuperview()
        for (index,sticker) in stickerDictionary.enumerate(){
            sticker.tag = index
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 2){
                    textField.text = "Sticker Number "+String(index+1)
                }
            }
        }
    }
    
    

    func buttonCreateNewFilePressed(sender: UIButton!){
        let sentView = sender.superview
        //Check if you have any views on screen
        if(stickerDictionary.count != 0){
        let newFileAlert = UIAlertController(title: "New File", message: "Are you sure you want to create another File without saving this one first? All changes if any in the current file will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        newFileAlert.view.backgroundColor = UIColor.greenColor()
        
        newFileAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            for case let textField as UITextField in sentView!.subviews{
                if (textField.tag == 5){
                    textField.text = "Unsaved File"
                }
            }
            
            
                    for case let button as UIButton in self.view.subviews{
                        if (button.tag == 20){
                            let currentButtonState = "Add Stickers to The Current File: (Unsaved File)"
                            button.setTitle(currentButtonState, forState: UIControlState.Normal)
                            
                        }
                 
            }
            
            
            for view in self.view.subviews{
                if (view.tag == 5){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = "Currently Viewing an Unsaved File"
                        }
                    }
                }
            }
            
            
            
            for view in self.stickerDictionary{
                view.removeFromSuperview()
            }
            self.stickerDictionary.removeAll()
            
            
        }))
        
        newFileAlert.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: {(action: UIAlertAction!) in
            
            
        }))
        
        
        presentViewController(newFileAlert, animated: true, completion: nil)
            
        }//End if statement
        
    }

    
    
    
    func buttonSavePressed(sender: UIButton!){
        let sentView = sender.superview
        let stickerFile = StickerFile()
        if(stickerFile.dateCreated == nil){
            stickerFile.dateCreated = NSDate()
        }
        if(stickerFile.dateCreated != nil){
            stickerFile.dateUpdated = NSDate()
        }
        
        var newFile = ""
        //Get the filename from the textfield
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                newFile = textField.text!
                stickerFile.fileName = textField.text!
            }
        }
        //Check if filename exists
        let predicate = NSPredicate(format: "fileName == %@", newFile)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count != 0){
            for case let textField as UITextField in (sentView?.subviews)!{
                if (textField.tag == 5){
                    textField.text = "File With File Name"+"("+newFile+") already exists"
                }
            }
            
        }
        
        if(retrievedFileNames.count == 0){// means file does not exist already
            let realm = try! Realm()
            try! realm.write {
                realm.add(stickerFile)
            }
            
            
            for sticker in stickerDictionary{
                //Create view parameters for the sticker
                let stickerView = Sticker()
                if(stickerView.dateCreated == nil){
                    stickerView.dateCreated = NSDate()
                }
                if(stickerView.dateCreated != nil){
                    stickerView.dateUpdated = NSDate()
                }
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 7){
                        stickerView.backgroundColor = textField.text!
                    }
                }
                stickerView.xPosition = Float(sticker.frame.origin.x)
                stickerView.yPosition = Float(sticker.frame.origin.y)
                stickerView.width = Float(sticker.frame.size.width)
                stickerView.height = Float(sticker.frame.size.height)
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 3){
                        stickerView.text = textField.text!
                    }
                }
                stickerView.fileName = stickerFile
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 8){
                        stickerView.stickerName = textField.text!
                    }
                }
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 2){
                        stickerView.stickerId = textField.text!
                    }
                }
                
                
                try! realm.write {
                    realm.add(stickerView)
                    stickerFile.stickers.append(stickerView)
                }

                
            }
            
        
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                textField.text = "File Saved Successfully"+"("+textField.text!+")"
            }
        }
        }

    }
    
    
    func buttonDeleteSavedFilePressed(sender: UIButton!){
        let sentView = sender.superview
        var newFile = ""
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                newFile = textField.text!
            }
        }
        
        let deleteFileAlert = UIAlertController(title: "Delete File", message: "Are you sure you want to Delete the File Named "+newFile+" ? All data in the file will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        deleteFileAlert.view.backgroundColor = UIColor.greenColor()
        
        deleteFileAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            
            
            let predicate = NSPredicate(format: "fileName == %@", newFile)
            let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
            
            if(retrievedFileNames.count == 0){
                for case let textField as UITextField in (sentView?.subviews)!{
                    if (textField.tag == 5){
                        textField.text = "File With File Name"+"("+newFile+") does not exist"
                    }
                }
                
            }
            
            
            if(retrievedFileNames.count != 0){//Check if file exists
                let realm = try! Realm()
                //Get attached list
                let firstFile = retrievedFileNames.first?.stickers
                //Delete the list per item
                for sticker in firstFile!{
                    try! realm.write {
                        realm.delete(sticker)
                    }
                }
            //Delete the file itself
                try! realm.write {
                    realm.delete(retrievedFileNames.first!)
                }
                
                
                //Check if its the current file we are deleting so we can remove its views from the superview
                for view in self.view.subviews{
                    if (view.tag == 4){
                        for case let textField as UITextField in sentView!.subviews{
                            if (textField.tag == 5){
                                if(textField.text == newFile){
                                    for view in self.stickerDictionary{
                                        view.removeFromSuperview()
                                    }
                                    self.stickerDictionary.removeAll()
                                    textField.text = "Successfully Deleted"+"("+newFile+")"
                                    
                                    //Update the add stickers button text
                                            for case let button as UIButton in self.view.subviews{
                                                if (button.tag == 20){
                                                    let currentButtonState = "Cant Add Stickers To Deleted File:"+"("+newFile+"). First Create New"
                                                    button.setTitle(currentButtonState, forState: UIControlState.Normal)
                                                        
                                                    }
                                             
                                        }
                                    }

                                    
                                }
                            }
                        }
                    }
                }
            
        }))
        
        deleteFileAlert.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: {(action: UIAlertAction!) in
            
            
        }))
        
        
        presentViewController(deleteFileAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    func buttonUpdatePressed(sender: UIButton!){
        let sentView = sender.superview
        
        var newFile = ""
        //Get the filename from the textfield
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                newFile = textField.text!
            }
        }
        //Check if filename exists
        let predicate = NSPredicate(format: "fileName == %@", newFile)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count == 0){
            for case let textField as UITextField in (sentView?.subviews)!{
                if (textField.tag == 5){
                    textField.text = "File You Wanted To Update does not exist"
                }
            }
            
        }
        
        if(retrievedFileNames.count != 0){// means file does exist already
            var stickerFile = StickerFile()
            if(stickerFile.dateCreated == nil){
                stickerFile.dateCreated = NSDate()
            }
            if(stickerFile.dateCreated != nil){
                stickerFile.dateUpdated = NSDate()
            }
            stickerFile = retrievedFileNames.first!
            
            let realm = try! Realm()
            
            for sticker in stickerFile.stickers{
                try! realm.write {
                    realm.delete(sticker)
                }
                
            }
            
            if(stickerFile.stickers.count != 0){
                stickerFile.stickers.removeAll()
            }
            
            for sticker in stickerDictionary{
                //Create view parameters for the sticker
                let stickerView = Sticker()
                if(stickerView.dateCreated == nil){
                    stickerView.dateCreated = NSDate()
                }
                if(stickerView.dateCreated != nil){
                    stickerView.dateUpdated = NSDate()
                }
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 7){
                        stickerView.backgroundColor = textField.text!
                    }
                }
                stickerView.xPosition = Float(sticker.frame.origin.x)
                stickerView.yPosition = Float(sticker.frame.origin.y)
                stickerView.width = Float(sticker.frame.size.width)
                stickerView.height = Float(sticker.frame.size.height)
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 3){
                        stickerView.text = textField.text!
                    }
                }
                stickerView.fileName = stickerFile
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 8){
                        stickerView.stickerName = textField.text!
                    }
                }
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 2){
                        stickerView.stickerId = textField.text!
                    }
                }
                
                
                try! realm.write {
                    realm.add(stickerView)
                    stickerFile.stickers.append(stickerView)
                }
                
                
            }
            
            
            for case let textField as UITextField in (sentView?.subviews)!{
                if (textField.tag == 5){
                    textField.text = "File Updated Successfully"+"("+textField.text!+")"
                }
            }
        }

    }

    
    
    
    func makeSaveButton(){
        let viewSave = UIView()
        viewSave.frame = CGRectMake(20, 30, 150, 30)
        viewSave.backgroundColor = UIColor.greenColor()
        viewSave.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        viewSave.addGestureRecognizer(gesture)
        viewSave.userInteractionEnabled = true
        viewSave.tag = 4
        
        
        let textFieldSaveName = UITextField(frame: CGRectMake(1.0, 1.0, 150.0, 20.0))
        textFieldSaveName.textAlignment = NSTextAlignment.Center
        textFieldSaveName.textColor = UIColor.blackColor()
        textFieldSaveName.font = UIFont.italicSystemFontOfSize(8)
        textFieldSaveName.borderStyle = UITextBorderStyle.Line
        textFieldSaveName.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldSaveName.backgroundColor = UIColor.clearColor()
        textFieldSaveName.borderStyle = UITextBorderStyle.None
        textFieldSaveName.tag = 5
        textFieldSaveName.text = "Unsaved File"
        
        let buttonSave:UIButton! = UIButton(type: .System)
        buttonSave.frame = CGRectMake(2, 20, 30, 8.0)
        buttonSave.layer.cornerRadius = 3
        buttonSave.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonSave.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonSave.backgroundColor = UIColor.greenColor()
        buttonSave.setTitle("Save", forState: UIControlState.Normal)
        buttonSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonSave.addTarget(self, action: "buttonSavePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonCreateNewFile:UIButton! = UIButton(type: .System)
        buttonCreateNewFile.frame = CGRectMake(33, 20, 70, 8)
        buttonCreateNewFile.layer.cornerRadius = 5
        buttonCreateNewFile.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonCreateNewFile.backgroundColor = UIColor.greenColor()
        buttonCreateNewFile.setTitle("Create New File", forState: UIControlState.Normal)
        buttonCreateNewFile.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonCreateNewFile.addTarget(self, action: "buttonCreateNewFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonUpdate:UIButton! = UIButton(type: .System)
        buttonUpdate.frame = CGRectMake(113, 20, 30, 8.0)
        buttonUpdate.layer.cornerRadius = 8
        buttonUpdate.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonUpdate.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonUpdate.backgroundColor = UIColor.greenColor()
        buttonUpdate.setTitle("Update", forState: UIControlState.Normal)
        buttonUpdate.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonUpdate.addTarget(self, action: "buttonUpdatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        viewSave.addSubview(textFieldSaveName)
        viewSave.addSubview(buttonSave)
        viewSave.addSubview(buttonUpdate)
        viewSave.addSubview(buttonCreateNewFile)
        self.view.addSubview(viewSave)
        
    }
    
    
    func buttonViewFilePressed(sender: UIButton!){
        let sentView = sender.superview
        var newFile = ""
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                newFile = textField.text!
            }
        }
        
        let predicate = NSPredicate(format: "fileName == %@", newFile)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count == 0){
            for case let textField as UITextField in (sentView?.subviews)!{
                if (textField.tag == 5){
                    textField.text = "File With File Name"+"("+newFile+") does not exist"
                }
            }
            
        }
        
        
        if(retrievedFileNames.count != 0){
            for view in self.stickerDictionary{
                view.removeFromSuperview()
            }
            stickerDictionary.removeAll()
            
            let firstFile = retrievedFileNames.first?.stickers
            for sticker in firstFile! {
                makeStickerFromFile(sticker)// Adds stickers to the dictionary
            }
            
            for (index,sticker) in stickerDictionary.enumerate(){
                sticker.tag = index
                for case let textField as UITextField in sticker.subviews{
                    if (textField.tag == 2){
                        textField.text = "Sticker Number "+String(index+1)
                    }
                    self.view.addSubview(sticker)
                }
            }

            
            for case let textField as UITextField in (sentView?.subviews)!{
                if (textField.tag == 5){
                    textField.text = "Currently Viewing"+"("+newFile+")"
                }
            }
            
            
            //Update the add stickers button text
                    for case let button as UIButton in self.view.subviews{
                        if (button.tag == 20){
                            let currentButtonState = "Add Stickers to The Current File:"+"("+newFile+")"
                            button.setTitle(currentButtonState, forState: UIControlState.Normal)
                            
                        }
                    }
        
        }
    
    }



    func buttonViewAllFilesPressed(sender: UIButton!){
        allFilesTableView.frame = CGRectMake(500, 30, 130, 300)
        allFilesTableView.backgroundColor = UIColor.greenColor()
        allFilesTableView.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        allFilesTableView.addGestureRecognizer(gesture)
        allFilesTableView.userInteractionEnabled = true
        allFilesTableView.tag = 15
        allFilesTableView.scrollEnabled = true
        
        
        let retrievedFiles = try! Realm().objects(StickerFile)
        if(retrievedFiles.count == 0){
            for view in self.view.subviews{
                if (view.tag == 5){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = "There Were No Files To Retrieve"
                        }
                    }
                }
            }
        }
        
        for file in retrievedFiles{
            retrievedFileNames.append(file.fileName)
        }
        
        
        allFilesTableView.delegate = self
        allFilesTableView.dataSource = self
        allFilesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        self.view.addSubview(allFilesTableView)
        
        allFilesTableView.hidden = false
        for view in self.view.subviews{
            if (view.tag == 5){
                for case let button as UIButton in view.subviews{
                    if (button.tag == 10){//View button
                        button.hidden = true
                    }
                    if (button.tag == 9){//Hide button
                        button.hidden = false
                    }
                }
            }
        }
        
        
    }
    
    
    
    
    func buttonHideAllFilesPressed(sender: UIButton!){
        allFilesTableView.hidden = true
        for view in self.view.subviews{
            if (view.tag == 5){
                for case let button as UIButton in view.subviews{
                    if (button.tag == 10){//View button
                        button.hidden = false
                    }
                    if (button.tag == 9){//Hide button
                        button.hidden = true
                    }
                }
            }
        }
        
        
    }
    





    func makeViewAllFilesButton(){
        
        var currentFileName = ""
        for view in self.view.subviews{
            if (view.tag == 4){
                for case let textField as UITextField in view.subviews{
                    if (textField.tag == 5){
                        currentFileName = textField.text!
                    }
                }
            }
        }
        let currentFile = "Currently Viewing File: ("+currentFileName+")"
        
        let viewAllFiles = UIView()
        viewAllFiles.frame = CGRectMake(350, 30, 130, 30)
        viewAllFiles.backgroundColor = UIColor.greenColor()
        viewAllFiles.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        viewAllFiles.addGestureRecognizer(gesture)
        viewAllFiles.userInteractionEnabled = true
        viewAllFiles.tag = 5
        
        
        let textFieldSaveName = UITextField(frame: CGRectMake(1.0, 1.0, 130.0, 20.0))
        textFieldSaveName.textAlignment = NSTextAlignment.Center
        textFieldSaveName.textColor = UIColor.blackColor()
        textFieldSaveName.font = UIFont.italicSystemFontOfSize(8)
        textFieldSaveName.borderStyle = UITextBorderStyle.Line
        textFieldSaveName.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldSaveName.backgroundColor = UIColor.clearColor()
        textFieldSaveName.borderStyle = UITextBorderStyle.None
        textFieldSaveName.tag = 5
        textFieldSaveName.text = currentFile
        
        let buttonSave:UIButton! = UIButton(type: .System)
        buttonSave.frame = CGRectMake(5, 20, 30, 8.0)
        buttonSave.layer.cornerRadius = 3
        buttonSave.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonSave.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonSave.backgroundColor = UIColor.greenColor()
        buttonSave.setTitle("View", forState: UIControlState.Normal)
        buttonSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonSave.addTarget(self, action: "buttonViewFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonViewAll:UIButton! = UIButton(type: .System)
        buttonViewAll.frame = CGRectMake(48, 20, 35, 8.0)
        buttonViewAll.layer.cornerRadius = 3
        buttonViewAll.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonViewAll.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonViewAll.backgroundColor = UIColor.greenColor()
        buttonViewAll.setTitle("View All", forState: UIControlState.Normal)
        buttonViewAll.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonViewAll.addTarget(self, action: "buttonViewAllFilesPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonViewAll.hidden = false
        buttonViewAll.tag = 10
        
        
        
        let buttonHideAll:UIButton! = UIButton(type: .System)
        buttonHideAll.frame = CGRectMake(48, 20, 35, 8.0)
        buttonHideAll.layer.cornerRadius = 3
        buttonHideAll.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonHideAll.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonHideAll.backgroundColor = UIColor.greenColor()
        buttonHideAll.setTitle("Hide All", forState: UIControlState.Normal)
        buttonHideAll.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonHideAll.addTarget(self, action: "buttonHideAllFilesPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonHideAll.hidden = true
        buttonHideAll.tag = 9
        
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(98, 20, 30, 8.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.backgroundColor = UIColor.greenColor()
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeleteSavedFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        viewAllFiles.addSubview(textFieldSaveName)
        viewAllFiles.addSubview(buttonDelete)
        viewAllFiles.addSubview(buttonSave)
        viewAllFiles.addSubview(buttonViewAll)
        viewAllFiles.addSubview(buttonHideAll)
        self.view.addSubview(viewAllFiles)
        
    }
    
    
    //These paramters may not be used
    func makeSticker(stickerLabel: String, stickerNumber: Int){
        let view = UIView()
        view.frame = CGRectMake(30, 50, 200, 120)
        view.backgroundColor = UIColor.greenColor()
        view.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        view.tag = 1
        
        
        let textTitle = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textTitle.textAlignment = NSTextAlignment.Center
        textTitle.font = UIFont.italicSystemFontOfSize(8)
        textTitle.textColor = UIColor.blackColor()
        textTitle.tag = 2
        
        let textCurrentColor = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textCurrentColor.textAlignment = NSTextAlignment.Center
        textCurrentColor.font = UIFont.italicSystemFontOfSize(8)
        textCurrentColor.textColor = UIColor.blackColor()
        textCurrentColor.tag = 7
        textCurrentColor.hidden = true
        textCurrentColor.text = "green"
        
        let textCurrentName = UITextField(frame: CGRectMake(2.0, 10.0, 200.0, 8.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = "Name this Sticker"
        
        
        let textField = UITextView(frame: CGRectMake(0.0, 19.0, 200.0, 93.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(10)
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        textField.tag = 3
        
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        buttonOrangeColor.frame = CGRectMake(3, 112, 30, 8.0)
        buttonOrangeColor.layer.cornerRadius = 3
        buttonOrangeColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOrangeColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOrangeColor.backgroundColor = UIColor.orangeColor()
        buttonOrangeColor.setTitle("Orange", forState: UIControlState.Normal)
        buttonOrangeColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOrangeColor.addTarget(self, action: "buttonOrangeColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonGreenColor:UIButton! = UIButton(type: .System)
        buttonGreenColor.frame = CGRectMake(40, 112, 30, 8.0)
        buttonGreenColor.layer.cornerRadius = 3
        buttonGreenColor.backgroundColor = UIColor.greenColor()
        buttonGreenColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonGreenColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonGreenColor.setTitle("Green", forState: UIControlState.Normal)
        buttonGreenColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonGreenColor.addTarget(self, action: "buttonGreenColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonBlueColor:UIButton! = UIButton(type: .System)
        buttonBlueColor.frame = CGRectMake(73, 112, 30, 8.0)
        buttonBlueColor.layer.cornerRadius = 3
        buttonBlueColor.backgroundColor = UIColor.redColor()
        buttonBlueColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonBlueColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonBlueColor.setTitle("Red", forState: UIControlState.Normal)
        buttonBlueColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonBlueColor.addTarget(self, action: "buttonRedColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(106, 112, 30, 8.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeletePressed:", forControlEvents: UIControlEvents.TouchUpInside)

        
        view.addSubview(textField)
        view.addSubview(textCurrentColor)
        view.addSubview(textCurrentName)
        view.addSubview(buttonOrangeColor)
        view.addSubview(buttonGreenColor)
        view.addSubview(buttonBlueColor)
        view.addSubview(buttonDelete)
        
        stickerDictionary.append(view)
        view.addSubview(textTitle)
        
    }
    
    
    func makeStickerFromFile(sticker: Sticker){
        let view = UIView()
        view.frame = CGRectMake(CGFloat(sticker.xPosition), CGFloat(sticker.yPosition), CGFloat(sticker.width), CGFloat(sticker.height))
        switch(sticker.backgroundColor){
        case "orange":
            view.backgroundColor = UIColor.orangeColor()
        case "red":
            view.backgroundColor = UIColor.redColor()
        case "green":
            view.backgroundColor = UIColor.greenColor()
        default:
            view.backgroundColor = UIColor.greenColor()
        }
        view.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        view.tag = 6
        
        
        let textTitle = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textTitle.textAlignment = NSTextAlignment.Center
        textTitle.font = UIFont.italicSystemFontOfSize(8)
        textTitle.textColor = UIColor.blackColor()
        textTitle.tag = 2
        textTitle.text = sticker.stickerId
        
        let textCurrentColor = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textCurrentColor.textAlignment = NSTextAlignment.Center
        textCurrentColor.font = UIFont.italicSystemFontOfSize(8)
        textCurrentColor.textColor = UIColor.blackColor()
        textCurrentColor.tag = 7
        textCurrentColor.hidden = true
        textCurrentColor.text = "green"
        
        let textCurrentName = UITextField(frame: CGRectMake(2.0, 10.0, 200.0, 8.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = sticker.stickerName
        
        
        let textField = UITextView(frame: CGRectMake(0.0, 19.0, 200.0, 93.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(10)
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        textField.tag = 3
        textField.text = sticker.text
        
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        buttonOrangeColor.frame = CGRectMake(3, 112, 30, 8.0)
        buttonOrangeColor.layer.cornerRadius = 3
        buttonOrangeColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOrangeColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOrangeColor.backgroundColor = UIColor.orangeColor()
        buttonOrangeColor.setTitle("Orange", forState: UIControlState.Normal)
        buttonOrangeColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOrangeColor.addTarget(self, action: "buttonOrangeColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonGreenColor:UIButton! = UIButton(type: .System)
        buttonGreenColor.frame = CGRectMake(40, 112, 30, 8.0)
        buttonGreenColor.layer.cornerRadius = 3
        buttonGreenColor.backgroundColor = UIColor.greenColor()
        buttonGreenColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonGreenColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonGreenColor.setTitle("Green", forState: UIControlState.Normal)
        buttonGreenColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonGreenColor.addTarget(self, action: "buttonGreenColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonBlueColor:UIButton! = UIButton(type: .System)
        buttonBlueColor.frame = CGRectMake(73, 112, 30, 8.0)
        buttonBlueColor.layer.cornerRadius = 3
        buttonBlueColor.backgroundColor = UIColor.redColor()
        buttonBlueColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonBlueColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonBlueColor.setTitle("Red", forState: UIControlState.Normal)
        buttonBlueColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonBlueColor.addTarget(self, action: "buttonRedColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(106, 112, 30, 8.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeletePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        view.addSubview(textField)
        view.addSubview(textCurrentColor)
        view.addSubview(textCurrentName)
        view.addSubview(buttonOrangeColor)
        view.addSubview(buttonGreenColor)
        view.addSubview(buttonBlueColor)
        view.addSubview(buttonDelete)
        
        stickerDictionary.append(view)
        view.addSubview(textTitle)
        
        //Add something to the save view
        for view in self.view.subviews{
            if (view.tag == 4){
                for case let textField as UITextField in (view.subviews){
                    if (textField.tag == 5){
                        textField.text = sticker.fileName?.fileName
                    }
                }
            }
        }
        
    }

    
    
    func dragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        let gesturedView = gesture.view
        gesturedView!.center = loc
    }
    
}

