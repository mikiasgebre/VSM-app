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
    var stickerDictionaryTrash = [UIView]()
    var stickerDictionaryArchive = [UIView]()
    let allFilesTableView = UITableView()
    var retrievedFileNames = [String]()
    let timeLineView = UIStackView()
    let timeLineViewIcon = UIStackView()
    var scrollView:UIScrollView!
    var scrollViewIcon:UIScrollView!
    var containerTable:UIView!
    let trashView = UIView()
    var trashViewOffset = CGFloat(70.0)
    let archiveView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createScrollAndContainerView() //Contains some code for scroll view and stackview
        makeSaveButton()
        makeViewAllFilesButton()
        makeButtonRefreshStickers()
        makeButtonFileAsPdf()
        makeHeaderButtons()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //For initializing the scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRectMake(0,0,view.frame.width-0.2, 1000)
        scrollView.contentSize = CGSizeMake(timeLineView.frame.width, 1000)
        scrollView.scrollEnabled = true
        scrollView.contentInset = UIEdgeInsetsMake(0, 274, 0, 318.6)
        scrollView.userInteractionEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        scrollView.tag = 220
        
        
        scrollViewIcon.frame = CGRectMake(0,895,view.frame.width-0.2, 95)
        scrollViewIcon.contentSize = CGSizeMake(timeLineViewIcon.frame.width, 95)
        scrollViewIcon.scrollEnabled = true
        scrollViewIcon.contentInset = UIEdgeInsetsMake(0, 70, 0, 10)
        scrollViewIcon.userInteractionEnabled = true
        scrollViewIcon.alwaysBounceHorizontal = true
        scrollViewIcon.tag = 221
    }
    
    //The table shows you a list of files that are currently saved
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int)->Int{
        return self.retrievedFileNames.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell{
        let cell:UITableViewCell = allFilesTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.retrievedFileNames[indexPath.row]
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        let pathToIndex = tableView.indexPathForSelectedRow
        let tappedCell = tableView.cellForRowAtIndexPath(pathToIndex!)! as UITableViewCell
        let newFile = tappedCell.textLabel?.text
        //Tap to view the file at a row
        let predicate = NSPredicate(format: "fileName == %@", newFile!)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count == 0){
            createAlertViewCancel("View File", message: "File With File Name ("+newFile!+") does not exist")
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
            
            
            //This is future button
            for view in self.view.subviews{
                if(view.tag==118){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            
            //This is improvements button
            for view in self.view.subviews{
                if(view.tag==119){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            //This is header title
            for case let textField as UITextField in self.view.subviews{
                if (textField.tag == 57){
                    textField.text = "Create future state"
                }
            }
            
            //This is header file name
            for case let textField as UITextField in self.view.subviews{
                if (textField.tag == 59){
                    textField.text = newFile
                }
            }
            
            //This hides the other backgrounds
            for view in self.view.subviews{
                if(view.tag==571){//Improvements background
                    view.hidden = true
                }
                if(view.tag==572){//Editor
                    view.hidden = true
                }
                if(view.tag==570){//Process background
                    view.hidden = false
                }
            }
            createIcons()
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.backgroundColor = UIColor.clearColor()
        cell.indentationLevel = 2
        
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //let pathToIndex = tableView.indexPathForSelectedRow
        let tappedCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let newFile = tappedCell.textLabel?.text
        deleteSavedFile(newFile!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Button that creates the post it sticker pieces
    /*func makeButtonCreateSticker(){
        let buttonCreateSticker:UIButton! = UIButton(type: .System)
        buttonCreateSticker.frame = CGRectMake(180, 20, 160, 30)
        buttonCreateSticker.layer.cornerRadius = 5
        buttonCreateSticker.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonCreateSticker.titleLabel?.numberOfLines = 0
        buttonCreateSticker.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonCreateSticker.backgroundColor = UIColor.greenColor()
        buttonCreateSticker.setTitle("Add Sticker", forState: UIControlState.Normal)
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
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        createSticker("green")
        
        
        //This hides the other backgrounds
        for view in self.view.subviews{
            if(view.tag==571){//Improvements background
                view.hidden = true
            }
            if(view.tag==572){//Editor or future
                view.hidden = false
            }
            if(view.tag==570){//Process background
                view.hidden = true
            }
        }
    }*/
    
    
    func createSticker(stickerColor: String){
        let stickerName = "Sticker Number "+String(stickerDictionary.count+1)
        let stickerNumber = stickerDictionary.count+1
        makeSticker(stickerName, stickerNumber: stickerNumber, stickerColor: stickerColor)
        for (index,sticker) in stickerDictionary.enumerate(){
            sticker.tag = index
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 2){
                    textField.text = "Sticker Number "+String(index+1)
                }
                
                if (textField.tag == 8){
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
        }
        
        createIcons()
        scrollView.setContentOffset(CGPoint(x: timeLineView.arrangedSubviews.count*243, y: 0), animated: false)
        scrollViewIcon.setContentOffset(CGPoint(x: timeLineViewIcon.arrangedSubviews.count*548, y: 0), animated: false)
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(scrollView.tag==220){
        var zoomedView = UIView()
            for view in timeLineView.arrangedSubviews{
                if(view.frame.width>171){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                    zoomedView = view
                }
            }
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == zoomedView.tag){
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView.tag==220){
        let offset = scrollView.contentOffset.x
        let sections = ceil(offset/242.6) //Each sticker has this width, the offset is from origin of scrollview to end of timeline backwards
        let fullOffset = (sections*242.6)-72
        
        var itemNumber = Int(sections)
        print("Offset "+String(itemNumber))
        
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
                    view.transform = CGAffineTransformMakeScale(1.4, 1.4)
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
            
            
            for view in stickerDictionaryIcon{//Before we zoom anything, make sure all are reset
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            
            for view in timeLineViewIcon.arrangedSubviews{
                if (view.tag == itemNumber+1){
                    view.transform = CGAffineTransformMakeScale(1.4, 1.4)
                }
            }
        }
        trashViewOffset = fullOffset+72
        drawTrash()
        drawArchive()
        trashView.hidden = false
        archiveView.hidden = false
        }
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonRefreshStickers(){
        let buttonRefreshStickers:UIButton! = UIButton(type: .System)
        buttonRefreshStickers.frame = CGRectMake(700, 60, 25, 20)
        buttonRefreshStickers.layer.cornerRadius = 9
        buttonRefreshStickers.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        buttonRefreshStickers.titleLabel?.numberOfLines = 0
        buttonRefreshStickers.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonRefreshStickers.backgroundColor = UIColor.brownColor()
        buttonRefreshStickers.setTitle("R", forState: UIControlState.Normal)
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
    
    
    //Non Button action method
    func refreshStickers(){
        //The original approach as the one for the icons was failing when there were two stickers
        let refreshView = UIView()
        timeLineView.addSubview(refreshView)
        timeLineView.removeArrangedSubview(refreshView)
        
    }
    
    
    //Non Button action method
    func refreshStickersIcon(){
        for view in timeLineViewIcon.arrangedSubviews{
            view.removeFromSuperview()
        }
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionaryIcon.enumerate(){
            timeLineViewIcon.insertArrangedSubview(sticker, atIndex: index)
        }
        
    }

    
    //Button that creates the post it sticker pieces
    func makeButtonFileAsPdf(){
        let buttonPdfImage = UIImageView()
        buttonPdfImage.frame = CGRectMake(700, 20, 30, 30)
        buttonPdfImage.image = UIImage(named: "Save.png")
        buttonPdfImage.userInteractionEnabled = true
        
        
        let buttonFileAsPdf:UIButton! = UIButton(type: .System)
        buttonFileAsPdf.frame = CGRectMake(0, 0, 30, 30)
        buttonFileAsPdf.layer.cornerRadius = 5
        buttonFileAsPdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonFileAsPdf.titleLabel?.numberOfLines = 0
        buttonFileAsPdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonFileAsPdf.backgroundColor = UIColor.clearColor()
        buttonFileAsPdf.setTitle("Pdf", forState: UIControlState.Normal)
        buttonFileAsPdf.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonFileAsPdf.addTarget(self, action: "buttonFileAsPdfPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        buttonPdfImage.addSubview(buttonFileAsPdf)
        
        
        self.view.addSubview(buttonPdfImage)
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
        
        let buttonPdfImage = UIImageView()
        buttonPdfImage.frame = CGRectMake(700, 20, 30, 30)
        buttonPdfImage.image = UIImage(named: "Save.png")
        buttonPdfImage.userInteractionEnabled = true
        
        
        
        let buttonFileAsPdf:UIButton! = UIButton(type: .System)
        buttonFileAsPdf.frame = CGRectMake(0, 0, 30, 30)
        buttonFileAsPdf.layer.cornerRadius = 5
        buttonFileAsPdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonFileAsPdf.titleLabel?.numberOfLines = 0
        buttonFileAsPdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonFileAsPdf.backgroundColor = UIColor.clearColor()
        buttonFileAsPdf.setTitle("Pdf", forState: UIControlState.Normal)
        buttonFileAsPdf.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonFileAsPdf.addTarget(self, action: "buttonFileAsPdfRemovePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        buttonPdfImage.addSubview(buttonFileAsPdf)
        self.view.addSubview(buttonPdfImage)
        
        
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
        sender.superview?.superview!.removeFromSuperview()
        sender.superview!.removeFromSuperview()
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
        webViewContainer.frame = CGRectMake(5, 5, 590, 845.8)
        
        let webView = UIWebView()
        webView.frame = CGRectMake(5, 50, 580, 841.8)
        webView.tag = 72
        
        
        var startIndex = 0
        var endIndex = 0
        let stickerCount = stickerDictionary.count
        var groupCount = 0.0
        let remainder = stickerDictionary.count%3
        if(stickerDictionary.count%3 == 0){
            groupCount = (Double(stickerDictionary.count)/3.0)
        }
        if(stickerDictionary.count%3 != 0){
            groupCount = (Double(stickerDictionary.count)/3.0)+1
        }
        
        
        for (var group = 0.2; group < groupCount; group++){
            if(startIndex+3 <= stickerCount){
                endIndex = startIndex+3
            }
            if(startIndex+3 > stickerCount){
                startIndex = stickerCount - remainder
                endIndex = stickerCount
            }
            var count = 0.1  //This is needed to increase the x component
            for (var index = startIndex; index < endIndex; index++){
                UIGraphicsBeginImageContextWithOptions(CGRectMake(0, 0, 170.6, 170.6).size, false, 0)
                stickerDictionary[index].drawViewHierarchyInRect(CGRectMake(0, 0, 170.6, 170.6), afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let imageView = UIImageView(image: image)
                imageView.frame = CGRectMake(CGFloat(count*190), CGFloat(190*group), 170.6, 170.6)
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
        
        let buttonPdfImage = UIImageView()
        buttonPdfImage.frame = CGRectMake(220, 20, 30, 30)
        buttonPdfImage.image = UIImage(named: "Save.png")
        buttonPdfImage.userInteractionEnabled = true
        buttonPdfImage.center.x = webViewContainer.center.x
        
        
        
        let buttonFileAsPdf:UIButton! = UIButton(type: .System)
        buttonFileAsPdf.frame = CGRectMake(-10, 0, 50, 30)
        buttonFileAsPdf.layer.cornerRadius = 5
        buttonFileAsPdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonFileAsPdf.titleLabel?.numberOfLines = 0
        buttonFileAsPdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonFileAsPdf.backgroundColor = UIColor.clearColor()
        buttonFileAsPdf.setTitle("Pdf", forState: UIControlState.Normal)
        buttonFileAsPdf.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonFileAsPdf.addTarget(self, action: "buttonFileAsPdfRemovePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonPdfImage.addSubview(buttonFileAsPdf)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        buttonFileAsPdf.addGestureRecognizer(gesture)
        buttonFileAsPdf.userInteractionEnabled = true
        buttonFileAsPdf.tag = 45
        
        
        webViewContainer.addSubview(buttonPdfImage)
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

    
    
    func drawTrash(){
        let viewImage = UIImageView()
        viewImage.frame = CGRectMake(0, 0, 35, 35)
        viewImage.tag = 111
        viewImage.image = UIImage(named: "Delete.png")
        
        
        trashView.frame = CGRectMake(trashViewOffset, 780, 35, 35)
        trashView.backgroundColor = UIColor.clearColor()
        trashView.layer.cornerRadius = 6
        trashView.tag = 4
        scrollView.addSubview(trashView)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged2:"))
        trashView.addGestureRecognizer(gesture)
        trashView.userInteractionEnabled = true
        trashView.tag = 1
        trashView.addSubview(viewImage)
        
    }
    
    
    func drawArchive(){
        
        let viewImage = UIImageView()
        viewImage.frame = CGRectMake(0, 0, 35, 35)
        viewImage.tag = 112
        viewImage.image = UIImage(named: "Archive.png")
        
        
        archiveView.frame = CGRectMake(trashViewOffset+620, 780, 35, 35)
        archiveView.backgroundColor = UIColor.blueColor()
        archiveView.layer.cornerRadius = 6
        archiveView.tag = 4
        scrollView.addSubview(archiveView)
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged2:"))
        archiveView.addGestureRecognizer(gesture)
        archiveView.userInteractionEnabled = true
        archiveView.tag = 1
        archiveView.addSubview(viewImage)
    }

    
    
    
    func createScrollAndContainerView() {
        scrollView = UIScrollView()
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        //scrollView.backgroundColor = UIColor.brownColor()
        
        let scrollViewImage = UIImageView()
        scrollViewImage.frame = CGRectMake(0,50,view.frame.width-0.2, 1000)
        scrollViewImage.image = UIImage(named: "Process_background.png")
        scrollViewImage.tag = 570
        self.view.addSubview(scrollViewImage)
        scrollViewImage.hidden = false
        
        let scrollViewImageImprovements = UIImageView()
        scrollViewImageImprovements.frame = CGRectMake(0,50,view.frame.width-0.2, 1000)
        scrollViewImageImprovements.image = UIImage(named: "improvements_background.png")
        scrollViewImageImprovements.tag = 571
        self.view.addSubview(scrollViewImageImprovements)
        scrollViewImageImprovements.hidden = true
        
        
        let scrollViewImageFuture = UIImageView()
        scrollViewImageFuture.frame = CGRectMake(0,50,view.frame.width-0.2, 1000)
        scrollViewImageFuture.image = UIImage(named: "Editor_background.png")
        scrollViewImageFuture.tag = 572
        self.view.addSubview(scrollViewImageFuture)
        scrollViewImageFuture.hidden = true
        
        
        scrollViewIcon = UIScrollView()
        //scrollViewIcon.delegate = self
        scrollViewIcon.maximumZoomScale = 2
        scrollViewIcon.minimumZoomScale = 1
        
        
        containerTable = UIView()
        containerTable.frame = CGRectMake(380, 80, 250, 250)
        containerTable.userInteractionEnabled = true
        containerTable.backgroundColor = UIColor.clearColor()
        self.view.addSubview(containerTable)
        
        
        //Timeline is basically a stackview
        timeLineView.userInteractionEnabled = true
        timeLineView.axis = UILayoutConstraintAxis.Horizontal
        timeLineView.distribution = .Fill
        timeLineView.alignment = UIStackViewAlignment.Center
        timeLineView.spacing = 72
        timeLineView.tag = 30
        timeLineView.backgroundColor = UIColor.redColor()
        timeLineView.layoutMarginsRelativeArrangement = true
        timeLineView.translatesAutoresizingMaskIntoConstraints = false
        timeLineView.heightAnchor.constraintEqualToConstant(900).active = true
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
        timeLineViewIcon.heightAnchor.constraintEqualToConstant(1880).active = true
        
        
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
        
        for case let textField as UIImageView in sentView!.subviews{
            if (textField.tag == 17){
                textField.image = UIImage(named: "Sticker_orange.png")
            }
        }
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                for views in view.subviews{
                    if(views.tag == 5){
                        for case let imageView as UIImageView in views.subviews{
                            if(imageView.tag == 113){
                                imageView.image = UIImage(named: "Sticker_orange.png")
                            }
                        }
                    }
                    if(views.tag == 6){
                        for case let imageView as UIImageView in views.subviews{
                            if(imageView.tag == 115){
                                imageView.image = UIImage(named: "Sticker_orange.png")
                            }
                        }
                    }
                }
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
        
        for case let textField as UIImageView in sentView!.subviews{
            if (textField.tag == 17){
                textField.image = UIImage(named: "Sticker_green.png")
            }
        }
        
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                for views in view.subviews{
                    if(views.tag == 5){
                        for case let imageView as UIImageView in views.subviews{
                            if(imageView.tag == 113){
                                imageView.image = UIImage(named: "Sticker_green.png")
                            }
                        }
                    }
                    if(views.tag == 6){
                        for case let imageView as UIImageView in views.subviews{
                            if(imageView.tag == 115){
                                imageView.image = UIImage(named: "Sticker_green.png")
                            }
                        }
                    }
                }
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
        
        for case let textField as UIImageView in sentView!.subviews{
            if (textField.tag == 17){
                textField.image = UIImage(named: "Sticker_red.png")
            }
        }
        
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == sentView?.tag){
                for views in view.subviews{
                    if(views.tag == 5){
                        for case let imageView as UIImageView in views.subviews{
                            if(imageView.tag == 113){
                                imageView.image = UIImage(named: "Sticker_red.png")
                            }
                        }
                    }
                    if(views.tag == 6){
                        for case let imageView as UIImageView in views.subviews{
                            if(imageView.tag == 115){
                                imageView.image = UIImage(named: "Sticker_red.png")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func buttonDeletePressed(sender: UIButton!){
        deleteSticker((sender.superview?.superview)!)
    }
    
    
    
    func deleteSticker(sticker: UIView){
        let sentView = sticker
        sentView.removeFromSuperview()
        for (index,sticker) in stickerDictionary.enumerate(){
            if(sticker.tag==sentView.tag){
               stickerDictionary.removeAtIndex(index)
            }
        }
        
        
        for (index,sticker) in stickerDictionary.enumerate(){
            sticker.tag = index
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 2){
                    textField.text = "Sticker Number "+String(index+1)
                }
            }
            
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 8){
                    textField.text = "Name This Sticker "+String(index+1)
                }
            }
            
            
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 9){
                    textField.text = String(index+1)
                }
            }
            
        }
        
        //remove Stickers off timeline
        for view in timeLineView.arrangedSubviews{
           view.removeFromSuperview()
       }
        
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionary.enumerate(){
            timeLineView.insertArrangedSubview(sticker, atIndex: index)
        }
        
        createIcons()
        
        let lengthOriginToTap = Float(sentView.tag)*242.6
        if(sentView.tag == stickerDictionary.count){
            scrollView.setContentOffset(CGPoint(x: CGFloat(lengthOriginToTap-767.8), y: CGFloat(0)), animated: false)
        }else{
        scrollView.setContentOffset(CGPoint(x: CGFloat(lengthOriginToTap-296.6), y: CGFloat(0)), animated: false)
        }
        
        trashViewOffset = CGFloat(lengthOriginToTap-Float(245))
        drawTrash()
        drawArchive()
        trashView.hidden = false
        archiveView.hidden = false
    }
    
    
    
    func createIcons(){
        //Remove the existing icons off the timeline
        for view in timeLineViewIcon.arrangedSubviews{
            view.removeFromSuperview()
        }
        //Remove all the icons from the icon dictionary
        stickerDictionaryIcon.removeAll()
    for sticker in stickerDictionary{
        //This is the main icon view which has an icon and a mirror of the icon
        let iconViewMain = UIView()
        iconViewMain.frame = CGRectMake(0,0,200, 270)
        iconViewMain.layer.cornerRadius = 5
        iconViewMain.tag = sticker.tag
        
        
        //This is the mirror image of the icon
        let bottomIcon = UIView()
        bottomIcon.frame = CGRectMake(0, 50, 35, 35)
        bottomIcon.layer.cornerRadius = 5
        bottomIcon.transform = CGAffineTransformMakeScale(-1.0, -1.0)
        bottomIcon.tag = 6
        
        
        //This is the image of the real icon
        let iconImage = UIImageView()
        iconImage.frame = CGRectMake(-5, -5, 45, 45)
        iconImage.tag = 113
        iconImage.image = UIImage(named: "Sticker_green.png")
        
        
        //This is the image of the bottom icon
        let bottomIconImage = UIImageView()
        bottomIconImage.frame = CGRectMake(-5, -5, 45, 45)
        bottomIconImage.tag = 115
        bottomIconImage.image = UIImage(named: "Sticker_green.png")
        
        //This is the icon view
        let iconView = UIView()
        iconView.frame = CGRectMake(0,0,35, 35)
        iconView.layer.cornerRadius = 5
        iconView.tag = 5
        let gesture = UITapGestureRecognizer(target: self, action: Selector("iconTapped:"))
        iconView.addGestureRecognizer(gesture)
        for case let textField as UITextField in sticker.subviews{
            if (textField.tag == 7){
                switch(textField.text!){
                    case "orange":
                        //iconView.backgroundColor = UIColor.orangeColor()
                        iconImage.image = UIImage(named: "Sticker_orange.png")
                        //bottomIcon.backgroundColor = UIColor.orangeColor()
                        bottomIconImage.image = UIImage(named: "Sticker_orange.png")
                    case "red":
                        //iconView.backgroundColor = UIColor.redColor()
                        iconImage.image = UIImage(named: "Sticker_red.png")
                        //bottomIcon.backgroundColor = UIColor.redColor()
                        bottomIconImage.image = UIImage(named: "Sticker_red.png")
                    case "green":
                        //iconView.backgroundColor = UIColor.greenColor()
                        iconImage.image = UIImage(named: "Sticker_green.png")
                        //bottomIcon.backgroundColor = UIColor.greenColor()
                        bottomIconImage.image = UIImage(named: "Sticker_green.png")
                    default:
                        //iconView.backgroundColor = UIColor.greenColor()
                        iconImage.image = UIImage(named: "Sticker_green.png")
                        //bottomIcon.backgroundColor = UIColor.greenColor()
                        bottomIconImage.image = UIImage(named: "Sticker_green.png")
                }
            }
        }
        //Set the background of the mirror image
        bottomIcon.backgroundColor = iconView.backgroundColor
        
        //Current name of the sticker concerned
        let textCurrentName = UITextView(frame: CGRectMake(0.0, -3.0, 35.0, 35.0))
        for case let textField as UITextField in sticker.subviews{
            if (textField.tag == 8){
                textCurrentName.font = UIFont.italicSystemFontOfSize(7)
                textCurrentName.textColor = UIColor.blackColor()
                textCurrentName.backgroundColor = UIColor.clearColor()
                textCurrentName.tag = 8
                textCurrentName.text = textField.text!
                textCurrentName.editable = false
                iconView.addSubview(textCurrentName)
            }
        }
        iconView.addSubview(iconImage)
        iconView.sendSubviewToBack(iconImage)
        iconViewMain.addSubview(iconView)
        
        
        let midIconImage = UIImageView()
        midIconImage.frame = CGRectMake(-200, 48, CGFloat((stickerDictionaryIcon.count*250)+1000), 10)
        midIconImage.tag = 114
        midIconImage.image = UIImage(named: "Pile_page2-2.png")
        scrollViewIcon.sendSubviewToBack(midIconImage)
        scrollViewIcon.addSubview(midIconImage)
        
        
        let textName = UITextView()
        textName.frame = CGRectMake(0.0, -3.0, 35.0, 35.0)
        textName.font = UIFont.italicSystemFontOfSize(7)
        textName.textColor = UIColor.blackColor()
        textName.backgroundColor = UIColor.clearColor()
        textName.tag = 9
        textName.text = textCurrentName.text!
        textName.editable = false
        bottomIcon.addSubview(textName)
        
        bottomIcon.addSubview(bottomIconImage)
        bottomIcon.sendSubviewToBack(bottomIconImage)
        iconViewMain.addSubview(bottomIcon)
        
        
        iconViewMain.heightAnchor.constraintEqualToConstant(70).active = true
        iconViewMain.widthAnchor.constraintEqualToConstant(55).active = true
        stickerDictionaryIcon.append(iconViewMain)
    
    }
    
    //Add Stickers icons to timeline
    for (index,sticker) in stickerDictionaryIcon.enumerate(){
        timeLineViewIcon.insertArrangedSubview(sticker, atIndex: index)
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
    
    
    func buttonOptionsPressed(sender: UIButton!){
        /*//This is header title
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 116){
                if(view.hidden == false){
                    view.hidden = true
                }
                if(view.hidden == true){
                    
                }
            }
        }*/
    }
    
    
    
    func buttonFuturePressed(sender: UIButton!){
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        createSticker("green")
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1)
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1.2)
        
        //This is improvements button
        for view in self.view.subviews{
            if(view.tag==119){
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        
        
        //This is header title
        for case let textField as UITextField in self.view.subviews{
            if (textField.tag == 57){
                textField.text = "Create future state"
            }
        }
        
        //This hides the other backgrounds
        for view in self.view.subviews{
            if(view.tag==571){//Improvements background
                view.hidden = true
            }
            if(view.tag==572){//Editor or future
                view.hidden = false
            }
            if(view.tag==570){//Process background
                view.hidden = true
            }
        }
    }
    
    
    func buttonImprovementsPressed(sender: UIButton!){
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        createSticker("red")
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1)
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1.2)
        
        //This is future button
        for view in self.view.subviews{
            if(view.tag==118){
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        
        //This is header title
        for case let textField as UITextField in self.view.subviews{
            if (textField.tag == 57){
                textField.text = "Manage your improvements"
            }
        }
        
        //This hides the other backgrounds
        for view in self.view.subviews{
            if(view.tag==571){//Improvements background
                view.hidden = false
            }
            if(view.tag==572){//Editor
                view.hidden = true
            }
            if(view.tag==570){//Process background
                view.hidden = true
            }
        }
        
    }
    
    

    //This may be required to open as another thread in a future release
    
    func buttonProcessPressed(sender: UIButton!){
        createNewFile()
    }
    
    func buttonCreateNewFilePressed(sender: UIButton!){
        createNewFile()
    }
    
    
    func createNewFile(){
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        //Check if you have any views on screen
        if(stickerDictionary.count != 0){
        let newFileAlert = UIAlertController(title: "New File", message: "Are you sure you want to create another File without saving this one first? All changes if any in the current file will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        newFileAlert.view.backgroundColor = UIColor.greenColor()
        
        newFileAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            
                for view in self.view.subviews{
                    if(view.tag==59){
                        for case let textField as UITextField in view.subviews{
                                if (textField.tag == 5){
                                    textField.text = "Unsaved File"
                                }
                        }
                    }
                }
            
            //This is future button
            for view in self.view.subviews{
                if(view.tag==118){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            
            //This is improvements button
            for view in self.view.subviews{
                if(view.tag==119){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            //This is header title
            for case let textField as UITextField in self.view.subviews{
                if (textField.tag == 57){
                    textField.text = "Create future state"
                }
            }
            
            //This is header file name
            for case let textField as UITextField in self.view.subviews{
                if (textField.tag == 59){
                    textField.text = "Unsaved File"
                }
            }
            
            //This hides the other backgrounds
            for view in self.view.subviews{
                if(view.tag==571){//Improvements background
                    view.hidden = true
                }
                if(view.tag==572){//Editor
                    view.hidden = true
                }
                if(view.tag==570){//Process background
                    view.hidden = false
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
    
    func buttonOpenFilePressed(sender: UIButton!){
        makeTableAppear("")
    }
    
    func buttonSavePressed(sender: UIButton){
        if(stickerDictionary.count != 0){
            //This is what calls the save function
            createAlertViewInput("Save File/Process", message: "Enter File/Process Name.")
        }else{
            self.createAlertView("Save File/Process", message: "The current process/file contains zero items")
        }
    }
    
    
    func createAlertViewInput(title: String, message: String){
        var fileName = ""
        func configurationTextField(textField: UITextField){
            fileName = textField.text!
            
        }
        let newAlertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        newAlertView.view.backgroundColor = UIColor.greenColor()
        newAlertView.addTextFieldWithConfigurationHandler(configurationTextField)
        newAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            fileName = newAlertView.textFields![0].text!
            if(!fileName.isEmpty){
                if(!self.checkFileExists(fileName)){
                    self.saveFile(fileName)
                }else{
                    self.createAlertView("Save File/Process", message: "File With File Name"+"("+fileName+") already exists")
                }
            }else{
                self.createAlertView("Save File/Process", message: "You specified an empty file name")
            }
        }))
        newAlertView.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: {(action: UIAlertAction!) in
        }))
        presentViewController(newAlertView, animated: true, completion: nil)
        
    }
    
    
    
    func createAlertViewCancel(title: String, message: String){
        let newAlertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        newAlertView.view.backgroundColor = UIColor.greenColor()
        newAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            
        }))
        newAlertView.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: {(action: UIAlertAction!) in
        }))
        presentViewController(newAlertView, animated: true, completion: nil)
        
    }
    
    
    
    func createAlertView(title: String, message: String){
        let newAlertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        newAlertView.view.backgroundColor = UIColor.greenColor()
        newAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            
        }))
        presentViewController(newAlertView, animated: true, completion: nil)
    }
    
    
    func checkFileExists(filename: String) -> Bool{
        //Check if filename exists
        let predicate = NSPredicate(format: "fileName == %@", filename)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count != 0){
            return true
        }
        return false
    }
    
    
    func saveFile(filename: String){
        let predicate = NSPredicate(format: "fileName == %@", filename)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count == 0){// means file does not exist already
            let stickerFile = StickerFile()
            if(stickerFile.dateCreated == nil){
                stickerFile.dateCreated = NSDate()
            }
            if(stickerFile.dateCreated != nil){
                stickerFile.dateUpdated = NSDate()
            }
            stickerFile.fileName = filename
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(stickerFile)
            }
            for sticker in self.stickerDictionary{
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
                //stickerView.fileName = stickerFile
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
            createAlertView("File Saved As", message: "File Saved Successfully As "+"("+filename+")")
            
            
            //This is future button
            for view in self.view.subviews{
                if(view.tag==118){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            
            //This is improvements button
            for view in self.view.subviews{
                if(view.tag==119){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            //This is header file name
            for case let textField as UITextField in self.view.subviews{
                if (textField.tag == 59){
                    textField.text = filename
                }
            }
            
            //This hides the other backgrounds
            for view in self.view.subviews{
                if(view.tag==571){//Improvements background
                    view.hidden = true
                }
                if(view.tag==572){//Editor
                    view.hidden = true
                }
                if(view.tag==570){//Process background
                    view.hidden = false
                }
            }
            
            //Update view all files pane
            for view in self.view.subviews{
                if (view.tag == 4){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = filename
                        }
                    }
                }
            }
            
        }
    }
    
    
        func buttonUpdatePressed(sender: UIButton!){
                //This is header file name
                var newFile = ""
                if(stickerDictionary.count != 0){
                    for case let textField as UITextField in stickerDictionary[0].subviews{
                        if (textField.tag == 81){
                            newFile = textField.text!
                        }
                    }
                    //This is header file name
                    for case let textField as UITextField in self.view.subviews{
                        if (textField.tag == 59){
                            newFile = textField.text!
                        }
                    }
                    if(newFile.isEmpty){
                        self.createAlertView("Save File/Process", message: "You need to save as first")
                    }
                    if(!self.checkFileExists(newFile)){
                        self.createAlertView("Save File/Process", message: "The current process/file does not exist")
                    }
                    updateFile(newFile)
                }else{
                    self.createAlertView("Save File/Process", message: "The current process/file contains zero items")
                }
        }
    
    

    func updateFile(filename: String){
        let predicate = NSPredicate(format: "fileName == %@", filename)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
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
            
            createAlertView("File Saved/Updated", message: "File Saved/Updated Successfully"+"("+filename+")")
            
            //Update view all files pane
            for view in self.view.subviews{
                if (view.tag == 4){
                    for case let textField as UITextField in view.subviews{
                        if (textField.tag == 5){
                            textField.text = filename
                        }
                    }
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
        if(!checkFileExists(newFile)){
            createAlertView("Delete File", message: "File With File Name"+"("+newFile+") does not exist")
            return
        }
        createAlertView("Delete File", message: "Are you sure you want to Delete the File Named "+newFile+" ? All data in the file will be lost.")
        deleteSavedFile(newFile)
        
    }
    
    
    func deleteSavedFile(fileName: String){
            let predicate = NSPredicate(format: "fileName == %@", fileName)
            let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
            if(retrievedFileNames.count == 0){//file exists not
                createAlertView("Delete File", message: "File With File Name"+"("+fileName+") does not exist")
            }
            if(retrievedFileNames.count != 0){//file exists
                let newAlertView = UIAlertController(title: "Delete File", message: "Are you sure you want to Delete the File Named "+fileName+" ? All data in the file will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
                newAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
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
                    
                    if(self.stickerDictionary.count != 0){
                        for case let textField as UITextField in self.stickerDictionary[0].subviews{
                            if(textField.tag == 81){
                                if(textField.text == fileName){
                                    //Remove stikers
                                    for view in self.stickerDictionary{
                                        view.removeFromSuperview()
                                    }
                                    self.stickerDictionary.removeAll()
                                    
                                    //Remove stikers
                                    for view in self.stickerDictionaryIcon{
                                        view.removeFromSuperview()
                                    }
                                    self.stickerDictionaryIcon.removeAll()
                                    
                                    //This is future button
                                    for view in self.view.subviews{
                                        if(view.tag==118){
                                            view.transform = CGAffineTransformMakeScale(1, 1)
                                        }
                                    }
                                    
                                    
                                    //This is improvements button
                                    for view in self.view.subviews{
                                        if(view.tag==119){
                                            view.transform = CGAffineTransformMakeScale(1, 1)
                                        }
                                    }
                                    
                                    //This is header title
                                    for case let textField as UITextField in self.view.subviews{
                                        if (textField.tag == 57){
                                            textField.text = "Create future state"
                                        }
                                    }
                                    
                                    //This is header file name
                                    for case let textField as UITextField in self.view.subviews{
                                        if (textField.tag == 59){
                                            textField.text = "Unsaved File"
                                        }
                                    }
                                    
                                    //This hides the other backgrounds
                                    for view in self.view.subviews{
                                        if(view.tag==571){//Improvements background
                                            view.hidden = true
                                        }
                                        if(view.tag==572){//Editor
                                            view.hidden = true
                                        }
                                        if(view.tag==570){//Process background
                                            view.hidden = false
                                        }
                                    }
                                    
                                    self.createAlertView("Delete File", message: "Successfully Deleted"+"("+fileName+")")
                                }
                            }
                        }
                    }
                    
                }))
                newAlertView.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: {(action: UIAlertAction!) in
                }))
                presentViewController(newAlertView, animated: true, completion: nil)
                
                }
    }
    
    
    
    func makeSaveButton(){
        let viewSaveImage = UIImageView()
        viewSaveImage.frame = CGRectMake(590, 45, 80, 100.0)
        viewSaveImage.tag = 116
        viewSaveImage.image = UIImage(named: "Menu.png")
        viewSaveImage.userInteractionEnabled = true
        
        
        let viewSave = UIView()
        viewSave.frame = CGRectMake(0, 0, 80, 100)
        viewSave.backgroundColor = UIColor.clearColor()
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        viewSave.addGestureRecognizer(gesture)
        viewSave.userInteractionEnabled = true
        viewSave.tag = 4
        
        
        
        let textFieldSaveName = UITextField(frame: CGRectMake(2, 1.0, 70.0, 5.0))
        textFieldSaveName.textAlignment = NSTextAlignment.Center
        textFieldSaveName.textColor = UIColor.blackColor()
        textFieldSaveName.font = UIFont.italicSystemFontOfSize(5)
        textFieldSaveName.borderStyle = UITextBorderStyle.Line
        textFieldSaveName.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldSaveName.backgroundColor = UIColor.clearColor()
        textFieldSaveName.borderStyle = UITextBorderStyle.None
        textFieldSaveName.tag = 5
        textFieldSaveName.text = "Unsaved File"
        textFieldSaveName.hidden = true
        
        
        
        
        let buttonCreateNewFile:UIButton! = UIButton(type: .System)
        buttonCreateNewFile.frame = CGRectMake(2, 15, 70, 8)
        buttonCreateNewFile.layer.cornerRadius = 5
        buttonCreateNewFile.titleLabel?.font = UIFont.italicSystemFontOfSize(9)
        buttonCreateNewFile.backgroundColor = UIColor.clearColor()
        buttonCreateNewFile.setTitle("New", forState: UIControlState.Normal)
        buttonCreateNewFile.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonCreateNewFile.addTarget(self, action: "buttonCreateNewFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let buttonOpenFile:UIButton! = UIButton(type: .System)
        buttonOpenFile.frame = CGRectMake(2, 35, 70, 8)
        buttonOpenFile.layer.cornerRadius = 5
        buttonOpenFile.titleLabel?.font = UIFont.italicSystemFontOfSize(9)
        buttonOpenFile.backgroundColor = UIColor.clearColor()
        buttonOpenFile.setTitle("Open", forState: UIControlState.Normal)
        buttonOpenFile.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOpenFile.addTarget(self, action: "buttonOpenFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let buttonUpdate:UIButton! = UIButton(type: .System)
        buttonUpdate.frame = CGRectMake(2, 55, 70, 8.0)
        buttonUpdate.layer.cornerRadius = 8
        buttonUpdate.titleLabel?.font = UIFont.italicSystemFontOfSize(9)
        buttonUpdate.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonUpdate.backgroundColor = UIColor.clearColor()
        buttonUpdate.setTitle("Save", forState: UIControlState.Normal)
        buttonUpdate.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonUpdate.addTarget(self, action: "buttonUpdatePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let buttonSave:UIButton! = UIButton(type: .System)
        buttonSave.frame = CGRectMake(2, 75, 70, 8.0)
        buttonSave.layer.cornerRadius = 3
        buttonSave.titleLabel?.font = UIFont.italicSystemFontOfSize(9)
        buttonSave.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonSave.backgroundColor = UIColor.clearColor()
        buttonSave.setTitle("Save As", forState: UIControlState.Normal)
        buttonSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonSave.addTarget(self, action: "buttonSavePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        viewSave.addSubview(buttonOpenFile)
        viewSave.addSubview(textFieldSaveName)
        viewSave.addSubview(buttonSave)
        viewSave.addSubview(buttonUpdate)
        viewSave.addSubview(buttonCreateNewFile)
        viewSaveImage.addSubview(viewSave)
        view.addSubview(viewSaveImage)
    }
    
    //This search button
    func buttonViewFilePressed(sender: UIButton!){
        let sentView = sender.superview
        var newFile = ""
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                newFile = textField.text!
            }
        }
        makeTableAppear(newFile)
    }


    //This is view all button
    func buttonViewAllFilesPressed(sender: UIButton!){
        makeTableAppear("")
    }
    
    
    func buttonHideAllFilesPressed(sender: UIButton!){
        makeTableDisappear()
        
    }
    

    func makeTableAppear(search: String){
        allFilesTableView.frame = CGRectMake(0, 74, 211, 130)
        allFilesTableView.backgroundColor = UIColor.clearColor()
        //allFilesTableView.layer.cornerRadius = 6
        //let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        //allFilesTableView.addGestureRecognizer(gesture)
        allFilesTableView.userInteractionEnabled = true
        allFilesTableView.tag = 15
        allFilesTableView.scrollEnabled = true
        
        if(search.isEmpty){
            let retrievedFiles = try! Realm().objects(StickerFile)
            if(retrievedFiles.count == 0){
                createAlertView("View All Files", message: "There Were No Files To Retrieve")
            }
            else{
                for file in retrievedFiles{
                    retrievedFileNames.append(file.fileName)
                }
                
                allFilesTableView.delegate = self
                allFilesTableView.dataSource = self
                allFilesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
                self.view.addSubview(allFilesTableView)
                
                allFilesTableView.hidden = false
                for view in self.view.subviews{
                    if (view.tag == 217){
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
        }
    
        if(!search.isEmpty){
            let predicate = NSPredicate(format: "fileName contains %@", search)
            let retrievedFiles = try! Realm().objects(StickerFile).filter(predicate)
            if(retrievedFiles.count == 0){
                createAlertView("Search Files", message: "There Were No Files To Retrieve")
            }
            if(retrievedFiles.count != 0){
                for file in retrievedFiles{
                    retrievedFileNames.append(file.fileName)
            }
                
                allFilesTableView.delegate = self
                allFilesTableView.dataSource = self
                allFilesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
                self.view.addSubview(allFilesTableView)
                
                allFilesTableView.hidden = false
                for view in self.view.subviews{
                    if (view.tag == 217){
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
            
        }
        
    }


    func makeTableDisappear(){
        allFilesTableView.hidden = true
        for view in self.view.subviews{
            if (view.tag == 217){
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
    
    
    func makeHeaderButtons(){
        let viewImageProcess = UIImageView()
        viewImageProcess.frame = CGRectMake(0, 50, 70, 20.0)
        viewImageProcess.tag = 117
        viewImageProcess.image = UIImage(named: "Process.png")
        viewImageProcess.userInteractionEnabled = true
        
        
        let buttonProcess:UIButton! = UIButton(type: .System)
        buttonProcess.frame = CGRectMake(0, 0, 70, 20.0)
        buttonProcess.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonProcess.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonProcess.backgroundColor = UIColor.clearColor()
        buttonProcess.setTitle("Process", forState: UIControlState.Normal)
        buttonProcess.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonProcess.addTarget(self, action: "buttonProcessPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let viewImageFuture = UIImageView()
        viewImageFuture.frame = CGRectMake(70.5, 50, 70, 20.0)
        viewImageFuture.tag = 118
        viewImageFuture.image = UIImage(named: "Future.png")
        viewImageFuture.userInteractionEnabled = true
        
        
        let buttonFuture:UIButton! = UIButton(type: .System)
        buttonFuture.frame = CGRectMake(0, 0, 70, 20.0)
        buttonFuture.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFuture.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFuture.backgroundColor = UIColor.clearColor()
        buttonFuture.setTitle("Future", forState: UIControlState.Normal)
        buttonFuture.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFuture.addTarget(self, action: "buttonFuturePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let viewImageImprovements = UIImageView()
        viewImageImprovements.frame = CGRectMake(141, 50, 70, 20.0)
        viewImageImprovements.tag = 119
        viewImageImprovements.image = UIImage(named: "Improvements.png")
        viewImageImprovements.userInteractionEnabled = true
        
        
        let buttonImprovements:UIButton! = UIButton(type: .System)
        buttonImprovements.frame = CGRectMake(0, 0, 70, 20.0)
        buttonImprovements.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonImprovements.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonImprovements.backgroundColor = UIColor.clearColor()
        buttonImprovements.setTitle("Improvements", forState: UIControlState.Normal)
        buttonImprovements.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonImprovements.addTarget(self, action: "buttonImprovementsPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let textFieldSaveName = UITextField(frame: CGRectMake(2, 1.0, 70.0, 5.0))
        textFieldSaveName.textAlignment = NSTextAlignment.Center
        textFieldSaveName.textColor = UIColor.blackColor()
        textFieldSaveName.font = UIFont.italicSystemFontOfSize(5)
        textFieldSaveName.borderStyle = UITextBorderStyle.Line
        textFieldSaveName.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldSaveName.backgroundColor = UIColor.clearColor()
        textFieldSaveName.borderStyle = UITextBorderStyle.None
        textFieldSaveName.tag = 59
        textFieldSaveName.text = "Unsaved File"
        
        
        
        let textFieldTitleActivityHeader = UITextField(frame: CGRectMake(241.0, 70.0, 130.0, 20.0))
        textFieldTitleActivityHeader.textAlignment = NSTextAlignment.Center
        textFieldTitleActivityHeader.textColor = UIColor.blackColor()
        textFieldTitleActivityHeader.font = UIFont.italicSystemFontOfSize(8)
        textFieldTitleActivityHeader.borderStyle = UITextBorderStyle.Line
        textFieldTitleActivityHeader.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldTitleActivityHeader.backgroundColor = UIColor.clearColor()
        textFieldTitleActivityHeader.borderStyle = UITextBorderStyle.None
        textFieldTitleActivityHeader.tag = 57
        textFieldTitleActivityHeader.text = "Create Future State"
        textFieldTitleActivityHeader.center.x = self.view.center.x
        
        
        
        
        let buttonOptionsImage = UIImageView()
        buttonOptionsImage.frame = CGRectMake(660, 20, 30, 30)
        buttonOptionsImage.image = UIImage(named: "Options.png")
        buttonOptionsImage.userInteractionEnabled = true
        
        
        let buttonOptions:UIButton! = UIButton(type: .System)
        buttonOptions.frame = CGRectMake(660, 20, 30, 30)
        buttonOptions.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOptions.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOptions.backgroundColor = UIColor.clearColor()
        buttonOptions.setTitle("", forState: UIControlState.Normal)
        buttonOptions.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOptions.addTarget(self, action: "buttonOptionsPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let textFieldTitleHeader = UITextField(frame: CGRectMake(1.0, 30.0, 130.0, 20.0))
        textFieldTitleHeader.textAlignment = NSTextAlignment.Center
        textFieldTitleHeader.textColor = UIColor.blackColor()
        textFieldTitleHeader.font = UIFont.italicSystemFontOfSize(8)
        textFieldTitleHeader.borderStyle = UITextBorderStyle.Line
        textFieldTitleHeader.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldTitleHeader.backgroundColor = UIColor.clearColor()
        textFieldTitleHeader.borderStyle = UITextBorderStyle.None
        textFieldTitleHeader.tag = 59
        textFieldTitleHeader.text = "Unsaved File"
        textFieldTitleHeader.center.x = self.view.center.x
        
        
        
        viewImageProcess.addSubview(buttonProcess)
        view.addSubview(viewImageProcess)
        viewImageFuture.addSubview(buttonFuture)
        view.addSubview(viewImageFuture)
        viewImageImprovements.addSubview(buttonImprovements)
        view.addSubview(viewImageImprovements)
        view.addSubview(buttonOptionsImage)
        view.addSubview(buttonOptions)
        view.addSubview(textFieldTitleActivityHeader)
        view.addSubview(textFieldSaveName)
        self.view.addSubview(textFieldTitleHeader)
    }
    
    
    
    func makeViewAllFilesButton(){
        
        let viewImageProcess = UIImageView()
        viewImageProcess.frame = CGRectMake(469.5, 45, 120, 30.0)
        viewImageProcess.tag = 217
        viewImageProcess.image = UIImage(named: "Process.png")
        viewImageProcess.userInteractionEnabled = true
        
        
        
        let viewAllFiles = UIView()
        viewAllFiles.frame = CGRectMake(0, 0, 120, 20)
        viewAllFiles.backgroundColor = UIColor.clearColor()
        viewAllFiles.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        viewAllFiles.addGestureRecognizer(gesture)
        viewAllFiles.userInteractionEnabled = true
        viewAllFiles.tag = 5
        
        
        let textFieldSaveName = UITextField(frame: CGRectMake(1.0, 1.0, 120.0, 20.0))
        textFieldSaveName.textAlignment = NSTextAlignment.Center
        textFieldSaveName.textColor = UIColor.blackColor()
        textFieldSaveName.font = UIFont.italicSystemFontOfSize(8)
        textFieldSaveName.borderStyle = UITextBorderStyle.Line
        textFieldSaveName.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldSaveName.backgroundColor = UIColor.clearColor()
        textFieldSaveName.borderStyle = UITextBorderStyle.None
        textFieldSaveName.tag = 5
        textFieldSaveName.text = "Type File Name"
        
        
        
        let buttonSave:UIButton! = UIButton(type: .System)
        buttonSave.frame = CGRectMake(0, 17, 30, 12.0)
        //buttonSave.layer.cornerRadius = 3
        buttonSave.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonSave.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonSave.backgroundColor = UIColor.clearColor()
        buttonSave.setTitle("Search", forState: UIControlState.Normal)
        buttonSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonSave.addTarget(self, action: "buttonViewFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonViewAll:UIButton! = UIButton(type: .System)
        buttonViewAll.frame = CGRectMake(84.5, 17, 35, 12.0)
        //buttonViewAll.layer.cornerRadius = 3
        buttonViewAll.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonViewAll.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonViewAll.backgroundColor = UIColor.clearColor()
        buttonViewAll.setTitle("View All", forState: UIControlState.Normal)
        buttonViewAll.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonViewAll.addTarget(self, action: "buttonViewAllFilesPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonViewAll.hidden = false
        buttonViewAll.tag = 10
        
        
        
        let buttonHideAll:UIButton! = UIButton(type: .System)
        buttonHideAll.frame = CGRectMake(84.5, 17, 35, 12.0)
        buttonHideAll.layer.cornerRadius = 3
        buttonHideAll.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonHideAll.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonHideAll.backgroundColor = UIColor.clearColor()
        buttonHideAll.setTitle("Hide All", forState: UIControlState.Normal)
        buttonHideAll.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonHideAll.addTarget(self, action: "buttonHideAllFilesPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonHideAll.hidden = true
        buttonHideAll.tag = 9
        
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(40, 17, 30, 12.0)
        //buttonDelete.layer.cornerRadius = 3
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.backgroundColor = UIColor.clearColor()
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeleteSavedFilePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonDelete.hidden = true
        
        
        viewImageProcess.addSubview(textFieldSaveName)
        viewImageProcess.addSubview(buttonDelete)
        viewImageProcess.addSubview(buttonSave)
        viewImageProcess.addSubview(buttonViewAll)
        viewImageProcess.addSubview(buttonHideAll)
        self.view.addSubview(viewImageProcess)
        
        
    }
    
    
    //These parameters may not be used
    func makeSticker(stickerLabel: String, stickerNumber: Int, stickerColor: String){
        
        let viewImage = UIImageView()
        viewImage.frame = CGRectMake(-20, -31, 215, 242)
        viewImage.tag = 17
        
        
        let view = UIView()
        view.frame = CGRectMake(30, 50, 250, 250)
        view.backgroundColor = UIColor.greenColor()
        view.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged2:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        view.tag = 1
        view.hidden = false
        
        
        switch(stickerColor){
        case "orange":
            view.backgroundColor = UIColor.orangeColor()
            viewImage.image = UIImage(named: "Sticker_orange.png")
        case "red":
            view.backgroundColor = UIColor.redColor()
            viewImage.image = UIImage(named: "Sticker_red.png")
        case "green":
            view.backgroundColor = UIColor.greenColor()
            viewImage.image = UIImage(named: "Sticker_green.png")
        default:
            view.backgroundColor = UIColor.greenColor()
            viewImage.image = UIImage(named: "Sticker_green.png")
        }
        
        
        let viewControl = UIView()
        viewControl.frame = CGRectMake(2, 2, 165, 120)
        viewControl.backgroundColor = UIColor.clearColor()
        viewControl.layer.cornerRadius = 6
        viewControl.userInteractionEnabled = true
        viewControl.tag = 19
        viewControl.hidden = true
        
        
        let textTitle = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textTitle.textAlignment = NSTextAlignment.Center
        textTitle.font = UIFont.italicSystemFontOfSize(8)
        textTitle.textColor = UIColor.blackColor()
        textTitle.tag = 2
        textTitle.hidden = true
        
        let textTitleStatus = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textTitleStatus.textAlignment = NSTextAlignment.Center
        textTitleStatus.font = UIFont.italicSystemFontOfSize(8)
        textTitleStatus.textColor = UIColor.blackColor()
        textTitleStatus.tag = 20
        textTitleStatus.hidden = true
        textTitleStatus.text = "current"
        
        
        let textViewId = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textViewId.textAlignment = NSTextAlignment.Center
        textViewId.font = UIFont.italicSystemFontOfSize(8)
        textViewId.textColor = UIColor.blackColor()
        textViewId.tag = 9
        textViewId.hidden = true
        
        
        let textCurrentColor = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textCurrentColor.textAlignment = NSTextAlignment.Center
        textCurrentColor.font = UIFont.italicSystemFontOfSize(8)
        textCurrentColor.textColor = UIColor.blackColor()
        textCurrentColor.tag = 7
        textCurrentColor.hidden = true
        textCurrentColor.text = "green"
        
        
        
        let textCurrentName = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 16.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = "Name this Sticker "+String(stickerNumber)
        textCurrentName.addTarget(self, action: "nameChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        let textCurrentFile = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 16.0))
        textCurrentFile.textAlignment = NSTextAlignment.Center
        textCurrentFile.font = UIFont.italicSystemFontOfSize(8)
        textCurrentFile.textColor = UIColor.blackColor()
        textCurrentFile.tag = 81
        textCurrentFile.text = ""
        textCurrentFile.hidden = true
        
        
        
        let textField = UITextView(frame: CGRectMake(0.0, 19.0, 165.0, 93.0))
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
        buttonDelete.hidden = true
        
        
        //This is the image of the real icon
        let buttonFlipImage = UIImageView()
        buttonFlipImage.frame = CGRectMake(0, 0, 20, 8)
        buttonFlipImage.tag = 113
        buttonFlipImage.image = UIImage(named: "Info.png")
        buttonFlipImage.userInteractionEnabled = true
        
        
        
        let buttonFlip:UIButton! = UIButton(type: .System)
        buttonFlip.frame = CGRectMake(130, 100, 20, 8.0)
        buttonFlip.layer.cornerRadius = 3
        buttonFlip.backgroundColor = UIColor.brownColor()
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: "buttonFlipPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonFlipBack:UIButton! = UIButton(type: .System)
        buttonFlipBack.frame = CGRectMake(128, 98, 20, 8.0)
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
        view.addSubview(textCurrentFile)
        viewControl.addSubview(buttonGreenColor)
        viewControl.addSubview(buttonRedColor)
        viewControl.addSubview(buttonDelete)
        view.addSubview(buttonFlip)
        view.addSubview(textViewId)
        view.addSubview(viewControl)
        viewControl.addSubview(buttonFlipBack)
        
        stickerDictionary.append(view)
        view.addSubview(textTitle)
        view.addSubview(viewImage)
        view.sendSubviewToBack(viewImage)
        view.heightAnchor.constraintEqualToConstant(170.6).active = true
        view.widthAnchor.constraintEqualToConstant(170.6).active = true
        
        
    }
    
    
    func makeStickerFromFile(sticker: Sticker){
        //Declared First because we need to switch the background color
        let textCurrentColor = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textCurrentColor.textAlignment = NSTextAlignment.Center
        textCurrentColor.font = UIFont.italicSystemFontOfSize(8)
        textCurrentColor.textColor = UIColor.blackColor()
        textCurrentColor.tag = 7
        textCurrentColor.hidden = true
        
        
        let viewImage = UIImageView()
        viewImage.frame = CGRectMake(-20, -31, 215, 242)
        viewImage.tag = 17
        
        
        let view = UIView()
        view.frame = CGRectMake(CGFloat(sticker.xPosition), CGFloat(sticker.yPosition), CGFloat(sticker.width), CGFloat(sticker.height))
        switch(sticker.backgroundColor){
        case "orange":
            view.backgroundColor = UIColor.orangeColor()
            viewImage.image = UIImage(named: "Sticker_orange.png")
            textCurrentColor.text = "orange"
        case "red":
            view.backgroundColor = UIColor.redColor()
            viewImage.image = UIImage(named: "Sticker_red.png")
            textCurrentColor.text = "red"
        case "green":
            view.backgroundColor = UIColor.greenColor()
            viewImage.image = UIImage(named: "Sticker_green.png")
            textCurrentColor.text = "green"
        default:
            view.backgroundColor = UIColor.greenColor()
            viewImage.image = UIImage(named: "Sticker_green.png")
            textCurrentColor.text = "green"
        }
        view.layer.cornerRadius = 6
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged2:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        view.tag = 6
        
        
        let viewControl = UIView()
        viewControl.frame = CGRectMake(2, 2, 165, 120)
        viewControl.backgroundColor = UIColor.clearColor()
        viewControl.layer.cornerRadius = 6
        viewControl.userInteractionEnabled = true
        viewControl.tag = 19
        viewControl.hidden = true
        
        
        let textTitle = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textTitle.textAlignment = NSTextAlignment.Center
        textTitle.font = UIFont.italicSystemFontOfSize(8)
        textTitle.textColor = UIColor.blackColor()
        textTitle.tag = 2
        textTitle.text = sticker.stickerId
        textTitle.hidden = true
        
        
        let textZoomStatus = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textZoomStatus.textAlignment = NSTextAlignment.Center
        textZoomStatus.font = UIFont.italicSystemFontOfSize(8)
        textZoomStatus.textColor = UIColor.blackColor()
        textZoomStatus.tag = 24
        textZoomStatus.text = "false"
        textZoomStatus.hidden = true
        
        
        let textTitleStatus = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textTitleStatus.textAlignment = NSTextAlignment.Center
        textTitleStatus.font = UIFont.italicSystemFontOfSize(8)
        textTitleStatus.textColor = UIColor.blackColor()
        textTitleStatus.tag = 20
        textTitleStatus.hidden = true
        textTitleStatus.text = sticker.stickerStatus
        
        
        let textViewId = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 8.0))
        textViewId.textAlignment = NSTextAlignment.Center
        textViewId.font = UIFont.italicSystemFontOfSize(8)
        textViewId.textColor = UIColor.blackColor()
        textViewId.tag = 9
        textViewId.hidden = true
        
        
        
        let textCurrentName = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 16.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = sticker.stickerName
        textCurrentName.addTarget(self, action: "nameChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        let textCurrentFile = UITextField(frame: CGRectMake(2.0, 1.0, 165.0, 16.0))
        textCurrentFile.textAlignment = NSTextAlignment.Center
        textCurrentFile.font = UIFont.italicSystemFontOfSize(8)
        textCurrentFile.textColor = UIColor.blackColor()
        textCurrentFile.tag = 81
        textCurrentFile.text = sticker.fileName?.fileName
        textCurrentFile.hidden = true
        
        
        
        let textField = UITextView(frame: CGRectMake(0.0, 19.0, 165.0, 93.0))
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
        buttonDelete.hidden = true
        
        
        
        let buttonFlip:UIButton! = UIButton(type: .System)
        buttonFlip.frame = CGRectMake(130, 100, 20, 8.0)
        buttonFlip.layer.cornerRadius = 3
        buttonFlip.backgroundColor = UIColor.brownColor()
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: "buttonFlipPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonFlipBack:UIButton! = UIButton(type: .System)
        buttonFlipBack.frame = CGRectMake(138, 98, 20, 8.0)
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
        view.addSubview(textCurrentFile)
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
        view.addSubview(viewImage)
        view.sendSubviewToBack(viewImage)
        
        view.heightAnchor.constraintEqualToConstant(170.6).active = true
        view.widthAnchor.constraintEqualToConstant(170.6).active = true
        
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
    
    
    
    func iconTapped(gesture: UITapGestureRecognizer){
        //First get each icon to its normal size
        for view in stickerDictionaryIcon{
            view.transform = CGAffineTransformMakeScale(1, 1)
        }
        //Remove icons from view
        for view in timeLineViewIcon.arrangedSubviews{
            view.removeFromSuperview()
        }
        
        //Add Stickers icons to timeline
        for (index,sticker) in stickerDictionaryIcon.enumerate(){
            timeLineViewIcon.insertArrangedSubview(sticker, atIndex: index)
        }

        //Transform the tapped icon to zoomed scale
        gesture.view!.superview!.transform = CGAffineTransformMakeScale(1.4, 1.4)
        
        //Set all the sickers to normal size
        for view in stickerDictionary{
                    view.transform = CGAffineTransformMakeScale(1, 1)
        }
        //Calculate offset to get sticker to be zoomed
        let lengthOriginToTap = Float((gesture.view?.superview!.tag)!)*242.6
        scrollView.setContentOffset(CGPoint(x: CGFloat(lengthOriginToTap-296.6), y: CGFloat(0)), animated: false)
        
         //Zoom the correct sticker
        for view in stickerDictionary{
            if (view.tag == gesture.view?.superview!.tag){
                view.transform = CGAffineTransformMakeScale(1.6, 1.6)
            }
        }
        
        trashViewOffset = CGFloat(lengthOriginToTap-Float(245))
        drawTrash()
        drawArchive()
        trashView.hidden = false
        archiveView.hidden = false
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
            print(gesturedView.convertPoint(gesturedView.frame.origin, fromView: self.view))
            
        }
       
        if(gesture.state == UIGestureRecognizerState.Ended){
            let gesturedViews = gesture.view
            for view in timeLineView.arrangedSubviews{
                if(gesture.view!.frame.intersects(view.frame)){
                    let gesturedView = gesture.view
                    let destinationView = view
                    var gesturedViewId = -1
                    var destinationViewId = -1
                    
                    
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
                            
                            if (textField.tag == 8){
                                textField.text = "Sticker Number "+String(index+1)
                            }
                            
                        }
                        timeLineView.insertArrangedSubview(sticker, atIndex: index)
                    }
                    
                    refreshStickers()
                    
                    createIcons()
                }
                
            }
            
            if((gesturedViews?.frame.intersects(trashView.frame)) != nil){
                if(gesturedViews?.tag==19){
                    deleteSticker((gesturedViews?.superview)!)
                }
                else{
                    deleteSticker(gesturedViews!)
                }
                trashView.removeFromSuperview()
                archiveView.removeFromSuperview()
                createIcons()
            }
            
            
            if((gesturedViews?.frame.intersects(archiveView.frame)) != nil){
                for view in stickerDictionary{
                    if(gesturedViews?.tag == view.tag){
                        for case let textField as UITextField in view.subviews{
                            if(textField.tag == 20){
                                textField.text = "archived"
                            }
                        }
                        stickerDictionaryArchive.append(view)
                    }
                }
                if(gesturedViews?.tag==19){
                    deleteSticker((gesturedViews?.superview)!)
                }
                else{
                    deleteSticker(gesturedViews!)
                }
                trashView.removeFromSuperview()
                archiveView.removeFromSuperview()
                createIcons()
            }

            
    }
        
}
    
    func nameChanged(textField: UITextField){
        for view in timeLineViewIcon.arrangedSubviews{
            view.transform = CGAffineTransformMakeScale(1, 1)
        }
        for view in timeLineView.arrangedSubviews{
            view.transform = CGAffineTransformMakeScale(1, 1)
        }
        let lengthFromZero = Double((textField.superview?.tag)!)*242.6
        let offset = lengthFromZero - 242.6
        trashViewOffset = CGFloat(offset)
        drawTrash()
        drawArchive()
        trashView.hidden = false
        archiveView.hidden = false
        
        textField.superview?.transform = CGAffineTransformMakeScale(1.6, 1.6)
        for view in timeLineViewIcon.arrangedSubviews{
            if (view.tag == textField.superview?.tag){
                for views in view.subviews{
                    if(views.tag == 5){//Top Icon
                        for case let textFields as UITextView in views.subviews{
                            if(textFields.tag == 8){
                                textFields.text = textField.text!
                            }
                        }
                    }
                    if(views.tag == 6){//Bottom Icon
                        for case let textFields as UITextView in views.subviews{
                            if(textFields.tag == 9){
                                textFields.text = textField.text!
                            }
                        }
                    }
                }
            }
        }
        
    }

}