//
//  ViewController.swift
//  d
//
//  Created by AMK on 09/01/16.
//  Copyright © 2016 AMK. All rights reserved.
//
//test git

import UIKit

class ViewController: UIViewController {
    var stickerDictionary = [String: UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonCreateSticker()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeButtonCreateSticker(){
        let buttonCreateSticker:UIButton! = UIButton(type: .System)
        buttonCreateSticker.frame = CGRectMake(20, 30, 110, 30)
        buttonCreateSticker.layer.cornerRadius = 5
        buttonCreateSticker.backgroundColor = UIColor.greenColor()
        buttonCreateSticker.setTitle("Create Sticker", forState: UIControlState.Normal)
        buttonCreateSticker.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonCreateSticker.addTarget(self, action: "buttonCreateStickerPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonCreateSticker)
    }
    
    
    func buttonCreateStickerPressed(sender: UIButton!){
        let stickerName = "Sticker Number "+String(stickerDictionary.count+1)
        let stickerNumber = stickerDictionary.count+1
        makeSticker(stickerName, stickerNumber: stickerNumber)
    }
    
    func buttonOrangeColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.backgroundColor = UIColor.orangeColor()
    }
    
    
    func buttonGreenColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.backgroundColor = UIColor.greenColor()
    }
    
    
    func buttonBlueColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.backgroundColor = UIColor.redColor()
    }
    
    func buttonDeletePressed(sender: UIButton!){
        let sentView = sender.superview
        let tag = sentView?.tag
        let stickerName = "Sticker Number "+String(tag)
        stickerDictionary.removeValueForKey(stickerName)
        sentView?.hidden = true
    }
    
    
    
    
    func makeSticker(stickerLabel: String, stickerNumber: Int){
        let view = UIView()
        view.frame = CGRectMake(30, 50, 200, 120)
        view.backgroundColor = UIColor.greenColor()
        view.layer.cornerRadius = 6
        view.tag = stickerNumber
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        view.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        
        
        let textLabel = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.font = UIFont.italicSystemFontOfSize(8)
        textLabel.textColor = UIColor.blackColor()
        textLabel.text = stickerLabel
        
        let textField = UITextField(frame: CGRectMake(0.0, 9.0, 200.0, 101.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(10)
        textField.borderStyle = UITextBorderStyle.Line
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = UITextBorderStyle.None
        
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
        buttonBlueColor.addTarget(self, action: "buttonBlueColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
        buttonDelete.frame = CGRectMake(106, 112, 30, 8.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeletePressed:", forControlEvents: UIControlEvents.TouchUpInside)

        
        
        view.addSubview(textLabel)
        view.addSubview(textField)
        view.addSubview(buttonOrangeColor)
        view.addSubview(buttonGreenColor)
        view.addSubview(buttonBlueColor)
        view.addSubview(buttonDelete)
        
        stickerDictionary[stickerLabel] = view
        self.view.addSubview(view)
    }
    
    
    func dragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        let gesturedView = gesture.view
        gesturedView!.center = loc
    }
    
}

