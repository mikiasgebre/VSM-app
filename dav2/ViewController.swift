import UIKit




class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource,UICollisionBehaviorDelegate, UIGestureRecognizerDelegate{
    
    var xposition : CGFloat = 10.0
    var yposition : CGFloat = 10.0
    var stickerDictionary = [String: UIView]()
    
    let buttonDelete:UIButton! = UIButton(type: .System)
    var doubleTap : Bool = true
    var secondView : UIView!
    var sentView : UIView!
    let screenSize = UIScreen.mainScreen().bounds
    let scrollView = UIScrollView(frame: CGRectMake(0, 100, 1000, 500))
    var StickerArray = [UIView]()
    var stackView : UIStackView!
    var pickerView: UIPickerView = UIPickerView()
    var textField : UITextField = UITextField()
    var FontFamilyName = [String]()
    var myLabel: UILabel!
    var TextView = UITextView(frame: CGRectMake(30, 30, 300, 270))
    var Fontsize = [Int]()
    var TextViewArray = [UITextView]()
    var TableView = UITableView()
    var TableViewsize = UITableView()
    let deleteIcon = UIImageView(image: UIImage(named: "Delete")!)
    var arraynumber = [Int]()
    var myTextField : UITextField!
    let fontsize : [String] = ["8","9","10","11","12","14","16","18","20","22","24","26","28","36","48","72"]
    let dropdownicon = UIImageView(image: UIImage(named: "dropdownarrow2")!)
    let dropdownicon1 = UIImageView(image: UIImage(named: "dropdownarrow2")!)
    let TableLabel: UILabel = UILabel()
    let TableLabel1: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonCreateSticker()
        deleteIcon.frame = CGRectMake(39, 800, 50, 50)
        
        
        
        
        var count = CGFloat(stickerDictionary.count+100)
        count += 10000
        scrollView.scrollEnabled = true
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        scrollView.autoresizingMask =  UIViewAutoresizing.FlexibleHeight
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 100, 0, count)
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,1)
        scrollView.contentSize = CGSize(width: 100, height: 100)
        scrollView.delegate = self
        
        //self.view.addSubview(deleteIcon)
        
        
        view.addSubview(scrollView)
        
        
        scrollView.addSubview(deleteIcon)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        //deleteIcon.frame.origin.y = 20 + scrollView.contentOffset.y
        //deleteIcon.frame.origin.x = 600 + scrollView.contentOffset.x
        //let xposition = 600 + scrollView.contentOffset.x
        //deleteIcon.frame = CGRectMake(xposition, 400, 50, 50)
        deleteIcon.frame.origin.x = max(scrollView.contentOffset.x + 90,scrollView.contentOffset.x - 90)
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        //deleteIcon.frame.origin.x = 600 + scrollView.contentOffset.x
        deleteIcon.frame.origin.x = max(scrollView.contentOffset.x + 100,scrollView.contentOffset.x - 100)
        // deleteIcon.frame.origin.x = min(scrollView.contentOffset.x + 300,scrollView.contentOffset.x)
        // deleteIcon.frame = CGRectMake(xposition, 400, 50, 50)
        
    }
    
    func makeButtonCreateSticker(){
        let buttonCreateSticker:UIButton! = UIButton(type: .System)
        buttonCreateSticker.frame = CGRectMake(20, 30, 110, 30)
        buttonCreateSticker.layer.cornerRadius = 5
        buttonCreateSticker.backgroundColor = UIColor.greenColor()
        buttonCreateSticker.setTitle("Create Sticker", forState: UIControlState.Normal)
        buttonCreateSticker.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonCreateSticker.addTarget(self, action: #selector(ViewController.buttonCreateStickerPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonCreateSticker)
    }
    
    
    func buttonCreateStickerPressed(sender: UIButton!){
        let stickerName = "Sticker Number "+String(stickerDictionary.count+1)
        let stickerNumber = stickerDictionary.count+1
        makeSticker(stickerName, stickerNumber: stickerNumber)
    }
    
    
    
    
    func buttonDeletePressed(sender: UIButton!){
        let sentView = sender.superview
        let tag = sentView?.tag
        let stickerName = "Sticker Number "+String(tag)
        stickerDictionary.removeValueForKey(stickerName)
        sentView?.hidden = true
    }
    
    
    func makeSticker(stickerLabel: String, stickerNumber: Int){
        
        let imageView = UIImageView(image: UIImage(named: "postit1")!)
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        // let buttonFlip:UIButton! = UIButton(type: .System)
        
        imageView.tintColor = UIColor.greenColor()
        
        
        let buttonFlip: UIButton! =  UIButton(type: .System)
        
        
        // imageView.frame = CGRectMake(0, 0, 200, 100 )
        
        view.tag = stickerNumber
        imageView.layer.cornerRadius = 6
        imageView.tag = stickerNumber
        view.addSubview(imageView)
        
        let layer = imageView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.dragged(_:)))
        imageView.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        imageView.userInteractionEnabled = true
        
        
        
        let textLabel = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.font = UIFont.italicSystemFontOfSize(8)
        textLabel.textColor = UIColor.blackColor()
        textLabel.text = stickerLabel
        
        
        
        let SerialNumber = UITextView(frame: CGRectMake(90, 20, 80, 30))
        SerialNumber.alpha = 0.4
        let Serial = UILabel(frame: CGRectMake(30, 20, 50, 50))
        Serial.text = "Serial Number"
        Serial.font = Serial.font.fontWithSize(7)
        SerialNumber.textAlignment = NSTextAlignment.Center
        SerialNumber.font = UIFont.italicSystemFontOfSize(8)
        SerialNumber.textColor = UIColor.blackColor()
        //imageView.addSubview(SerialNumber)
        // imageView.addSubview(Serial)
        
        
        let TextView = UITextView(frame: CGRectMake(30, 30, 300, 270))
        TextView.textColor = UIColor.blackColor()
        
        //TextView.alpha = 0.4
        
        
        TextView.delegate = self
        TextView.tag = stickerNumber
        TextView.backgroundColor = UIColor.clearColor()
        
        TextViewArray.append(TextView)
        TextView.textColor = UIColor.blackColor()
        imageView.addSubview(TextView)
        
        buttonDelete.frame = CGRectMake(230, 160, 40, 28.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.layer.cornerRadius = 0.5 * buttonDelete.bounds.size.width
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: #selector(ViewController.buttonDeletePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonFlip.frame = CGRectMake(300, 300, 80, 40)
        buttonFlip.layer.cornerRadius = 3
        buttonFlip.backgroundColor = UIColor.brownColor()
        buttonFlip.layer.cornerRadius = 0.5 * buttonFlip.bounds.size.width
        buttonFlip.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlip.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip.addTarget(self, action: #selector(ViewController.buttonFlip(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        imageView.addSubview(buttonFlip)
        
        imageView.addSubview(textLabel)
        imageView.addSubview(buttonFlip)
        
        stickerDictionary[stickerLabel] = imageView
        StickerArray.append(imageView)
        
        
        stackView = UIStackView(arrangedSubviews: StickerArray)
        
        stackView.tag = 1
        
        stackView.axis = .Horizontal
        stackView.distribution = .Fill
        stackView.alignment = .Center
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        
        let animator = UIDynamicAnimator(referenceView : self.scrollView)
        
        let boundaries = UICollisionBehavior(items: [imageView,deleteIcon])
        boundaries.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(boundaries)
        
        
        if (CGRectIntersectsRect(deleteIcon.frame, stackView.frame))
        {
            
            
            imageView.hidden = true
            //stackView.hidden = true
            //stackView.backgroundColor = UIColor.redColor()
            
        }
        
        
        
        
        if (CGRectIntersectsRect(deleteIcon.frame, StickerArray[stickerNumber-1].frame))
        {
            
            // print("yes")
            //stackView.hidden = true
            //stackView.backgroundColor = UIColor.redColor()
            
        }
        
        
        
        
        
        
        imageView.heightAnchor.constraintEqualToConstant(400).active = true
        imageView.widthAnchor.constraintEqualToConstant(400).active = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
    }
    
    
    
    func buttonFlip(sender: UIButton)
    {
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        let buttonGreenColor:UIButton! = UIButton(type: .System)
        let buttonRedColor:UIButton! = UIButton(type: .System)
        
        performSelector(#selector(ViewController.flip), withObject: nil, afterDelay: 0)
        
        
        buttonOrangeColor.frame = CGRectMake(50, 300, 40, 28.0)
        buttonOrangeColor.layer.cornerRadius = 3
        buttonOrangeColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOrangeColor.layer.cornerRadius = 0.5 * buttonOrangeColor.bounds.size.width
        buttonOrangeColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOrangeColor.backgroundColor = UIColor.orangeColor()
        buttonOrangeColor.setTitle("Orange", forState: UIControlState.Normal)
        buttonOrangeColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOrangeColor.addTarget(self, action: #selector(ViewController.buttonOrangeColorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        buttonGreenColor.frame = CGRectMake(110, 300, 40, 28.0)
        buttonGreenColor.layer.cornerRadius = 3
        buttonGreenColor.tag = 1
        buttonGreenColor.backgroundColor = UIColor.greenColor()
        buttonGreenColor.layer.cornerRadius = 0.5 * buttonGreenColor.bounds.size.width
        buttonGreenColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonGreenColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonGreenColor.setTitle("Green", forState: UIControlState.Normal)
        buttonGreenColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonGreenColor.addTarget(self, action: #selector(ViewController.buttonGreenColorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        buttonRedColor.frame = CGRectMake(170, 300, 40, 28.0)
        buttonRedColor.layer.cornerRadius = 3
        buttonRedColor.backgroundColor = UIColor.redColor()
        buttonRedColor.layer.cornerRadius = 0.5 * buttonRedColor.bounds.size.width
        buttonRedColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonRedColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonRedColor.setTitle("Red", forState: UIControlState.Normal)
        buttonRedColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRedColor.addTarget(self, action: #selector(ViewController.buttonRedColorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        
        
        let buttonFlip1: UIButton! =  UIButton(type: .System)
        buttonFlip1.frame = CGRectMake(300, 300, 80, 40)
        buttonFlip1.layer.cornerRadius = 3
        buttonFlip1.backgroundColor = UIColor.brownColor()
        buttonFlip1.layer.cornerRadius = 0.5 * buttonFlip1.bounds.size.width
        buttonFlip1.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonFlip1.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonFlip1.setTitle("Flip", forState: UIControlState.Normal)
        buttonFlip1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonFlip1.addTarget(self, action: #selector(ViewController.flipSecond(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        sentView = sender.superview
        secondView = UIView()
        
        secondView.frame  = sentView!.frame
        //secondView.backgroundColor = UIColor.greenColor()
        
        
        let layer = secondView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        
        
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            FontFamilyName.append(familyName)
            FontFamilyName.sortInPlace()
            
        }
        
        
        
        
        
        // Fontsize.append([8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72])
        
        
        scrollView.addSubview(secondView)
        secondView.addSubview(buttonRedColor)
        secondView.addSubview(buttonGreenColor)
        secondView.addSubview(buttonOrangeColor)
        secondView.addSubview(buttonFlip1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.singleTap(_:)))
        tap.numberOfTapsRequired = 1
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.singleTap1(_:)))
        tap1.numberOfTapsRequired = 1
        
        TableLabel.frame = CGRect(x: 130, y: 40, width: 100, height: 20)
        TableLabel.text = "Font Style"
        TableLabel.backgroundColor = UIColor.whiteColor()
        TableLabel.addGestureRecognizer(tap)
        tap.delegate = self
        TableLabel.userInteractionEnabled = true
        TableLabel.adjustsFontSizeToFitWidth = true
        //let dropdownicon = UIImageView(image: UIImage(named: "dropdownarrow2")!)
        dropdownicon.frame = CGRectMake(90, 10, 10, 10)
        TableLabel.addSubview(dropdownicon)
        
        TableLabel1.frame = CGRect(x: 40, y: 100, width: 90, height: 20)
        TableLabel1.text = "Font size"
        TableLabel1.backgroundColor = UIColor.whiteColor()
        TableLabel1.addGestureRecognizer(tap1)
        tap1.delegate = self
        TableLabel1.userInteractionEnabled = true
        TableLabel1.adjustsFontSizeToFitWidth = true
        
        dropdownicon1.frame = CGRectMake(80, 10, 10, 10)
        TableLabel1.addSubview(dropdownicon1)
        
        
        
        
        // secondView.addSubview(TableLabel)
        
        
        //TableView: UITableView  =   UITableView()
        TableView.frame = CGRect(x: 130, y: 65, width: 100, height: 50)
        TableView.delegate      =   self
        TableView.dataSource    =   self
        TableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        TableView.backgroundColor = UIColor.clearColor()
        TableView.hidden = true
        
        
        
        TableViewsize.frame = CGRect(x: 40, y: 120, width: 100, height: 50)
        TableViewsize.delegate      =   self
        TableViewsize.dataSource    =   self
        TableViewsize.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        TableViewsize.backgroundColor = UIColor.clearColor()
        TableViewsize.hidden = true
        
        
        
        pickerView = UIPickerView()
        myLabel = UILabel()
        
        myTextField = UITextField()
        myLabel.frame = CGRectMake(300, 10, 300, 100)
        myTextField.frame = CGRectMake(50, 100, 250, 30)
        //let myTextField = UITextField(frame: CGRectMake(50.0, 70.0, 300.0, 50.0))
        //myTextField.textAlignment = NSTextAlignment.Center
        myTextField.font = UIFont.italicSystemFontOfSize(8)
        myTextField.textColor = UIColor.blackColor()
        myTextField.backgroundColor = UIColor.redColor()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        
        pickerView.backgroundColor = UIColor.clearColor()
        //self.textField.inputView = pickerView
        pickerView.frame = CGRectMake(20, 100, 300, 100)
        
        secondView.addSubview(TableLabel1)
        secondView.addSubview(TableLabel)
        secondView.addSubview(TableView)
        secondView.addSubview(TableViewsize)
        // secondView.addSubview(pickerView)
        secondView.addSubview(myLabel)
        // secondView.addSubview(myTextField)
        
        
        
        let customStepper = UIStepper(frame:CGRectMake(200, 50, 0, 0))
        customStepper.wraps = true
        customStepper.autorepeat = true
        customStepper.maximumValue = 50
        customStepper.minimumValue = 10
        customStepper.addTarget(self, action: #selector(ViewController.stepperValueChanged(_:)), forControlEvents: .ValueChanged)
        customStepper.backgroundColor = UIColor.clearColor()
        //secondView.addSubview(customStepper)
        
        
        // secondView.hidden = true
        if(doubleTap)
        {
            TextViewArray[sentView.tag-1].hidden = true
            //doubleTap = false
        }
        
        
    }
    
    func singleTap(sender: UITapGestureRecognizer)
    {
        
        if(doubleTap)
        {
            TableView.hidden = false
            //dropdownicon.transform = CGAffineTransformMakeScale(-1, 1)
            dropdownicon.transform =  CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            doubleTap = false
        }
        else
        {
            TableView.hidden = true
            dropdownicon.transform =  CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)))
            doubleTap = true
            
        }
        
    }
    
    func singleTap1 (sender: UITapGestureRecognizer)
    {
        
        if(doubleTap)
        {
            TableViewsize.hidden = false
            dropdownicon1.transform =  CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            doubleTap = false
        }
        else
        {
            TableViewsize.hidden = true
             dropdownicon1.transform =  CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)))
            doubleTap = true
            
        }
        
        
    }
    
    
    func buttonOrangeColorPressed(sender: UIButton!){
        //let sentView = sender.superview
        sentView?.tintColor = UIColor.orangeColor()
        //secondView.backgroundColor = UIColor.orangeColor()
        
        
    }
    
    
    func buttonRedColorPressed(sender: UIButton!){
        //let sentView = sender.superview
        sentView?.tintColor = UIColor.redColor()
        //secondView.backgroundColor = UIColor.redColor()
        
    }
    
    func buttonGreenColorPressed(sender: UIButton!){
        // let sentView = sender.superview
        sentView?.tintColor = UIColor.greenColor()
        // secondView.backgroundColor = UIColor.greenColor()
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        if(tableView == self.TableView)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            cell!.textLabel?.text = FontFamilyName[indexPath.row]
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if(tableView == self.TableViewsize)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            cell!.textLabel?.text = fontsize[indexPath.row]
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.adjustsFontSizeToFitWidth = true
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        if(tableView == self.TableView)
        {
            count = FontFamilyName.count
        }
        if(tableView == self.TableViewsize)
        {
            count = fontsize.count
        }
        
        return  count!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(tableView == self.TableView)
        {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
        TableLabel.text = currentCell.textLabel!.text
        }
        if(tableView == self.TableViewsize)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
            TableLabel1.text = currentCell.textLabel!.text
        
        }
    }
    
    
    
    func stepperValueChanged(sender:UIStepper!)
    {
        // println("It Works, Value is --&gt;\(Int(sender.value).description)")
        let currentValue = Int(sender.value)
        myLabel.text =  String(currentValue)
        
        
        if(TextViewArray.count == 1)
        {
            TextViewArray[0].font = TextViewArray[0].font?.fontWithSize(CGFloat(currentValue))
            
        }
        else
        {
            TextViewArray[sentView.tag-1].font =  TextViewArray[sentView.tag-1].font?.fontWithSize(CGFloat(currentValue))
        }
        
        
    }
    
    
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FontFamilyName.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        
        return FontFamilyName[row]
        
    }
    
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // myLabel.text = FontFamilyName[row]
        
        myTextField.text = FontFamilyName[row]
        if(TextViewArray.count == 1)
        {
            TextViewArray[0].font = UIFont(name: FontFamilyName[row],size: 20)
            
        }
        else
        {
            TextViewArray[sentView.tag-1].font =  UIFont(name: FontFamilyName[row],size: 20)
        }
        
        
        
        
        //   TextView.font = UIFont (name: myLabel.text!, size: 30)
        
        
        
    }
    
    
    
    
    
    func flip() {
        
        
        
        let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromRight, .ShowHideTransitionViews]
        
        
        
        UIView.transitionWithView(secondView, duration: 1.0, options: transitionOptions, animations: {
            self.secondView.hidden = false
            }, completion: nil)
        
        UIView.transitionWithView(sentView!, duration: 1.0, options: transitionOptions, animations: {
            // self.sentView!.hidden = true
            self.sentView.backgroundColor = UIColor.clearColor()
            self.sentView.opaque = false
            
            }, completion: nil)
        
        
        
        
        
    }
    
    
    func flipSecond(sender:UIButton) {
        
        
        
        let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromLeft, .ShowHideTransitionViews]
        
        
        UIView.transitionWithView(self.secondView, duration: 1.0, options: transitionOptions, animations: {
            self.secondView.hidden = true
            
            }, completion: nil)
        
        
        
        UIView.transitionWithView(sentView!, duration: 1.0, options: transitionOptions, animations: {
            self.sentView!.hidden = false
            }, completion: nil)
        
        
        
        TextViewArray[sentView.tag-1].hidden = false
        
    }
    
    
    func singleTapped(sender: UITapGestureRecognizer)
    {
        
        if (doubleTap)
        {
            
            
            sender.view?.transform = CGAffineTransformMakeScale(1.5, 1.5)
            sender.view!.contentMode = UIViewContentMode.ScaleAspectFit
            doubleTap = false
        }
        else
        {
            sender.view?.transform = CGAffineTransformMakeScale(1,1)
            doubleTap = true
        }
    }
    
    
    func dragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        let gesturedView = gesture.view
        gesturedView!.center = loc
        
        
        switch gesture.state {
            
        case .Ended :
            for i in 1...StickerArray.count {
                
                if (CGRectIntersectsRect(deleteIcon.frame, StickerArray[i-1].frame))
                {
                    
                    StickerArray[i-1].hidden = true
                    //stackView.hidden = true
                    //stackView.backgroundColor = UIColor.redColor()
                    
                }
            }
            
        default: break
            
        }
        
        
    }
    
    
}


