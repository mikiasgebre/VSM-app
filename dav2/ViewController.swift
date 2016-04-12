import UIKit


class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITableViewDelegate, UITableViewDataSource{
    
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
    var TextViewArray = [UITextView]()
    var TableView = UITableView()
    
    
    
    let scrollView1 = UIScrollView(frame: CGRectMake(0, 700, 300, 300))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonCreateSticker()
        var count = CGFloat(stickerDictionary.count+100)
        count += 10000
        //scrollView.backgroundColor = UIColor.redColor()
        //scrollView.contentSize = view.bounds.size
        scrollView.scrollEnabled = true
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        scrollView.autoresizingMask =  UIViewAutoresizing.FlexibleHeight
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 100, 0, count)
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,1)
        scrollView.contentSize = CGSize(width: 100, height: 100)
        
        scrollView1.scrollEnabled = true
        scrollView1.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        scrollView1.autoresizingMask =  UIViewAutoresizing.FlexibleHeight
        self.scrollView1.contentInset = UIEdgeInsetsMake(0, 100, 0, count)
        scrollView1.contentSize = CGSizeMake(scrollView.contentSize.width,1)
        scrollView1.contentSize = CGSize(width: 100, height: 100)
        
        
        
        scrollView1.backgroundColor = UIColor.yellowColor()
        // scrollView.backgroundColor = UIColor.redColor()
        view.addSubview(scrollView)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        
        
        
        imageView.heightAnchor.constraintEqualToConstant(400).active = true
        imageView.widthAnchor.constraintEqualToConstant(400).active = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    
    
    
    func buttonFlip(sender: UIButton)
    {
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        let buttonGreenColor:UIButton! = UIButton(type: .System)
        let buttonRedColor:UIButton! = UIButton(type: .System)
        
        
        
        
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
        
        
        scrollView.addSubview(secondView)
        secondView.addSubview(buttonRedColor)
        secondView.addSubview(buttonGreenColor)
        secondView.addSubview(buttonOrangeColor)
        secondView.addSubview(buttonFlip1)
        
        let TableLabel: UILabel = UILabel()
        TableLabel.frame = CGRect(x: 130, y: 80, width: 100, height: 30)
        TableLabel.text = "Font Style"
        secondView.addSubview(TableLabel)
        
        
        let TableView: UITableView  =   UITableView()
        TableView.frame = CGRect(x: 130, y: 100, width: 150, height: 150)
        TableView.delegate      =   self
        TableView.dataSource    =   self
        TableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        TableView.backgroundColor = UIColor.clearColor()
        
        
        pickerView = UIPickerView()
        myLabel = UILabel()
        myLabel.frame = CGRectMake(300, 10, 300, 100)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.clearColor()
        self.textField.inputView = pickerView
        pickerView.frame = CGRectMake(20, 100, 300, 100)
        
        
        secondView.addSubview(TableView)
        // secondView.addSubview(pickerView)
        secondView.addSubview(myLabel)
        
        
        
        
        let customStepper = UIStepper(frame:CGRectMake(200, 50, 0, 0))
        customStepper.wraps = true
        customStepper.autorepeat = true
        customStepper.maximumValue = 50
        customStepper.minimumValue = 10
        customStepper.addTarget(self, action: #selector(ViewController.stepperValueChanged(_:)), forControlEvents: .ValueChanged)
        customStepper.backgroundColor = UIColor.clearColor()
        secondView.addSubview(customStepper)
        
        
        
        performSelector(#selector(ViewController.flip), withObject: nil, afterDelay: 0)
        // secondView.hidden = true
        
        
        if(doubleTap)
        {
            TextViewArray[sentView.tag-1].hidden = true
            //doubleTap = false
        }
        
        
        if((sentView.hidden) == true)
        {
            performSelector(#selector(ViewController.flipSecond(_:)), withObject: nil, afterDelay: 0)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = FontFamilyName[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FontFamilyName.count
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
            sender.view?.transform = CGAffineTransformMakeScale(1, 1)
            doubleTap = true
        }
    }
    
    
    
    
    
    func dragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        let gesturedView = gesture.view
        gesturedView!.center = loc
    }
    
}
