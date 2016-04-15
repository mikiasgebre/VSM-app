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
import MessageUI

class Sticker: Object {
    dynamic var stickerId = ""
    dynamic var stickerName = ""
    dynamic var stickerStatus = ""
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



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var stickerDictionary = [UIView]()
    var stickerDictionaryIcon = [UIView]()
    let allFilesTableView = UITableView()
    var retrievedFileNames = [String]()
    let timeLineView = UIStackView()
    let timeLineViewIcon = UIStackView()
    var scrollView:UIScrollView!
    var scrollViewIcon:UIScrollView!
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createScrollAndContainerView() //Contains some code for scroll view and stackview
        makeSaveButton()
        makeButtonCreateSticker()
        makeViewAllFilesButton()
        makeButtonRefreshStickers()
        makeButtonFileAsPdf()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    //For initializing the scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRectMake(0,0,view.frame.width-0.2, 350)
        scrollView.contentSize = CGSizeMake(timeLineView.frame.width, 350)
        scrollView.scrollEnabled = true
        scrollView.contentInset = UIEdgeInsetsMake(0, 274, 0, 274)
        scrollView.userInteractionEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        //scrollView.pagingEnabled = true
        //scrollView.backgroundColor = UIColor.brownColor()
        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth||UIViewAutoresizing.FlexibleHeight
        
        
        scrollViewIcon.frame = CGRectMake(0,350,view.frame.width-0.2, 55)
        scrollViewIcon.contentSize = CGSizeMake(timeLineViewIcon.frame.width, 55)
        scrollViewIcon.scrollEnabled = true
        scrollViewIcon.contentInset = UIEdgeInsetsMake(0, 20, 0, 10)
        scrollViewIcon.userInteractionEnabled = true
        scrollViewIcon.alwaysBounceHorizontal = true
        //scrollViewIcon.delegate = self
        //scrollViewIcon.backgroundColor = UIColor.blueColor()
        
    }
    
    //The table shows you a list of files that are currently saved
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
                    //This the view id
                    if (textField.tag == 9){
                        textField.text = String(index+1)
                    }
                    
                    //self.view.addSubview(sticker)
                }
            }
            
            //Add Stickers to timeline
            for (index,sticker) in stickerDictionary.enumerate(){
                timeLineView.insertArrangedSubview(sticker, atIndex: index)
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
        
        
        //Create Icons
        for view in timeLineViewIcon.arrangedSubviews{
            view.removeFromSuperview()
        }
        stickerDictionaryIcon.removeAll()
        for sticker in stickerDictionary{
            let iconView = UIView()
            iconView.frame = CGRectMake(0,0,200, 130)
            iconView.layer.cornerRadius = 5
            iconView.tag = sticker.tag
            //iconView.backgroundColor = UIColor.redColor()
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 7){
                    switch(textField.text!){
                    case "orange":
                        iconView.backgroundColor = UIColor.orangeColor()
                    case "red":
                        iconView.backgroundColor = UIColor.redColor()
                    case "green":
                        iconView.backgroundColor = UIColor.greenColor()
                    default:
                        iconView.backgroundColor = UIColor.greenColor()
                    }
                    
                }
                
            }
            
            
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 8){
                    let textCurrentName = UITextView(frame: CGRectMake(2.0, 1.0, 50.0, 30.0))
                    textCurrentName.textAlignment = NSTextAlignment.Center
                    textCurrentName.font = UIFont.italicSystemFontOfSize(8)
                    textCurrentName.textColor = UIColor.blackColor()
                    textCurrentName.backgroundColor = UIColor.clearColor()
                    textCurrentName.tag = 8
                    textCurrentName.text = textField.text!
                    textCurrentName.editable = false
                    iconView.addSubview(textCurrentName)
                }
                
            }
            
            iconView.heightAnchor.constraintEqualToConstant(35).active = true
            iconView.widthAnchor.constraintEqualToConstant(55).active = true
            stickerDictionaryIcon.append(iconView)
            
        }
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionaryIcon.enumerate(){
            timeLineViewIcon.insertArrangedSubview(sticker, atIndex: index)
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
                
                //This the view id
                if (textField.tag == 9){
                    textField.text = String(index+1)
                }
                
            }
        }
        
       //Add Stickers to timeline
        for (index,sticker) in stickerDictionary.enumerate(){
            timeLineView.insertArrangedSubview(sticker, atIndex: index)
            //timeLineViewIcon.insertArrangedSubview(sticker, atIndex: index)
        }
        
        let iconView = UIView()
        iconView.frame = CGRectMake(0,0,200, 130)
        iconView.layer.cornerRadius = 5
        iconView.tag = stickerDictionary[stickerDictionary.count-1].tag
        for case let textField as UITextField in stickerDictionary[stickerDictionary.count-1].subviews{
            if (textField.tag == 7){
                switch(textField.text!){
                case "orange":
                    iconView.backgroundColor = UIColor.orangeColor()
                case "red":
                    iconView.backgroundColor = UIColor.redColor()
                case "green":
                    iconView.backgroundColor = UIColor.greenColor()
                default:
                    iconView.backgroundColor = UIColor.greenColor()
                }
                
            }
            
        }
        
        
        for case let textField as UITextField in stickerDictionary[stickerDictionary.count-1].subviews{
            if (textField.tag == 8){
                let textCurrentName = UITextView(frame: CGRectMake(2.0, 1.0, 50.0, 30.0))
                textCurrentName.textAlignment = NSTextAlignment.Center
                textCurrentName.font = UIFont.italicSystemFontOfSize(8)
                textCurrentName.textColor = UIColor.blackColor()
                textCurrentName.backgroundColor = UIColor.clearColor()
                textCurrentName.tag = 8
                textCurrentName.text = textField.text!
                textCurrentName.editable = false
                iconView.addSubview(textCurrentName)
            }
            
        }
        iconView.heightAnchor.constraintEqualToConstant(35).active = true
        iconView.widthAnchor.constraintEqualToConstant(55).active = true
        stickerDictionaryIcon.append(iconView)
        
        //Add icons to timeline
        for (index,icon) in stickerDictionaryIcon.enumerate(){
            timeLineViewIcon.insertArrangedSubview(icon, atIndex: index)
        }
        
        scrollView.setContentOffset(CGPoint(x: timeLineView.arrangedSubviews.count*548, y: 0), animated: false)
        //scrollView.contentOffset = CGPoint(x: timeLineView.frame.width, y: 0)
        scrollViewIcon.setContentOffset(CGPoint(x: timeLineViewIcon.arrangedSubviews.count*548, y: 0), animated: false)
        
    }
    
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        var zoomedView = UIView()
            for view in timeLineView.arrangedSubviews{
                if(view.frame.width>205){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                    zoomedView = view
                }
            }
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == zoomedView.tag){
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
        let offset = scrollView.contentOffset.x
        let remainder = offset%scrollView.frame.width
        let patch = 567.8 - remainder
        let fullOffset = offset+patch
        
        let itemFullOffset = offset-remainder
        var itemNumber = Int(itemFullOffset/scrollView.frame.width)
        //timeLineView.arrangedSubviews[itemNumber].backgroundColor = UIColor.blackColor()
        
        if(scrollView.contentOffset.x == -274.0){
            let item = 0
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: false)
            for views in timeLineView.arrangedSubviews{
                if(views.tag == item){
                        views.transform = CGAffineTransformMakeScale(1.6, 1.6)
                }
            }
            
            for view in timeLineViewIcon.arrangedSubviews{
                if (view.tag == item){
                    view.transform = CGAffineTransformMakeScale(1.6, 1.6)
                }
            }
            
            
        }else{
            scrollView.setContentOffset(CGPoint(x: fullOffset, y: 0), animated: false)
            if(itemNumber>=timeLineView.arrangedSubviews.count){
                itemNumber = timeLineView.arrangedSubviews.count-2
            }
            for view in timeLineView.arrangedSubviews{
                if(view.tag == itemNumber+1){
                        view.transform = CGAffineTransformMakeScale(1.6, 1.6)
                }
            }
            
            for view in timeLineViewIcon.arrangedSubviews{
                if (view.tag == itemNumber+1){
                    view.transform = CGAffineTransformMakeScale(1.6, 1.6)
                }
            }
            //timeLineView.arrangedSubviews[itemNumber].transform = CGAffineTransformMakeScale(2, 2)
        }
        
        
        //let itemNumber = (Int(fullOffset/scrollView.frame.width)+1)
        
        //stickerDictionary[itemNumber+1].backgroundColor = UIColor.blackColor()
        //stickerDictionary[itemNumber].transform = CGAffineTransformMakeScale(2, 2)
        print("Item Number")
        print(stickerDictionary.count)
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonRefreshStickers(){
        let buttonRefreshStickers:UIButton! = UIButton(type: .System)
        buttonRefreshStickers.frame = CGRectMake(500, 30, 50, 30)
        buttonRefreshStickers.layer.cornerRadius = 5
        buttonRefreshStickers.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonRefreshStickers.titleLabel?.numberOfLines = 0
        buttonRefreshStickers.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonRefreshStickers.backgroundColor = UIColor.greenColor()
        buttonRefreshStickers.setTitle("Refresh Page", forState: UIControlState.Normal)
        buttonRefreshStickers.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRefreshStickers.addTarget(self, action: "buttonRefreshStickersPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonRefreshStickers)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        buttonRefreshStickers.addGestureRecognizer(gesture)
        buttonRefreshStickers.userInteractionEnabled = true
        buttonRefreshStickers.tag = 29
        
    }
    
    
    
    
    //Button action method
    func buttonRefreshStickersPressed(sender: UIButton!){
        refreshStickers()
    }
    
    
    //Button action method
    func refreshStickers(){
        for view in timeLineView.arrangedSubviews{
            view.removeFromSuperview()
        }
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionary.enumerate(){
            timeLineView.insertArrangedSubview(sticker, atIndex: index)
        }
        
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonFileAsPdf(){
        let buttonFileAsPdf:UIButton! = UIButton(type: .System)
        buttonFileAsPdf.frame = CGRectMake(610, 30, 50, 30)
        buttonFileAsPdf.layer.cornerRadius = 5
        buttonFileAsPdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonFileAsPdf.titleLabel?.numberOfLines = 0
        buttonFileAsPdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonFileAsPdf.backgroundColor = UIColor.greenColor()
        buttonFileAsPdf.setTitle("Pdf", forState: UIControlState.Normal)
        buttonFileAsPdf.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFileAsPdf.addTarget(self, action: "buttonFileAsPdfPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonFileAsPdf)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        buttonFileAsPdf.addGestureRecognizer(gesture)
        buttonFileAsPdf.userInteractionEnabled = true
        buttonFileAsPdf.tag = 42
        
    }
    
    //Button action method
    func buttonFileAsPdfPressed(sender: UIButton!){
        fileAsPdf()
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonFileAsPdfRemove(){
        let buttonFileAsPdf:UIButton! = UIButton(type: .System)
        buttonFileAsPdf.frame = CGRectMake(200, 30, 50, 30)
        buttonFileAsPdf.layer.cornerRadius = 5
        buttonFileAsPdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonFileAsPdf.titleLabel?.numberOfLines = 0
        buttonFileAsPdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonFileAsPdf.backgroundColor = UIColor.greenColor()
        buttonFileAsPdf.setTitle("Pdf", forState: UIControlState.Normal)
        buttonFileAsPdf.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFileAsPdf.addTarget(self, action: "buttonFileAsPdfRemovePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonFileAsPdf)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        buttonFileAsPdf.addGestureRecognizer(gesture)
        buttonFileAsPdf.userInteractionEnabled = true
        buttonFileAsPdf.tag = 45
        
    }
    
    
    
    
    //Button action method
    func buttonFileAsPdfRemovePressed(sender: UIButton!){
        for case let webView as UIWebView in sender.superview!.subviews{
            if (webView.tag == 72){
                webView.removeFromSuperview()
            }
            
        }
        sender.superview?.removeFromSuperview()
        sender.removeFromSuperview()
    }
    
    //Button action method
    func fileAsPdf(){
        
        /*let renderer = UIPrintPageRenderer()
        let paper = CGRect(x: 0, y: 0, width: 592.2, height: 841.8)
        let printablePaper = CGRectInset(paper, 0, 0)
        renderer.setValue(NSValue(CGRect: paper), forKey: "paperArea")
        renderer.setValue(NSValue(CGRect: printablePaper), forKey: "printableArea")
        UIGraphicsBeginPDFPage()
        let pdfContext = UIGraphicsGetCurrentContext()
        for sticker in stickerDictionary{
            renderer.drawLayer(sticker.layer, inContext: pdfContext!)
        }
        UIGraphicsEndPDFContext()*/
        
        let webViewContainer = UIWebView()
        webViewContainer.frame = CGRectMake(5, 5, 635, 845.8)
        
        
        
        
        let webView = UIWebView()
        webView.frame = CGRectMake(10, 50, 630, 841.8)
        webView.tag = 72
        
        
        var startIndex = 0
        var endIndex = 0
        let stickerCount = stickerDictionary.count
        var groupCount = 0
        let remainder = stickerDictionary.count%3
        if(stickerDictionary.count%3 == 0){
            groupCount = (stickerDictionary.count/3)
        }
        if(stickerDictionary.count%3 != 0){
            groupCount = (stickerDictionary.count/3)+1
        }
        
        
        for (var group = 0; group < groupCount; group++){
            if(startIndex+3 <= stickerCount){
                endIndex = startIndex+3
            }
            if(startIndex+3 > stickerCount){
                startIndex = stickerCount - remainder
                endIndex = stickerCount
            }
            var count = 0  //This is needed to increase the x component
            for (var index = startIndex; index < endIndex; index++){
                UIGraphicsBeginImageContextWithOptions(CGRectMake(0, 0, 200, 130).size, false, 0)
                stickerDictionary[index].drawViewHierarchyInRect(CGRectMake(0, 0, 200, 130), afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let imageView = UIImageView(image: image)
                imageView.frame = CGRectMake(CGFloat(count*210), CGFloat(140*group), 200, 130)
                count++
                webView.addSubview(imageView)
            }
            startIndex+=3
        }
        
        /*for (var index=0; index < stickerDictionary.count; index++){
            //for (indexY, sticker) in stickerDictionary.enumerate(){
            UIGraphicsBeginImageContextWithOptions(CGRectMake(0, 0, 200, 130).size, false, 0)
            stickerDictionary[index].drawViewHierarchyInRect(CGRectMake(0, 0, 200, 130), afterScreenUpdates: true)
            //sticker.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageView = UIImageView(image: image)
                imageView.frame = CGRectMake(CGFloat(index*210), 20, 200, 130)
            
            webView.addSubview(imageView)
            //}
         }*/
        
        let buttonFileAsPdf:UIButton! = UIButton(type: .System)
        buttonFileAsPdf.frame = CGRectMake(220, 10, 50, 30)
        buttonFileAsPdf.layer.cornerRadius = 5
        buttonFileAsPdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonFileAsPdf.titleLabel?.numberOfLines = 0
        buttonFileAsPdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonFileAsPdf.backgroundColor = UIColor.greenColor()
        buttonFileAsPdf.setTitle("Pdf", forState: UIControlState.Normal)
        buttonFileAsPdf.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFileAsPdf.addTarget(self, action: "buttonFileAsPdfRemovePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonFileAsPdf)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        buttonFileAsPdf.addGestureRecognizer(gesture)
        buttonFileAsPdf.userInteractionEnabled = true
        buttonFileAsPdf.tag = 45
        
        
        webViewContainer.addSubview(buttonFileAsPdf)
        //webViewContainer.addSubview(webView)
        //self.view.addSubview(webViewContainer)
        
        let pdfStickers = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfStickers, webViewContainer.bounds, nil)
        let pdfContext = UIGraphicsGetCurrentContext()
        UIGraphicsBeginPDFPage()
        //webViewContainer.frame = CGRectMake(webViewContainer.frame)
        webView.layer.renderInContext(pdfContext!)
        UIGraphicsEndPDFContext()
        
        
        var count = 0
        let docDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let fileName = docDirectory+"/"+"pdfFile"+String(count)
            pdfStickers.writeToFile(fileName, atomically: true)
            count+=1
        let webViewPdf = UIWebView()
        webViewPdf.frame = webView.frame
        webViewPdf.loadData(pdfStickers, MIMEType: "application/pdf", textEncodingName: "UTF-8", baseURL: NSURL())
        webViewContainer.addSubview(webViewPdf)
        self.view.addSubview(webViewContainer)
    }

    
    
    
    func createScrollAndContainerView() {
        scrollView = UIScrollView()
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        //scrollView.backgroundColor = UIColor.brownColor()
        
        scrollViewIcon = UIScrollView()
        //scrollViewIcon.delegate = self
        scrollViewIcon.maximumZoomScale = 2
        scrollViewIcon.minimumZoomScale = 1
        
        
        containerView = UIView()
        //containerView.frame = CGRectMake(40, 40, 400, 400)
        containerView.backgroundColor = UIColor.blueColor()
        containerView.bounds = CGRectInset(view.frame, 20.0, 20.0)
        containerView.layer.cornerRadius = 6
        containerView.tag = 4
        //let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        //containerView.addGestureRecognizer(gesture)
        //containerView.userInteractionEnabled = true
        
        
        
        //Timeline is basically a stackview
        timeLineView.userInteractionEnabled = true
        timeLineView.axis = UILayoutConstraintAxis.Horizontal
        timeLineView.distribution = .Fill
        timeLineView.alignment = UIStackViewAlignment.Center
        timeLineView.spacing = 567.8
        timeLineView.tag = 60
        timeLineView.backgroundColor = UIColor.redColor()
        timeLineView.layoutMarginsRelativeArrangement = true
        timeLineView.translatesAutoresizingMaskIntoConstraints = false
        timeLineView.heightAnchor.constraintEqualToConstant(350).active = true
        //timeLineView.widthAnchor.constraintEqualToConstant(self.view.frame.size.width-20).active = true
        
        
        //Timeline is basically a stackview
        timeLineViewIcon.userInteractionEnabled = true
        timeLineViewIcon.axis = UILayoutConstraintAxis.Horizontal
        timeLineViewIcon.distribution = .Fill
        timeLineViewIcon.alignment = UIStackViewAlignment.Center
        timeLineViewIcon.spacing = 30
        timeLineViewIcon.tag = 60
        timeLineViewIcon.backgroundColor = UIColor.redColor()
        timeLineViewIcon.layoutMarginsRelativeArrangement = true
        timeLineViewIcon.translatesAutoresizingMaskIntoConstraints = false
        timeLineViewIcon.heightAnchor.constraintEqualToConstant(750).active = true
        
        
        //containerView.addSubview(timeLineView)
        scrollViewIcon.addSubview(timeLineViewIcon)
        scrollView.addSubview(timeLineView)
        //scrollView.addSubview(scrollViewIcon)
        view.addSubview(scrollView)
        view.addSubview(scrollViewIcon)
        
        //timeLineView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        //timeLineView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        
        
    }

    
    func buttonOrangeColorPressed(sender: UIButton!){
        let sentView = sender.superview?.superview
        sentView?.backgroundColor = UIColor.orangeColor()
        // Hidden text field to keep track of current color as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 7){
                textField.text = "orange"
            }
        }
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                view.backgroundColor = UIColor.orangeColor()
            }
        }

    }
    
    
    func buttonGreenColorPressed(sender: UIButton!){
        let sentView = sender.superview?.superview
        sentView?.backgroundColor = UIColor.greenColor()
        // Hidden text field to keep track of current color as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 7){
                textField.text = "green"
            }
        }
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                view.backgroundColor = UIColor.greenColor()
            }
        }
    }
    
    
    func buttonRedColorPressed(sender: UIButton!){
        let sentView = sender.superview?.superview
        sentView?.backgroundColor = UIColor.redColor()
        // Hidden text field to keep track of current color as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 7){
                textField.text = "red"
            }
        }
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                view.backgroundColor = UIColor.redColor()
            }
        }
        
    }
    
    
    func buttonDeletePressed(sender: UIButton!){
        let sentView = sender.superview?.superview
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
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                view.removeFromSuperview()
                stickerDictionaryIcon.removeAtIndex(view.tag)
            }
        }
    }
    
    
    //Button action method
    func buttonFlipPressed(sender: UIButton!){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            //sender.superview!.transform = CGAffineTransformMakeScale(1.6, 1.6)
            for textField in sender.superview!.subviews{
                if (textField.tag == 19){//This is the view for the controls at the back
                        textField.hidden = false
                }
            }
        })
        let fromValue = 0
        let toValue = M_PI
        CATransaction.setDisableActions(true)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation.fromValue = fromValue
        rotationAnimation.toValue = toValue
        rotationAnimation.duration = 1
        sender.superview?.layer.addAnimation(rotationAnimation, forKey: "rotation")
        var transform = CATransform3DIdentity
        transform.m34 = 1.0/500.0
        sender.superview?.layer.transform = transform
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sender.superview?.tag){
                view.layer.addAnimation(rotationAnimation, forKey: "rotation")
                view.layer.transform = transform
            }
        }
        
        CATransaction.commit()
    }
    
    
    //Button action method
    func buttonFlipBackPressed(sender: UIButton!){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            //sender.superview!.transform = CGAffineTransformMakeScale(2, 2)
            for textField in sender.superview!.superview!.subviews{
                if (textField.tag == 19){//This is the view for the controls
                    textField.hidden = true
                }
            }
        })
        let fromValue = 0
        let toValue = M_PI
        CATransaction.setDisableActions(true)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation.fromValue = fromValue
        rotationAnimation.toValue = toValue
        rotationAnimation.duration = 1
        sender.superview?.superview!.layer.addAnimation(rotationAnimation, forKey: "rotation")
        var transform = CATransform3DIdentity
        transform.m34 = 1.0/500.0
        sender.superview?.superview!.layer.transform = transform
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sender.superview?.superview!.tag){
                view.layer.addAnimation(rotationAnimation, forKey: "rotation")
                view.layer.transform = transform
            }
        }
        
        
        CATransaction.commit()
    }


    
    
    func buttonArchivePressed(sender: UIButton!){
        let sentView = sender.superview
        // Hidden text field to keep track of current state as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 20){
                    textField.text = "archived"
                
            }
        }
        //Hide the archive button
        sender.hidden = true
        
        //Make visible the extract button
        for case let button as UIButton in sentView!.subviews{
            if (button.tag == 88){
                button.hidden = false
            }
        }
    }
    
    
    func buttonExtractPressed(sender: UIButton!){
        let sentView = sender.superview
        // Hidden text field to keep track of current state as a string
        for case let textField as UITextField in sentView!.subviews{
            if (textField.tag == 20){
                    textField.text = "current"
                
            }
        }
        //Hide the extract button
        sender.hidden = true
        
        //Make visible the archive button
        for case let button as UIButton in sentView!.subviews{
            if (button.tag == 89){
                button.hidden = false
            }
        }
        
    }
    
    

    //This may be required to open as another thread in a future release
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
            
            if(self.stickerDictionaryIcon.count != 0){
                for view in self.timeLineViewIcon.arrangedSubviews{
                    view.removeFromSuperview()
                }
                self.stickerDictionaryIcon.removeAll()
            }
            
            
            for view in self.stickerDictionary{
                view.removeFromSuperview()
            }
            self.stickerDictionary.removeAll()
            
            
            //self.makeTableAppear()
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
                for case let textField as UITextView in (sticker.subviews){
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
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 20){
                        stickerView.stickerStatus = textField.text!
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
                for case let textField as UITextView in (sticker.subviews){
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
                for case let textField as UITextField in (sticker.subviews){
                    if (textField.tag == 20){
                        stickerView.stickerStatus = textField.text!
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
                    
                    //This the view id
                    if (textField.tag == 9){
                        textField.text = String(index+1)
                    }
                    //self.view.addSubview(sticker)
                }
            }
            
            
            //Add Stickers to timeline
            for (index,sticker) in stickerDictionary.enumerate(){
                timeLineView.insertArrangedSubview(sticker, atIndex: index)
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
        
        
        //Create Icons
        for view in timeLineViewIcon.arrangedSubviews{
            view.removeFromSuperview()
        }
        stickerDictionaryIcon.removeAll()
        for sticker in stickerDictionary{
            let iconView = UIView()
            iconView.frame = CGRectMake(0,0,200, 130)
            iconView.layer.cornerRadius = 5
            iconView.tag = sticker.tag
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 7){
                    switch(textField.text!){
                    case "orange":
                        iconView.backgroundColor = UIColor.orangeColor()
                    case "red":
                        iconView.backgroundColor = UIColor.redColor()
                    case "green":
                        iconView.backgroundColor = UIColor.greenColor()
                    default:
                        iconView.backgroundColor = UIColor.greenColor()
                    }
                    
                }
                
            }
            
            
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 8){
                    let textCurrentName = UITextView(frame: CGRectMake(2.0, 1.0, 50.0, 30.0))
                    textCurrentName.textAlignment = NSTextAlignment.Center
                    textCurrentName.font = UIFont.italicSystemFontOfSize(8)
                    textCurrentName.textColor = UIColor.blackColor()
                    textCurrentName.backgroundColor = UIColor.clearColor()
                    textCurrentName.tag = 8
                    textCurrentName.textAlignment = NSTextAlignment.Justified
                    textCurrentName.text = textField.text!
                    textCurrentName.editable = false
                    iconView.addSubview(textCurrentName)
                }
                
            }
            
            iconView.heightAnchor.constraintEqualToConstant(35).active = true
            iconView.widthAnchor.constraintEqualToConstant(55).active = true
            stickerDictionaryIcon.append(iconView)
            
        }
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionaryIcon.enumerate(){
            timeLineViewIcon.insertArrangedSubview(sticker, atIndex: index)
        }
        
    
    }



    func buttonViewAllFilesPressed(sender: UIButton!){
        makeTableAppear()
        
    }
    
    
    func buttonHideAllFilesPressed(sender: UIButton!){
        makeTableDisappear()
        
    }
    

    func makeTableAppear(){
        allFilesTableView.frame = CGRectMake(580, 20, 130, 130)
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


    func makeTableDisappear(){
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
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged2:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        view.tag = 1
        view.hidden = false
        
        
        let viewControl = UIView()
        viewControl.frame = CGRectMake(2, 2, 200, 120)
        viewControl.backgroundColor = UIColor.clearColor()
        viewControl.layer.cornerRadius = 6
        viewControl.addGestureRecognizer(gesture)
        viewControl.userInteractionEnabled = true
        viewControl.tag = 19
        viewControl.hidden = true
        
        
        let textTitle = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textTitle.textAlignment = NSTextAlignment.Center
        textTitle.font = UIFont.italicSystemFontOfSize(8)
        textTitle.textColor = UIColor.blackColor()
        textTitle.tag = 2
        textTitle.hidden = true
        
        let textTitleStatus = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textTitleStatus.textAlignment = NSTextAlignment.Center
        textTitleStatus.font = UIFont.italicSystemFontOfSize(8)
        textTitleStatus.textColor = UIColor.blackColor()
        textTitleStatus.tag = 20
        textTitleStatus.hidden = true
        textTitleStatus.text = "current"
        
        
        let textViewId = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textViewId.textAlignment = NSTextAlignment.Center
        textViewId.font = UIFont.italicSystemFontOfSize(8)
        textViewId.textColor = UIColor.blackColor()
        textViewId.tag = 9
        textViewId.hidden = true
        
        
        let textCurrentColor = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textCurrentColor.textAlignment = NSTextAlignment.Center
        textCurrentColor.font = UIFont.italicSystemFontOfSize(8)
        textCurrentColor.textColor = UIColor.blackColor()
        textCurrentColor.tag = 7
        textCurrentColor.hidden = true
        textCurrentColor.text = "green"
        
        
        
        let textCurrentName = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 16.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = "Name this Sticker "+String(stickerNumber)
        textCurrentName.addTarget(self, action: "nameChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        
        let textField = UITextView(frame: CGRectMake(0.0, 19.0, 200.0, 93.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(10)
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        textField.tag = 3
        
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        buttonOrangeColor.frame = CGRectMake(50, 95, 30, 8.0)
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
        
        let buttonRedColor:UIButton! = UIButton(type: .System)
        buttonRedColor.frame = CGRectMake(73, 112, 30, 8.0)
        buttonRedColor.layer.cornerRadius = 3
        buttonRedColor.backgroundColor = UIColor.redColor()
        buttonRedColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonRedColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonRedColor.setTitle("Red", forState: UIControlState.Normal)
        buttonRedColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRedColor.addTarget(self, action: "buttonRedColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(140, 112, 30, 8.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeletePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let buttonFlip:UIButton! = UIButton(type: .System)
        buttonFlip.frame = CGRectMake(150, 100, 20, 8.0)
        buttonFlip.layer.cornerRadius = 3
        buttonFlip.backgroundColor = UIColor.brownColor()
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: "buttonFlipPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonFlipBack:UIButton! = UIButton(type: .System)
        buttonFlipBack.frame = CGRectMake(148, 98, 20, 8.0)
        buttonFlipBack.layer.cornerRadius = 3
        buttonFlipBack.backgroundColor = UIColor.brownColor()
        buttonFlipBack.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlipBack.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlipBack.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlipBack.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlipBack.addTarget(self, action: "buttonFlipBackPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        view.addSubview(textField)
        view.addSubview(textTitleStatus)
        view.addSubview(textCurrentColor)
        view.addSubview(textCurrentName)
        viewControl.addSubview(buttonOrangeColor)
        viewControl.addSubview(buttonGreenColor)
        viewControl.addSubview(buttonRedColor)
        viewControl.addSubview(buttonDelete)
        view.addSubview(buttonFlip)
        view.addSubview(textViewId)
        view.addSubview(viewControl)
        viewControl.addSubview(buttonFlipBack)
        
        stickerDictionary.append(view)
        view.addSubview(textTitle)
        view.heightAnchor.constraintEqualToConstant(125).active = true
        view.widthAnchor.constraintEqualToConstant(205).active = true
        
        
    }
    
    
    func makeStickerFromFile(sticker: Sticker){
        //Declared First because we need to switch the background color
        let textCurrentColor = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textCurrentColor.textAlignment = NSTextAlignment.Center
        textCurrentColor.font = UIFont.italicSystemFontOfSize(8)
        textCurrentColor.textColor = UIColor.blackColor()
        textCurrentColor.tag = 7
        textCurrentColor.hidden = true
        
        
        
        let view = UIView()
        view.frame = CGRectMake(CGFloat(sticker.xPosition), CGFloat(sticker.yPosition), CGFloat(sticker.width), CGFloat(sticker.height))
        switch(sticker.backgroundColor){
        case "orange":
            view.backgroundColor = UIColor.orangeColor()
            textCurrentColor.text = "orange"
        case "red":
            view.backgroundColor = UIColor.redColor()
            textCurrentColor.text = "red"
        case "green":
            view.backgroundColor = UIColor.greenColor()
            textCurrentColor.text = "green"
        default:
            view.backgroundColor = UIColor.greenColor()
            textCurrentColor.text = "green"
        }
        view.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged2:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        view.tag = 6
        
        
        let viewControl = UIView()
        viewControl.frame = CGRectMake(2, 2, 200, 120)
        viewControl.backgroundColor = UIColor.clearColor()
        viewControl.layer.cornerRadius = 6
        viewControl.addGestureRecognizer(gesture)
        viewControl.userInteractionEnabled = true
        viewControl.tag = 19
        viewControl.hidden = true
        
        
        let textTitle = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textTitle.textAlignment = NSTextAlignment.Center
        textTitle.font = UIFont.italicSystemFontOfSize(8)
        textTitle.textColor = UIColor.blackColor()
        textTitle.tag = 2
        textTitle.text = sticker.stickerId
        textTitle.hidden = true
        
        
        let textZoomStatus = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textZoomStatus.textAlignment = NSTextAlignment.Center
        textZoomStatus.font = UIFont.italicSystemFontOfSize(8)
        textZoomStatus.textColor = UIColor.blackColor()
        textZoomStatus.tag = 24
        textZoomStatus.text = "false"
        textZoomStatus.hidden = true
        
        
        let textTitleStatus = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textTitleStatus.textAlignment = NSTextAlignment.Center
        textTitleStatus.font = UIFont.italicSystemFontOfSize(8)
        textTitleStatus.textColor = UIColor.blackColor()
        textTitleStatus.tag = 20
        textTitleStatus.hidden = true
        textTitleStatus.text = sticker.stickerStatus
        
        
        let textViewId = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textViewId.textAlignment = NSTextAlignment.Center
        textViewId.font = UIFont.italicSystemFontOfSize(8)
        textViewId.textColor = UIColor.blackColor()
        textViewId.tag = 9
        textViewId.hidden = true
        
        
        
        let textCurrentName = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 16.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = sticker.stickerName
        textCurrentName.addTarget(self, action: "nameChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        let textField = UITextView(frame: CGRectMake(0.0, 19.0, 200.0, 93.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(10)
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        textField.tag = 3
        textField.text = sticker.text
        
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        buttonOrangeColor.frame = CGRectMake(50, 95, 30, 8.0)
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
        
        let buttonRedColor:UIButton! = UIButton(type: .System)
        buttonRedColor.frame = CGRectMake(73, 112, 30, 8.0)
        buttonRedColor.layer.cornerRadius = 3
        buttonRedColor.backgroundColor = UIColor.redColor()
        buttonRedColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonRedColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonRedColor.setTitle("Red", forState: UIControlState.Normal)
        buttonRedColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRedColor.addTarget(self, action: "buttonRedColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(140, 112, 30, 8.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeletePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let buttonFlip:UIButton! = UIButton(type: .System)
        buttonFlip.frame = CGRectMake(150, 100, 20, 8.0)
        buttonFlip.layer.cornerRadius = 3
        buttonFlip.backgroundColor = UIColor.brownColor()
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: "buttonFlipPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonFlipBack:UIButton! = UIButton(type: .System)
        buttonFlipBack.frame = CGRectMake(148, 98, 20, 8.0)
        buttonFlipBack.layer.cornerRadius = 3
        buttonFlipBack.backgroundColor = UIColor.brownColor()
        buttonFlipBack.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlipBack.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlipBack.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlipBack.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlipBack.addTarget(self, action: "buttonFlipBackPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        view.addSubview(textField)
        view.addSubview(textTitleStatus)
        view.addSubview(textCurrentColor)
        view.addSubview(textCurrentName)
        viewControl.addSubview(buttonOrangeColor)
        viewControl.addSubview(buttonGreenColor)
        viewControl.addSubview(buttonRedColor)
        viewControl.addSubview(buttonDelete)
        view.addSubview(buttonFlip)
        view.addSubview(textViewId)
        view.addSubview(viewControl)
        viewControl.addSubview(buttonFlipBack)
        
        
        stickerDictionary.append(view)
        view.addSubview(textTitle)
        
        view.heightAnchor.constraintEqualToConstant(125).active = true
        view.widthAnchor.constraintEqualToConstant(205).active = true
        
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
    
    
    
    
    func dragged2(gesture: UIPanGestureRecognizer){
        if(gesture.state == UIGestureRecognizerState.Began){
            //We do not do anything in the touches began method yet
        }
        if(gesture.state == UIGestureRecognizerState.Changed){
            let gesturedView = gesture.view!
            
            var center = gesturedView.center
            let translation = gesture.translationInView(gesturedView)
            center = CGPointMake(center.x + translation.x, center.y + translation.y)
            gesturedView.center = center
            gesture.setTranslation(CGPointZero, inView: gesturedView)
            
        }
        
        if(gesture.state == UIGestureRecognizerState.Ended){
            for view in timeLineView.arrangedSubviews{
                if(gesture.view!.frame.intersects(view.frame)){
                    let gesturedView = gesture.view
                    let destinationView = view
                    var gesturedViewId = 1
                    var destinationViewId = 1
                    //Text field tagged 9 stores a secret id for the related view
                    //Because you cannot guarantee that the index you give the view 
                    //When putting it on the stack view will actually be preserved throught out
                    //The lifecycle of the app
                    //So we always check against the dictionary of our views in the array
                    for case let textField as UITextField in gesturedView!.subviews{
                        if (textField.tag == 9){
                            gesturedViewId = Int(textField.text!)!-1
                        }
                    }
                    
                    for case let textField as UITextField in destinationView.subviews{
                        if (textField.tag == 9){
                            destinationViewId = Int(textField.text!)!-1
                        }
                    }
                    
                    for case let textField as UITextField in gesturedView!.subviews{
                        if (textField.tag == 9){
                            textField.text = String(destinationViewId)
                        }
                    }
                    
                    for case let textField as UITextField in destinationView.subviews{
                        if (textField.tag == 9){
                            textField.text = String(gesturedViewId)
                            
                        }
                    }
                    
                    stickerDictionary.removeAtIndex(gesturedViewId)
                    destinationView.tag = gesturedViewId
                    stickerDictionary.insert(destinationView, atIndex: gesturedViewId)
                    stickerDictionary.removeAtIndex(destinationViewId)
                    gesturedView!.tag = destinationViewId
                    stickerDictionary.insert(gesturedView!, atIndex: destinationViewId)
                    
                    
                    //Add Stickers to timeline
                    for (index,sticker) in stickerDictionary.enumerate(){
                        for case let textField as UITextField in sticker.subviews{
                            if (textField.tag == 2){
                                textField.text = "Sticker Number "+String(index+1)
                            }
                            
                            if (textField.tag == 9){
                                textField.text = String(index+1)
                            }
                            
                        }
                        timeLineView.insertArrangedSubview(sticker, atIndex: index)
                    }
                    
                    refreshStickers()
                }
                
            }
        
    }
        
}
    
    func nameChanged(textField: UITextField){
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == textField.superview?.tag){
                for case let textFieldName as UITextView in view.subviews{
                    if (textFieldName.tag == 8){
                        textFieldName.text = textField.text!
                    }
                    
                }
            }
        }
    }

}