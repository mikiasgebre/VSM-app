//
//  ViewController.swift
//  d
//
//  Created by Kawalya Davis on 09/01/16.
//  Copyright © 2016 Kawalya Davis. All rights reserved.
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



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    var stickerDictionary = [UIView]()
    var stickerDictionaryIcon = [UIView]()
    var stickerDictionaryTrash = [UIView]()
    var stickerDictionaryArchive = [UIView]()
    var stickerDictionaryPdfPages = [UIWebView]()
    var stickerDictionaryTemp = [UIView]()
    let allFilesTableView = UITableView()
    var retrievedFileNames = [String]()
    var scrollView:UIScrollView!
    var scrollViewIcon:UIScrollView!
    var scrollViewPdf:UIScrollView!
    var containerTable:UIView!
    let trashView = UIView()
    var trashViewOffset = CGFloat(70.0)
    let archiveView = UIView()
    let buttonCreateSticker:UIButton! = UIButton(type: .System)
    var screen:CGFloat = 0
    var initial:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen = UIScreen.mainScreen().bounds.width
        createScrollAndContainerView() //Contains some code for scroll view and stackview
        makeSaveButton()
        makeViewAllFilesButton()
        makeButtonFileAsPdf()
        makeHeaders()
        makeHeaderButtons()
        makeButtonCreateSticker()
        makeButtonRefreshStickers()
        if(!initial){
            createInitialScreen()
        }
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //For initializing the scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRectMake(0,0,767.8-0.2, 1000)
        scrollView.contentSize = CGSizeMake(CGFloat(stickerDictionary.count*243), 1000)
        scrollView.scrollEnabled = true
        scrollView.contentInset = UIEdgeInsetsMake(0, 370.6, 0, 226.6)
        scrollView.userInteractionEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        scrollView.tag = 220
        scrollView.center = self.view.center
        
        
        scrollViewIcon.frame = CGRectMake(0,650,767.8-0.2, 95)
        scrollViewIcon.contentSize = CGSizeMake(CGFloat(stickerDictionary.count*75), 95)
        scrollViewIcon.scrollEnabled = true
        scrollViewIcon.contentInset = UIEdgeInsetsMake(0, 60, 0, 10)
        scrollViewIcon.userInteractionEnabled = true
        scrollViewIcon.alwaysBounceHorizontal = true
        scrollViewIcon.tag = 221
        scrollViewIcon.center.x = self.view.center.x
        
        
        scrollViewPdf.frame = CGRectMake(100,250,767.8-0.2, 650)
        scrollViewPdf.contentSize = CGSizeMake(CGFloat(Double(stickerDictionaryPdfPages.count)*767.8), 650)
        scrollViewPdf.scrollEnabled = true
        scrollViewPdf.contentInset = UIEdgeInsetsMake(0, 88.9, 0, 88.9)
        scrollViewPdf.userInteractionEnabled = true
        scrollViewPdf.alwaysBounceHorizontal = true
        scrollViewPdf.delegate = self
        scrollViewPdf.tag = 222
        scrollViewPdf.center = self.view.center
        scrollViewPdf.backgroundColor = UIColor.lightGrayColor()
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if(UIDevice.currentDevice().orientation.isLandscape.boolValue){
            screen = 1024
            print("Screen Landscape "+String(screen))
            self.view.setNeedsDisplay()
            for view in self.view.subviews{//File menu
                if(view.tag == 116){
                    view.removeFromSuperview()
                    makeSaveButton()
                }
            }
            for view in self.view.subviews{//options
                if(view.tag == 1191){
                    view.removeFromSuperview()
                }
                if(view.tag == 59){
                    view.removeFromSuperview()
                }
                if(view.tag == 57){
                    view.removeFromSuperview()
                    makeHeaders()
                }
            }
            for view in self.view.subviews{//Search menu
                if(view.tag == 217){
                    view.removeFromSuperview()
                    makeViewAllFilesButton()
                }
            }
            for view in self.view.subviews{//Pdf//
                if(view.tag == 422){
                    view.removeFromSuperview()
                    makeButtonFileAsPdf()
                }
            }
            for view in self.view.subviews{//Refresh
                if(view.tag == 29){
                    view.removeFromSuperview()
                    makeButtonRefreshStickers()
                }
            }
        }else if(UIDevice.currentDevice().orientation.isPortrait.boolValue){
            screen = 768
            print("Screen Portrait "+String(screen))
            self.view.setNeedsDisplay()
            for view in self.view.subviews{//File menu
                if(view.tag == 116){
                    view.removeFromSuperview()
                    makeSaveButton()
                }
            }
            for view in self.view.subviews{//options
                if(view.tag == 1191){
                    view.removeFromSuperview()
                }
                if(view.tag == 59){
                    view.removeFromSuperview()
                }
                if(view.tag == 57){
                    view.removeFromSuperview()
                    makeHeaders()
                }
            }
            for view in self.view.subviews{//Search menu
                if(view.tag == 217){
                    view.removeFromSuperview()
                    makeViewAllFilesButton()
                }
            }
            for view in self.view.subviews{//Pdf//
                if(view.tag == 422){
                    view.removeFromSuperview()
                    makeButtonFileAsPdf()
                }
            }
            for view in self.view.subviews{//Refresh
                if(view.tag == 29){
                    view.removeFromSuperview()
                    makeButtonRefreshStickers()
                }
            }
        }
    }
    
    
    
    //The table shows you a list of files that are currently saved
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int)->Int{
        return self.retrievedFileNames.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell{
        let cell:UITableViewCell = allFilesTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.retrievedFileNames[indexPath.row]
        cell.accessoryType = .DetailButton
        cell.accessoryView?.backgroundColor = UIColor.grayColor()
        let acesssoryImage = UIImageView()
        acesssoryImage.frame = CGRectMake(0, 0, 50, 50)
        acesssoryImage.image = UIImage(named: "Info.png")
        acesssoryImage.userInteractionEnabled = true
        //cell.accessoryView?.addSubview(acesssoryImage)
        //cell.accessoryView?.bringSubviewToFront(acesssoryImage)
        
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
            //Check if process is active
            for view in self.view.subviews{
                if(view.tag==570){//Process background
                    if(view.hidden == false){//Process background
                        
                        for view in self.stickerDictionary{
                            view.removeFromSuperview()
                        }
                        stickerDictionary.removeAll()
                        stickerDictionaryArchive.removeAll()
                        stickerDictionaryTemp.removeAll()
                        
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
                            if(sticker.frame.width>171){
                                sticker.transform = CGAffineTransformMakeScale(1, 1)
                            }
                            sticker.frame.origin.x = CGFloat(Double(index)*242.6)
                            sticker.frame.origin.y = CGFloat(300)
                            scrollView.addSubview(sticker)
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
                        //trashViewOffset = scrollView.contentOffset+72
                        drawTrash()
                        trashView.hidden = false
                        
                        createIcons(stickerDictionary)
                    }
                }
            }
        }//End Retrieved File names if
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.backgroundColor = UIColor.clearColor()
        cell.indentationLevel = 2
        
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //let pathToIndex = tableView.indexPathForSelectedRow
        makeTableDisappear()
        let tappedCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let newFile = tappedCell.textLabel?.text
        deleteSavedFile(newFile!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonCreateSticker(){
        buttonCreateSticker.frame = CGRectMake(60, 25, 70, 15)
        buttonCreateSticker.layer.cornerRadius = 5
        buttonCreateSticker.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonCreateSticker.titleLabel?.numberOfLines = 0
        buttonCreateSticker.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonCreateSticker.backgroundColor = UIColor.clearColor()
        buttonCreateSticker.setTitle("Add Sticker", forState: UIControlState.Normal)
        buttonCreateSticker.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonCreateSticker.addTarget(self, action: "buttonCreateStickerPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonCreateSticker)
        buttonCreateSticker.userInteractionEnabled = true
        buttonCreateSticker.tag = 20
        
    }
    
    
    
    
    //Button action method
    func buttonCreateStickerPressed(sender: UIButton!){
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        createSticker("orange")
        
        //This hides the other backgrounds
        for view in self.view.subviews{
            if(view.tag==571){//Improvements background
                view.hidden = true
            }
            if(view.tag==572){//Editor or future
                view.hidden = true
            }
            if(view.tag==570){//Process background
                view.hidden = false
            }
        }
    }
    
    func createInitialScreen(){
        createSticker("orange")
        //This is header title
        for case let textField as UITextField in self.view.subviews{
            if (textField.tag == 57){
                textField.text = "Map your process"
            }
        }
        initial = true
    }
    
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
                
                //This the view id
                if (textField.tag == 9){
                    textField.text = String(index+1)
                }
                
            }
        }
        for view in stickerDictionary{
            view.removeFromSuperview()
        }
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionary.enumerate(){
            if(sticker.frame.width>171){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*242.6)
            sticker.frame.origin.y = CGFloat(300)
            scrollView.addSubview(sticker)
        }
        
        createIcons(stickerDictionary)
        scrollView.setContentOffset(CGPoint(x: CGFloat(stickerDictionary.count)*242.6, y: 0), animated: false)
        scrollViewIcon.setContentOffset(CGPoint(x: stickerDictionaryIcon.count*548, y: 0), animated: false)
        
        if(stickerDictionary.count>1){
            stickerDictionary[stickerDictionary.count-2].transform = CGAffineTransformMakeScale(1.6, 1.6)
        }
        
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        if(stickerDictionary.count<3){
            trashViewOffset = -245
            drawTrash()
            trashView.hidden = false
        }else{
            trashViewOffset = CGFloat(Double(stickerDictionary.count-2)*242.6)+(-250)
            drawTrash()
            trashView.hidden = false
        }
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(scrollView.tag==220){
            var zoomedView = UIView()
            for view in stickerDictionary{
                if(view.frame.width>171){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                    zoomedView = view
                }
            }
            for view in stickerDictionaryIcon{
                if (view.tag == zoomedView.tag){
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
            
            trashView.removeFromSuperview()
            archiveView.removeFromSuperview()
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        if(scrollView.tag==220){
            let offset = scrollView.contentOffset.x
            let sections = ceil(offset/242.6) //Each sticker has this width, the offset is from origin of scrollview to end of timeline backwards
            let fullOffset = (sections*242.6)-54
            
            var itemNumber = Int(sections)
            print("Offset "+String(itemNumber))
            
            if(scrollView.contentOffset.x == -274.0){
                let item = 0
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: false)
                for views in stickerDictionary{
                    if(views.tag == item){
                        views.transform = CGAffineTransformMakeScale(1.6, 1.6)
                    }
                }
                
                for view in stickerDictionaryIcon{
                    if (view.tag == item){
                        view.transform = CGAffineTransformMakeScale(1.4, 1.4)
                    }
                }
                
                
            }else{
                scrollView.setContentOffset(CGPoint(x: fullOffset, y: 0), animated: false)
                if(itemNumber>=stickerDictionary.count){
                    itemNumber = stickerDictionary.count-2
                }
                for view in stickerDictionary{
                    if(view.tag == itemNumber+1){
                        view.transform = CGAffineTransformMakeScale(1.6, 1.6)
                    }
                }
                
                
                for view in stickerDictionaryIcon{//Before we zoom anything, make sure all are reset
                    view.transform = CGAffineTransformMakeScale(1, 1)
                }
                
                
                for view in stickerDictionaryIcon{
                    if (view.tag == itemNumber+1){
                        view.transform = CGAffineTransformMakeScale(1.4, 1.4)
                    }
                }
            }
            
            //This selects whether trash or archive be displayed depending on the interface
            for view in self.view.subviews{
                if(view.tag==572){//Editor or future
                    if(view.hidden == false){
                        trashViewOffset = fullOffset+72
                        drawArchive()
                        archiveView.hidden = false
                    }
                }
                if(view.tag==570){//Process background
                    if(view.hidden == false){
                        trashViewOffset = fullOffset+72
                        drawTrash()
                        trashView.hidden = false
                    }
                }
            }
        }
    }
    
    
    //Button that creates the post it sticker pieces
    func makeButtonRefreshStickers(){
        let buttonRefreshStickers:UIButton! = UIButton(type: .System)
        buttonRefreshStickers.frame = CGRectMake(screen-67.8, 70, 30, 30)
        buttonRefreshStickers.layer.cornerRadius = 15
        buttonRefreshStickers.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonRefreshStickers.titleLabel?.numberOfLines = 0
        buttonRefreshStickers.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonRefreshStickers.backgroundColor = UIColor.brownColor()
        buttonRefreshStickers.setTitle("R", forState: UIControlState.Normal)
        buttonRefreshStickers.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRefreshStickers.addTarget(self, action: "buttonRefreshStickersPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonRefreshStickers)
        buttonRefreshStickers.userInteractionEnabled = true
        buttonRefreshStickers.tag = 29
    }
    
    
    func buttonRefreshStickersPressed(sender: UIButton!){
        refreshPage()
    }
    
    func refreshPage() -> (){
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        self.viewDidLoad()
        self.viewWillAppear(true)
        //Add Stickers to timeline
        processPressed()
    }
    
    
    
    //Button that creates the post it sticker pieces
    func makeButtonFileAsPdf(){
        let buttonPdfImage = UIImageView()
        buttonPdfImage.frame = CGRectMake(screen-67.8, 20, 30, 30)
        buttonPdfImage.image = UIImage(named: "Save.png")
        buttonPdfImage.userInteractionEnabled = true
        buttonPdfImage.tag = 422
        
        
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
        buttonFileAsPdf.userInteractionEnabled = true
        buttonFileAsPdf.tag = 42
        
    }
    
    //Button action method
    func buttonFileAsPdfPressed(sender: UIButton!){
        if(stickerDictionary.count == 0){
            return
        }
        makeTableDisappear()
        for view in stickerDictionaryPdfPages{
            view.removeFromSuperview()
        }
        stickerDictionaryPdfPages.removeAll()
        //This is file menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 116){
                view.hidden = true
            }
        }
        //This is search menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 217){
                view.hidden = true
            }
        }
        
        var numberPages:Int
        var pageNumber = 0
        if(stickerDictionary.count%9==0){
            numberPages = stickerDictionary.count/1
        }else{
            numberPages = stickerDictionary.count/9+1
        }
        for(var page=0; page<numberPages; page++){
            pageNumber++
            fileAsPdf(page*9, pageNumber: pageNumber )
        }
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionaryPdfPages.enumerate(){
            sticker.frame.origin.x = CGFloat(Double(index)*700)
            scrollViewPdf.addSubview(sticker)
        }
        scrollViewPdf.hidden = false
        print("Pdf Count "+String(stickerDictionaryPdfPages.count))
        print("Pdf Count "+String(numberPages))
        
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
        
        
        buttonFileAsPdf.userInteractionEnabled = true
        buttonFileAsPdf.tag = 45
        
    }
    
    
    
    //Button action method
    func buttonFileAsPdfRemovePressed(sender: UIButton!){
        makeTableDisappear()
        for case let webView as UIWebView in sender.superview!.subviews{
            if (webView.tag == 72){
                webView.removeFromSuperview()
            }
            
        }
        sender.superview?.superview!.hidden = true//hide scrollview container
    }
    
    
    //Button action method
    func buttonFileAsPdfSendPressed(sender: UIButton!){
        makeTableDisappear()
        let mailVc = createMailViewController()
        if MFMailComposeViewController.canSendMail(){
            presentViewController(mailVc, animated:true, completion:nil)
        }
            
        else{
            createAlertView("Sending Email", message: "Device could not send Pdf As Attachment")
        }
    }
    
    func createMailViewController()-> MFMailComposeViewController{
        let pdfMail = MFMailComposeViewController()
        pdfMail.mailComposeDelegate = self
        pdfMail.setToRecipients(["kawalyadavis@yahoo.co.uk"])
        pdfMail.setMessageBody("Pdf Process", isHTML: true)
        for view in stickerDictionaryPdfPages{
            let pdfStickers = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfStickers, view.bounds, nil)
            let pdfContext = UIGraphicsGetCurrentContext()
            UIGraphicsBeginPDFPage()
            view.layer.renderInContext(pdfContext!)
            UIGraphicsEndPDFContext()
            
            var count = 0
            let docDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let fileName = "pdfFile"+String(count)+String(NSDate())
            let filePath = docDirectory.stringByAppendingString(fileName)
            pdfStickers.writeToFile(filePath, atomically: true)
            count+=1
            pdfMail.addAttachmentData(pdfStickers, mimeType: "application/pdf", fileName: fileName)
        }
        return pdfMail
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //Button action method
    func fileAsPdf(start: Int, pageNumber: Int){
        //This contains the pdf page
        let webViewContainer = UIWebView()
        webViewContainer.frame = CGRectMake(3, 30, 580, 602)
        
        //This contains the stickers and is what is converted into the pdf
        let webView = UIWebView()
        webView.frame = CGRectMake(0, 17, 580, 600)
        webView.tag = 72
        
        //This is the title for the pdf
        let textFieldSaveName = UITextView(frame: CGRectMake(2, 2.0, 200.0, 40.0))
        textFieldSaveName.textAlignment = NSTextAlignment.Center
        textFieldSaveName.textColor = UIColor.blackColor()
        textFieldSaveName.font = UIFont.italicSystemFontOfSize(9)
        textFieldSaveName.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldSaveName.backgroundColor = UIColor.clearColor()
        textFieldSaveName.tag = 59
        //This is header file name
        for case let textField as UITextField in self.view.subviews{
            if (textField.tag == 59){
                textFieldSaveName.text = textField.text!+"\r\r\n"+" Page "+String(pageNumber)
            }
        }
        textFieldSaveName.center.x = webView.center.x
        webView.addSubview(textFieldSaveName)
        
        var stickersAdded = 0
        let numberRowsPerPage = 3
        var startIndex = start
        var counter = 0
        for (var row = 0; row < numberRowsPerPage; row++){
            for (var index = startIndex; index < stickerDictionary.count; index++){
                UIGraphicsBeginImageContextWithOptions(CGRectMake(0, 0, 170.6, 170.6).size, false, 0)
                stickerDictionary[index].drawViewHierarchyInRect(CGRectMake(0, 0, 170.6, 170.6), afterScreenUpdates: true)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let imageView = UIImageView(image: image)
                imageView.frame = CGRectMake(CGFloat(counter*186+20), CGFloat(row*186+50), 170.6, 170.6)
                webView.addSubview(imageView)
                counter++
                stickersAdded++
                if(counter > 2){
                    break
                }
            }
            startIndex+=3
            counter = 0
            if(stickersAdded > 10){
                break
            }
        }
        
        
        let buttonRemovePdf:UIButton! = UIButton(type: .System)
        buttonRemovePdf.frame = CGRectMake(200, 1, 50, 15)
        buttonRemovePdf.layer.cornerRadius = 5
        buttonRemovePdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonRemovePdf.titleLabel?.numberOfLines = 0
        buttonRemovePdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonRemovePdf.backgroundColor = UIColor.lightGrayColor()
        buttonRemovePdf.setTitle("Back", forState: UIControlState.Normal)
        buttonRemovePdf.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonRemovePdf.addTarget(self, action: "buttonFileAsPdfRemovePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonRemovePdf.userInteractionEnabled = true
        buttonRemovePdf.tag = 45
        
        
        
        
        let buttonSavePdf:UIButton! = UIButton(type: .System)
        buttonSavePdf.frame = CGRectMake(340, 1, 50, 15)
        buttonSavePdf.layer.cornerRadius = 5
        buttonSavePdf.titleLabel?.font = UIFont.italicSystemFontOfSize(10)
        buttonSavePdf.titleLabel?.numberOfLines = 0
        buttonSavePdf.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        buttonSavePdf.backgroundColor = UIColor.lightGrayColor()
        buttonSavePdf.setTitle("Send", forState: UIControlState.Normal)
        buttonSavePdf.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonSavePdf.addTarget(self, action: "buttonFileAsPdfSendPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonSavePdf.userInteractionEnabled = true
        buttonSavePdf.tag = 46
        
        
        webViewContainer.addSubview(buttonRemovePdf)
        webViewContainer.addSubview(buttonSavePdf)
        
        
        let pdfStickers = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfStickers, webViewContainer.bounds, nil)
        let pdfContext = UIGraphicsGetCurrentContext()
        UIGraphicsBeginPDFPage()
        webView.layer.renderInContext(pdfContext!)
        UIGraphicsEndPDFContext()
        
        
        let webViewPdf = UIWebView()
        webViewPdf.frame = webView.frame
        webViewPdf.loadData(pdfStickers, MIMEType: "application/pdf", textEncodingName: "UTF-8", baseURL: NSURL())
        webViewContainer.addSubview(webViewPdf)
        stickerDictionaryPdfPages.append(webViewContainer)
        //self.view.addSubview(webViewContainer)
    }
    
    
    
    func drawTrash(){
        let viewImage = UIImageView()
        viewImage.frame = CGRectMake(0, 0, 35, 35)
        viewImage.tag = 111
        viewImage.image = UIImage(named: "Delete.png")
        
        
        trashView.frame = CGRectMake(trashViewOffset, 600, 500, 35)
        trashView.backgroundColor = UIColor.clearColor()
        trashView.layer.cornerRadius = 6
        trashView.tag = 4
        if(stickerDictionary.count != 0){
            scrollView.addSubview(trashView)
        }
        trashView.userInteractionEnabled = true
        trashView.tag = 1
        trashView.addSubview(viewImage)
        
    }
    
    
    func drawArchive(){
        let viewImage = UIImageView()
        viewImage.frame = CGRectMake(450, 0, 35, 35)
        viewImage.tag = 112
        viewImage.image = UIImage(named: "Archive.png")
        
        
        archiveView.frame = CGRectMake(trashViewOffset+150, 600, 500, 35)
        archiveView.backgroundColor = UIColor.clearColor()
        archiveView.layer.cornerRadius = 6
        archiveView.tag = 4
        if(stickerDictionary.count != 0){
            scrollView.addSubview(archiveView)
        }
        let gesture = UITapGestureRecognizer(target: self, action: Selector("archiveTapped:"))
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
        scrollViewImage.frame = CGRectMake(0,50,screen*2, 1000)
        scrollViewImage.image = UIImage(named: "Process_background.png")
        scrollViewImage.tag = 570
        self.view.addSubview(scrollViewImage)
        scrollViewImage.hidden = false
        
        let scrollViewImageImprovements = UIImageView()
        scrollViewImageImprovements.frame = CGRectMake(0,50,screen*2, 1000)
        scrollViewImageImprovements.image = UIImage(named: "improvements_background.png")
        scrollViewImageImprovements.tag = 571
        self.view.addSubview(scrollViewImageImprovements)
        scrollViewImageImprovements.hidden = true
        
        
        let scrollViewImageFuture = UIImageView()
        scrollViewImageFuture.frame = CGRectMake(0,50,screen*2, 1000)
        scrollViewImageFuture.image = UIImage(named: "Editor_background.png")
        scrollViewImageFuture.tag = 572
        self.view.addSubview(scrollViewImageFuture)
        scrollViewImageFuture.hidden = true
        
        
        scrollViewIcon = UIScrollView()
        //scrollViewIcon.delegate = self
        scrollViewIcon.maximumZoomScale = 2
        scrollViewIcon.minimumZoomScale = 1
        
        
        scrollViewPdf = UIScrollView()
        scrollViewPdf.maximumZoomScale = 2
        scrollViewPdf.minimumZoomScale = 1
        scrollViewPdf.hidden = true
        
        
        containerTable = UIView()
        containerTable.frame = CGRectMake(380, 80, 300, 250)
        containerTable.userInteractionEnabled = true
        containerTable.backgroundColor = UIColor.clearColor()
        self.view.addSubview(containerTable)
        
        view.addSubview(scrollView)
        view.addSubview(scrollViewIcon)
        self.view.addSubview(scrollViewPdf)
        
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
        
        for view in stickerDictionaryIcon{
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
        
        
        for view in stickerDictionaryIcon{
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
        
        for view in stickerDictionaryIcon{
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
        //refreshStickers()
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
                    textField.hidden = true
                }
            }
            
            for case let textField as UITextField in sticker.subviews{
                if (textField.tag == 9){
                    textField.text = String(index+1)
                }
            }
            
        }
        
        //remove Stickers off timeline
        for view in stickerDictionary{
            view.removeFromSuperview()
        }
        
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionary.enumerate(){
            if(sticker.frame.width>171){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*242.6)
            scrollView.addSubview(sticker)
        }
        
        createIcons(stickerDictionary)
        scrollViewDidEndDecelerating(self.scrollView)
        
    }
    
    
    
    func createIcons(stickerDictionary: [UIView]){
        //Remove the existing icons off the timeline
        for view in stickerDictionaryIcon{
            view.removeFromSuperview()
        }
        //Remove all the icons from the icon dictionary
        stickerDictionaryIcon.removeAll()
        for sticker in stickerDictionary{
            //This is the main icon view which has an icon and a mirror of the icon
            let iconViewMain = UIView()
            iconViewMain.frame = CGRectMake(0,20,45, 45)
            iconViewMain.layer.cornerRadius = 5
            iconViewMain.tag = sticker.tag
            
            
            //This is the image of the real icon
            let iconImage = UIImageView()
            iconImage.frame = CGRectMake(-5, -7, 50, 50)
            iconImage.tag = 113
            
            
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
                        iconView.backgroundColor = UIColor.orangeColor()
                        iconImage.image = UIImage(named: "Sticker_orange.png")
                    case "red":
                        iconView.backgroundColor = UIColor.redColor()
                        iconImage.image = UIImage(named: "Sticker_red.png")
                    case "green":
                        iconView.backgroundColor = UIColor.greenColor()
                        iconImage.image = UIImage(named: "Sticker_green.png")
                    default:
                        iconView.backgroundColor = UIColor.greenColor()
                        iconImage.image = UIImage(named: "Sticker_green.png")
                    }
                }
            }
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
            
            stickerDictionaryIcon.append(iconViewMain)
            
        }
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionaryIcon.enumerate(){
            if(sticker.frame.width>36){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*75)
            scrollViewIcon.addSubview(sticker)
        }
        
    }
    
    
    //Button action method
    func buttonFlipPressed(sender: UIButton!){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            //sender.superview!.transform = CGAffineTransformMakeScale(1.6, 1.6)
            for textField in sender.superview!.subviews{
                if (textField.tag == 19){//This is the view for the controls at the back
                    if(textField.hidden == false){
                        textField.hidden = true
                    }else{
                        textField.hidden = false
                    }
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
        
        for view in stickerDictionaryIcon{
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
                if(textField.hidden == false){
                    textField.hidden = true
                }else{
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
        sender.superview?.superview!.layer.addAnimation(rotationAnimation, forKey: "rotation")
        var transform = CATransform3DIdentity
        transform.m34 = 1.0/500.0
        sender.superview?.superview!.layer.transform = transform
        
        for view in stickerDictionaryIcon{
            if (view.tag == sender.superview?.superview!.tag){
                view.layer.addAnimation(rotationAnimation, forKey: "rotation")
                view.layer.transform = transform
            }
        }
        
        
        CATransaction.commit()
    }
    
    
    func buttonOptionsPressed(sender: UIButton!){
        makeTableDisappear()
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    //This is file menu
                    for case let view as UIImageView in self.view.subviews{
                        if (view.tag == 116){
                            if(view.hidden == false){
                                view.hidden = true
                            }else{
                                view.hidden = false
                            }
                        }
                    }
                    //This is search menu
                    for case let view as UIImageView in self.view.subviews{
                        if (view.tag == 217){
                            if(view.hidden == false){
                                view.hidden = true
                            }else{
                                view.hidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func buttonFuturePressed(sender: UIButton!){
        makeTableDisappear()
        buttonCreateSticker.hidden = true
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1)
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1.2)
        
        //This is file menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 116){
                view.hidden = true
            }
        }
        //This is search menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 217){
                view.hidden = true
            }
        }
        
        //This is process button
        for view in self.view.subviews{
            if(view.tag==117){
                view.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
        //This is future button
        for view in self.view.subviews{
            if(view.tag==118){
                view.transform = CGAffineTransformMakeScale(1, 1.2)
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
        
        //remove Stickers off timeline
        for view in stickerDictionary{
            view.removeFromSuperview()
        }
        
        //Add Stickers to timeline
        if(stickerDictionaryTemp.count != 0){
            stickerDictionary.removeAll()
            for view in stickerDictionaryTemp{//Copy from temp to dictionary
                stickerDictionary.append(view)
            }
            stickerDictionaryTemp.removeAll()
            
        }
        
        //Check if current dictionary contains archives
        if(stickerDictionaryTemp.count == 0){
            if(stickerDictionary.count != 0){
            for case let textField as UITextField in stickerDictionary[0].subviews{
                if(textField.tag == 20){
                    if(textField.text! == "archived"){
                        stickerDictionary.removeAll()
                    }
                }
            }
            }
        }
        
        for (index,sticker) in stickerDictionary.enumerate(){//Add stickers to timeline
            if(sticker.frame.width>171){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*242.6)
            sticker.frame.origin.y = CGFloat(300)
            scrollView.addSubview(sticker)
        }
        
        createIcons(stickerDictionary)
        scrollViewDidEndDecelerating(self.scrollView)
        archiveView.hidden = false
        trashView.hidden = true
        
    }
    
    
    func buttonImprovementsPressed(sender: UIButton!){
        makeTableDisappear()
        archiveView.removeFromSuperview()
        trashView.removeFromSuperview()
        buttonCreateSticker.hidden = true
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1)
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1.2)
        
        //This is file menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 116){
                view.hidden = true
            }
        }
        //This is search menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 217){
                view.hidden = true
            }
        }
        
        
        //This is process button
        for view in self.view.subviews{
            if(view.tag==117){
                view.transform = CGAffineTransformMakeScale(1, 1)
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
                view.transform = CGAffineTransformMakeScale(1, 1.2)
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
        
        
        //remove Stickers off timeline
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        
        //Add Stickers to timeline
        stickerDictionaryTemp.removeAll()
        for view in stickerDictionary{//Copy from dictionary to temp
            stickerDictionaryTemp.append(view)
        }
        stickerDictionary.removeAll()
        for (index,view) in stickerDictionaryArchive.enumerate(){//Copy from archive to dictionary
            view.tag = index
            stickerDictionary.append(view)
        }
        for (index,sticker) in stickerDictionary.enumerate(){//Add stickers to timeline
            if(sticker.frame.width>171){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*242.6)
            sticker.frame.origin.y = CGFloat(300)
            scrollView.addSubview(sticker)
        }
        
        //scrollViewDidEndDecelerating(self.scrollView)
        createIcons(stickerDictionary)
        print("Number"+String(scrollView.subviews.count))
    }
    
    
    
    //This may be required to open as another thread in a future release
    
    func buttonProcessPressed(sender: UIButton!){
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1)
        sender.superview?.transform = CGAffineTransformMakeScale(1, 1.2)
        processPressed()
    }
    
    func processPressed(){
        
        makeTableDisappear()
        buttonCreateSticker.hidden = false
        archiveView.hidden = true
        trashView.hidden = false
        
        //This is file menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 116){
                if(view.hidden == true){
                    view.hidden = false
                }
            }
        }
        //This is search menu
        for case let view as UIImageView in self.view.subviews{
            if (view.tag == 217){
                if(view.hidden == true){
                    view.hidden = false
                }
            }
        }
        
        
        //This is process button
        for view in self.view.subviews{
            if(view.tag==117){
                view.transform = CGAffineTransformMakeScale(1, 1.2)
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
                textField.text = "Map your process"
            }
        }
        
        
        //This hides the other backgrounds
        for view in self.view.subviews{
            if(view.tag==571){//Improvements background
                view.hidden = true
            }
            if(view.tag==572){//Editor or future
                view.hidden = true
            }
            if(view.tag==570){//Process background
                view.hidden = false
            }
        }
        
        
        //remove Stickers off timeline
        for view in stickerDictionary{
            view.removeFromSuperview()
        }
        
        //Add Stickers to timeline
        if(stickerDictionaryTemp.count != 0){
            stickerDictionary.removeAll()
            for view in stickerDictionaryTemp{//Copy from temp to dictionary
                stickerDictionary.append(view)
            }
            stickerDictionaryTemp.removeAll()
        }
        
        //Check if current dictionary contains archives
        if(stickerDictionaryTemp.count == 0){
            if(stickerDictionary.count != 0){
                for case let textField as UITextField in stickerDictionary[0].subviews{
                    if(textField.tag == 20){
                        if(textField.text! == "archived"){
                            stickerDictionary.removeAll()
                        }
                    }
                }
            }
        }
        
        
        for (index,sticker) in stickerDictionary.enumerate(){//Add stickers to timeline
            if(sticker.frame.width>171){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*242.6)
            sticker.frame.origin.y = CGFloat(300)
            scrollView.addSubview(sticker)
        }
        
        createIcons(stickerDictionary)
    }
    
    func buttonCreateNewFilePressed(sender: UIButton!){
        makeTableDisappear()
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    
                    createNewFile()
                }
            }
        }
    }
    
    
    func createNewFile(){
        trashView.removeFromSuperview()
        archiveView.removeFromSuperview()
        //Check if you have any views on screen
        if(stickerDictionary.count != 0){
            let newFileAlert = UIAlertController(title: "New Process", message: "Are you sure you want to create another Process without saving this one first? All changes if any in the current process will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
            newFileAlert.view.backgroundColor = UIColor.greenColor()
            
            newFileAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                
                for view in self.view.subviews{
                    if(view.tag==59){
                        for case let textField as UITextField in view.subviews{
                            if (textField.tag == 5){
                                textField.text = "Unsaved Process"
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
                        textField.text = "Unsaved Process"
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
                
                //Remove all icon views
                if(self.stickerDictionaryIcon.count != 0){
                    for view in self.stickerDictionaryIcon{
                        view.removeFromSuperview()
                    }
                    self.stickerDictionaryIcon.removeAll()
                }
                
                //Remove all stickers from dictionary
                for view in self.stickerDictionary{
                    view.removeFromSuperview()
                }
                self.stickerDictionary.removeAll()
                self.stickerDictionaryArchive.removeAll()
                self.stickerDictionaryTemp.removeAll()
                
                //self.makeTableAppear()
            }))
            
            newFileAlert.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: {(action: UIAlertAction!) in
                
                
            }))
            
            
            presentViewController(newFileAlert, animated: true, completion: nil)
            
        }//End if statement
        
    }
    
    func buttonOpenFilePressed(sender: UIButton!){
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    
                    makeTableAppear("")
                }
            }
        }
    }
    
    func buttonSavePressed(sender: UIButton){// This is the save as button; The save button is the update button
        makeTableDisappear()
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    if(stickerDictionary.count != 0){
                        //This is what calls the save function
                        createAlertViewInput("Save Process", message: "Enter Process Name.")
                    }else{
                        self.createAlertView("Save Process", message: "The current process contains zero items")
                    }
                }
            }
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
                    self.createAlertView("Save Process", message: "Process With Name"+"("+fileName+") already exists")
                }
            }else{
                self.createAlertView("Save Process", message: "You specified an empty process name")
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
            
            //Append archives if they exist
            if(stickerDictionaryArchive.count != 0){
                for view in stickerDictionaryArchive{
                    stickerDictionary.append(view)
                }
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
            print("Count "+String(stickerDictionary.count))
            createAlertView("Process Saved As", message: "Process Saved Successfully As "+"("+filename+")")
            
            
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
        makeTableDisappear()
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
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
                            self.createAlertView("Save Process", message: "You need to save as first")
                        }
                        if(!self.checkFileExists(newFile)){
                            self.createAlertView("Save Process", message: "The current process does not exist")
                        }
                        updateFile(newFile)
                    }else{
                        self.createAlertView("Save Process", message: "The current process contains zero items")
                    }
                }
            }
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
            
            //Append archives if they exist
            if(stickerDictionaryArchive.count != 0){
                for view in stickerDictionaryArchive{
                    stickerDictionary.append(view)
                }
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
            
            createAlertView("Process Saved/Updated", message: "Process Saved/Updated Successfully"+"("+filename+")")
            
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
        makeTableDisappear()
        let sentView = sender.superview
        var newFile = ""
        for case let textField as UITextField in (sentView?.subviews)!{
            if (textField.tag == 5){
                newFile = textField.text!
            }
        }
        if(!checkFileExists(newFile)){
            createAlertView("Delete Process", message: "Process With Process Name"+"("+newFile+") does not exist")
            return
        }
        createAlertView("Delete Process", message: "Are you sure you want to Delete the Process Named "+newFile+" ? All data in the process will be lost.")
        deleteSavedFile(newFile)
        
    }
    
    
    func deleteSavedFile(fileName: String){
        let predicate = NSPredicate(format: "fileName == %@", fileName)
        let retrievedFileNames = try! Realm().objects(StickerFile).filter(predicate)
        if(retrievedFileNames.count == 0){//file exists not
            createAlertView("Delete Process", message: "Process With Process Name"+"("+fileName+") does not exist")
        }
        if(retrievedFileNames.count != 0){//file exists
            let newAlertView = UIAlertController(title: "Delete Process", message: "Are you sure you want to Delete the Process Named "+fileName+" ? All data in the process will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
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
                for case let textField as UITextField in self.view.subviews{
                    if(textField.tag==59){
                        if(textField.text == fileName){
                            print(textField.text)
                            //Remove stikers
                            for view in self.stickerDictionary{
                                view.removeFromSuperview()
                            }
                            self.stickerDictionary.removeAll()
                            self.stickerDictionaryTemp.removeAll()
                            self.stickerDictionaryArchive.removeAll()
                            
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
                                    textField.text = "Unsaved Process"
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
                            
                            self.createAlertView("Delete Process", message: "Successfully Deleted"+"("+fileName+")")
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
        viewSaveImage.frame = CGRectMake(screen-177.8, 45, 80, 100.0)
        viewSaveImage.tag = 116
        viewSaveImage.image = UIImage(named: "Menu.png")
        viewSaveImage.userInteractionEnabled = true
        
        
        let viewSave = UIView()
        viewSave.frame = CGRectMake(0, 0, 80, 100)
        viewSave.backgroundColor = UIColor.clearColor()
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
        textFieldSaveName.text = "Unsaved Process"
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
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    
                    let sentView = sender.superview
                    var newFile = ""
                    for case let textField as UITextField in (sentView?.subviews)!{
                        if (textField.tag == 5){
                            newFile = textField.text!
                        }
                    }
                    makeTableAppear(newFile)
                }
            }
        }
    }
    
    
    //This is view all button
    func buttonViewAllFilesPressed(sender: UIButton!){
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    makeTableAppear("")
                }
            }
        }
        
    }
    
    func buttonHideAllFilesPressed(sender: UIButton!){
        //Check if process is active
        for view in self.view.subviews{
            if(view.tag==570){//Process background
                if(view.hidden == false){//Process background
                    makeTableDisappear()
                }
            }
        }
    }
    
    
    func makeTableAppear(search: String){
        allFilesTableView.frame = CGRectMake(0, 74, 211, 130)
        allFilesTableView.backgroundColor = UIColor.clearColor()
        allFilesTableView.userInteractionEnabled = true
        allFilesTableView.tag = 15
        allFilesTableView.scrollEnabled = true
        retrievedFileNames.removeAll()
        if(search.isEmpty){
            let retrievedFiles = try! Realm().objects(StickerFile)
            if(retrievedFiles.count == 0){
                createAlertView("View All Processes", message: "There Were No Processes To Retrieve")
            }
            else{
                for file in retrievedFiles{
                    retrievedFileNames.append(file.fileName)
                }
                
                allFilesTableView.delegate = self
                allFilesTableView.dataSource = self
                allFilesTableView.reloadData()
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
                createAlertView("Search Processes", message: "There Were No Processes To Retrieve")
            }
            if(retrievedFiles.count != 0){
                for file in retrievedFiles{
                    retrievedFileNames.append(file.fileName)
                }
                
                allFilesTableView.delegate = self
                allFilesTableView.dataSource = self
                allFilesTableView.reloadData()
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
        allFilesTableView.setNeedsDisplay()
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
        textFieldSaveName.text = "Unsaved Process"
        
        
        
        viewImageProcess.addSubview(buttonProcess)
        view.addSubview(viewImageProcess)
        viewImageFuture.addSubview(buttonFuture)
        view.addSubview(viewImageFuture)
        viewImageImprovements.addSubview(buttonImprovements)
        view.addSubview(viewImageImprovements)
        view.addSubview(textFieldSaveName)
    }
    
    
    
    
    
    func makeHeaders(){
        let textFieldTitleHeader = UITextField(frame: CGRectMake(1.0, 30.0, 130.0, 20.0))
        textFieldTitleHeader.textAlignment = NSTextAlignment.Center
        textFieldTitleHeader.textColor = UIColor.blackColor()
        textFieldTitleHeader.font = UIFont.italicSystemFontOfSize(8)
        textFieldTitleHeader.borderStyle = UITextBorderStyle.Line
        textFieldTitleHeader.autocapitalizationType = UITextAutocapitalizationType.Words
        textFieldTitleHeader.backgroundColor = UIColor.clearColor()
        textFieldTitleHeader.borderStyle = UITextBorderStyle.None
        textFieldTitleHeader.tag = 59
        textFieldTitleHeader.text = "Unsaved Process"
        textFieldTitleHeader.center.x = screen/2
        
        
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
        textFieldTitleActivityHeader.center.x = screen/2
        
        
        let buttonOptionsImage = UIImageView()
        buttonOptionsImage.frame = CGRectMake(screen-107.8, 20, 30, 30)
        buttonOptionsImage.tag = 1191
        buttonOptionsImage.image = UIImage(named: "Options.png")
        buttonOptionsImage.userInteractionEnabled = true
        
        
        
        let buttonOptions:UIButton! = UIButton(type: .System)
        buttonOptions.frame = CGRectMake(0, 0, 30, 30)
        buttonOptions.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOptions.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOptions.backgroundColor = UIColor.clearColor()
        buttonOptions.setTitle("", forState: UIControlState.Normal)
        buttonOptions.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonOptions.addTarget(self, action: "buttonOptionsPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonOptions.userInteractionEnabled = true
        
        
        
        view.addSubview(textFieldTitleHeader)
        view.addSubview(textFieldTitleActivityHeader)
        buttonOptionsImage.addSubview(buttonOptions)
        view.addSubview(buttonOptionsImage)
    }
    
    
    
    
    func makeViewAllFilesButton(){
        let viewImageProcess = UIImageView()
        viewImageProcess.frame = CGRectMake(screen-300.3, 45, 120, 30.0)
        viewImageProcess.tag = 217
        viewImageProcess.image = UIImage(named: "Process.png")
        viewImageProcess.userInteractionEnabled = true
        
        
        
        let viewAllFiles = UIView()
        viewAllFiles.frame = CGRectMake(0, 0, 120, 20)
        viewAllFiles.backgroundColor = UIColor.clearColor()
        viewAllFiles.layer.cornerRadius = 6
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
        textFieldSaveName.text = "Type Process Name"
        
        
        
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
        view.frame = CGRectMake(CGFloat(Double(stickerNumber)*242.6), 300, 170.6, 170.6)
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
        textCurrentColor.text = stickerColor
        
        
        let textCurrentName = UITextField(frame: CGRectMake(0.0, 1.0, 168.0, 16.0))
        textCurrentName.textAlignment = NSTextAlignment.Center
        textCurrentName.font = UIFont.italicSystemFontOfSize(8)
        textCurrentName.textColor = UIColor.blackColor()
        textCurrentName.tag = 8
        textCurrentName.text = "Name This Sticker"
        textCurrentName.addTarget(self, action: "nameChanged:", forControlEvents: UIControlEvents.AllEditingEvents)
        
        
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
        buttonFlipImage.frame = CGRectMake(0, 0, 48, 48)
        buttonFlipImage.tag = 113
        buttonFlipImage.image = UIImage(named: "Info.png")
        buttonFlipImage.userInteractionEnabled = true
        
        
        
        let buttonFlip:UIButton! = UIButton(type: .System)
        buttonFlip.frame = CGRectMake(135, 150, 18, 18.0)
        buttonFlip.layer.cornerRadius = 9
        buttonFlip.backgroundColor = UIColor.clearColor()
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: "buttonFlipPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonFlip.setImage(buttonFlipImage.image, forState: UIControlState.Normal)
        
        
        let buttonFlipBack:UIButton! = UIButton(type: .System)
        buttonFlipBack.frame = CGRectMake(133, 148, 18, 18.0)
        buttonFlipBack.layer.cornerRadius = 9
        buttonFlipBack.backgroundColor = UIColor.clearColor()
        buttonFlipBack.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlipBack.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlipBack.setTitle("", forState: UIControlState.Normal)
        buttonFlipBack.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlipBack.addTarget(self, action: "buttonFlipBackPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonFlipBack.setImage(buttonFlipImage.image, forState: UIControlState.Normal)
        
        
        
        view.addSubview(textField)
        view.addSubview(textTitleStatus)
        view.addSubview(textCurrentColor)
        view.addSubview(textCurrentName)
        view.addSubview(textCurrentFile)
        view.addSubview(buttonFlip)
        view.addSubview(textViewId)
        viewControl.addSubview(buttonGreenColor)
        viewControl.addSubview(buttonRedColor)
        viewControl.addSubview(buttonDelete)
        viewControl.addSubview(buttonOrangeColor)
        viewControl.addSubview(buttonFlipBack)
        view.addSubview(viewControl)
        
        stickerDictionary.append(view)
        view.addSubview(textTitle)
        view.addSubview(viewImage)
        view.sendSubviewToBack(viewImage)
        //view.heightAnchor.constraintEqualToConstant(170.6).active = true
        //view.widthAnchor.constraintEqualToConstant(170.6).active = true
        
        
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
        view.frame = CGRectMake(CGFloat(sticker.xPosition), 300, 170.6, 170.6)
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
        
        
        
        //This is the image of the real icon
        let buttonFlipImage = UIImageView()
        buttonFlipImage.frame = CGRectMake(0, 0, 48, 48)
        buttonFlipImage.tag = 113
        buttonFlipImage.image = UIImage(named: "Info.png")
        buttonFlipImage.userInteractionEnabled = true
        
        
        
        let buttonFlip:UIButton! = UIButton(type: .System)
        buttonFlip.frame = CGRectMake(135, 150, 18, 18.0)
        buttonFlip.layer.cornerRadius = 9
        buttonFlip.backgroundColor = UIColor.clearColor()
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: "buttonFlipPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonFlip.setImage(buttonFlipImage.image, forState: UIControlState.Normal)
        
        
        let buttonFlipBack:UIButton! = UIButton(type: .System)
        buttonFlipBack.frame = CGRectMake(133, 148, 18, 18.0)
        buttonFlipBack.layer.cornerRadius = 9
        buttonFlipBack.backgroundColor = UIColor.clearColor()
        buttonFlipBack.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlipBack.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlipBack.setTitle("", forState: UIControlState.Normal)
        buttonFlipBack.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlipBack.addTarget(self, action: "buttonFlipBackPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonFlip.setImage(buttonFlipImage.image, forState: UIControlState.Normal)
        
        
        
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
        
        if(sticker.stickerStatus == "archived"){
            stickerDictionaryArchive.append(view)
        }else{
            stickerDictionary.append(view)
        }
        view.addSubview(textTitle)
        view.addSubview(viewImage)
        view.sendSubviewToBack(viewImage)
        
        //view.heightAnchor.constraintEqualToConstant(170.6).active = true
        //view.widthAnchor.constraintEqualToConstant(170.6).active = true
        
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
        for view in stickerDictionaryIcon{
            view.removeFromSuperview()
        }
        
        //Add Stickers to timeline
        for (index,sticker) in stickerDictionaryIcon.enumerate(){
            if(sticker.frame.width>36){
                sticker.transform = CGAffineTransformMakeScale(1, 1)
            }
            sticker.frame.origin.x = CGFloat(Double(index)*75)
            scrollViewIcon.addSubview(sticker)
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
        
        //This selects whether trash or archive be displayed depending on the interface
        for view in self.view.subviews{
            if(view.tag==572){//Editor or future
                if(view.hidden == false){
                    trashViewOffset = CGFloat(lengthOriginToTap-Float(245))
                    drawArchive()
                    archiveView.hidden = false
                }
            }
            if(view.tag==570){//Process background
                if(view.hidden == false){
                    trashViewOffset = CGFloat(lengthOriginToTap-Float(245))
                    drawTrash()
                    trashView.hidden = false
                }
            }
        }
        
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
            for view in stickerDictionary{
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
                            
                        }
                        
                        if(sticker.frame.width>171){
                            sticker.transform = CGAffineTransformMakeScale(1, 1)
                        }
                        sticker.frame.origin.x = CGFloat(Double(index)*242.6)
                        scrollView.addSubview(sticker)
                    }
                    
                    createIcons(stickerDictionary)
                }
                
            }
            
            if((gesture.view!.frame.intersects(trashView.frame))){
                print("Intersect Delete Occurred")
                deleteSticker(gesture.view!)
                trashView.removeFromSuperview()
                archiveView.removeFromSuperview()
                
            }
            
            
            if((gesture.view!.frame.intersects(archiveView.frame))){
                let sentView = gesture.view!
                for case let textField as UITextField in sentView.subviews{
                    if(textField.tag == 20){
                        textField.text = "archived"
                    }
                }
                stickerDictionaryArchive.append(sentView)
                deleteSticker(sentView)
                
                trashView.removeFromSuperview()
                archiveView.removeFromSuperview()
                print("Intersect Archive Occurred")
                
                
            }
            
        }
        
    }
    
    func nameChanged(textField: UITextField){
        scrollViewDidEndDecelerating(self.scrollView)
        for view in stickerDictionaryIcon{
            view.transform = CGAffineTransformMakeScale(1, 1)
        }
        for view in stickerDictionary{
            view.transform = CGAffineTransformMakeScale(1, 1)
        }
        
        //This selects whether trash or archive be displayed depending on the interface
        for view in self.view.subviews{
            if(view.tag==572){//Editor or future
                if(view.hidden == false){
                    let lengthFromZero = Double((textField.superview?.tag)!)*242.6
                    let offset = lengthFromZero - 242.6
                    trashViewOffset = CGFloat(offset)
                    drawArchive()
                    archiveView.hidden = false
                    
                }
            }
            if(view.tag==570){//Process background
                if(view.hidden == false){
                    let lengthFromZero = Double((textField.superview?.tag)!)*242.6
                    let offset = lengthFromZero - 242.6
                    trashViewOffset = CGFloat(offset)
                    drawTrash()
                    trashView.hidden = false
                }
            }
        }
        
        
        textField.superview?.transform = CGAffineTransformMakeScale(1.6, 1.6)
        for view in stickerDictionaryIcon{
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