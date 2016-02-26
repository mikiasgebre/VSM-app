import UIKit

class ViewController: UIViewController {
    
    
    var xposition : CGFloat = 10.0
    var yposition : CGFloat = 10.0
    var stickerDictionary = [String: UIView]()
    let buttonOrangeColor:UIButton! = UIButton(type: .System)
    let buttonGreenColor:UIButton! = UIButton(type: .System)
    let buttonRedColor:UIButton! = UIButton(type: .System)
    let buttonDelete:UIButton! = UIButton(type: .System)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonCreateSticker()
        
        
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
        sentView?.tintColor = UIColor.orangeColor()
    }
    
    
    func buttonGreenColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.tintColor = UIColor.greenColor()
    }
    
    
    func buttonRedColorPressed(sender: UIButton!){
        let sentView = sender.superview
        sentView?.tintColor = UIColor.redColor()
        
    }
    
    func buttonDeletePressed(sender: UIButton!){
        let sentView = sender.superview
        let tag = sentView?.tag
        let stickerName = "Sticker Number "+String(tag)
        stickerDictionary.removeValueForKey(stickerName)
        sentView?.hidden = true
    }
    
    
    
    
    func makeSticker(stickerLabel: String, stickerNumber: Int){
        
        let imageView = UIImageView(image: UIImage(named: "stickynote")!)
        imageView.image = imageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = UIColor.yellowColor()
       // imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        
        xposition += 40.0
        yposition += 40.0
        
        imageView.frame = CGRectMake(xposition, yposition, 300, 200 )
        view.tag = stickerNumber
        imageView.layer.cornerRadius = 6
        imageView.tag = stickerNumber
        view.addSubview(imageView)
        
        let layer = imageView.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        imageView.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        imageView.userInteractionEnabled = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: ("doubleTapped:"))
        tap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tap)
        
        
        
        let textLabel = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.font = UIFont.italicSystemFontOfSize(8)
        textLabel.textColor = UIColor.blackColor()
        textLabel.text = stickerLabel
        
        let textField = UITextView(frame: CGRectMake(35.0, 19.0, 200.0, 160.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(15)
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        
        
        
        buttonOrangeColor.frame = CGRectMake(50, 160, 40, 28.0)
        buttonOrangeColor.layer.cornerRadius = 3
        buttonOrangeColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOrangeColor.layer.cornerRadius = 0.5 * buttonOrangeColor.bounds.size.width
        buttonOrangeColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOrangeColor.backgroundColor = UIColor.orangeColor()
        buttonOrangeColor.setTitle("Orange", forState: UIControlState.Normal)
        buttonOrangeColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOrangeColor.addTarget(self, action: "buttonOrangeColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        buttonGreenColor.frame = CGRectMake(110, 160, 40, 28.0)
        buttonGreenColor.layer.cornerRadius = 3
        buttonGreenColor.tag = 1
        buttonGreenColor.backgroundColor = UIColor.greenColor()
        buttonGreenColor.layer.cornerRadius = 0.5 * buttonGreenColor.bounds.size.width
        buttonGreenColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonGreenColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonGreenColor.setTitle("Green", forState: UIControlState.Normal)
        buttonGreenColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonGreenColor.addTarget(self, action: "buttonGreenColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        buttonRedColor.frame = CGRectMake(170, 160, 40, 28.0)
        buttonRedColor.layer.cornerRadius = 3
        buttonRedColor.backgroundColor = UIColor.redColor()
        buttonRedColor.layer.cornerRadius = 0.5 * buttonRedColor.bounds.size.width
        buttonRedColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonRedColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonRedColor.setTitle("Red", forState: UIControlState.Normal)
        buttonRedColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRedColor.addTarget(self, action: "buttonRedColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        buttonDelete.frame = CGRectMake(230, 160, 40, 28.0)
        buttonDelete.layer.cornerRadius = 3
        buttonDelete.backgroundColor = UIColor.brownColor()
        buttonDelete.layer.cornerRadius = 0.5 * buttonDelete.bounds.size.width
        buttonDelete.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonDelete.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonDelete.setTitle("Delete", forState: UIControlState.Normal)
        buttonDelete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonDelete.addTarget(self, action: "buttonDeletePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        imageView.addSubview(textLabel)
        imageView.addSubview(textField)
        
        stickerDictionary[stickerLabel] = imageView
        
        self.view.addSubview(imageView)
        
        
    }
    
    func doubleTapped(sender : UITapGestureRecognizer)
    {
        sender.view?.addSubview(buttonGreenColor)
        sender.view?.addSubview(buttonOrangeColor)
        sender.view?.addSubview(buttonRedColor)
        sender.view?.addSubview(buttonDelete)
    }
    
    
    func dragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        let gesturedView = gesture.view
        gesturedView!.center = loc
    }
    
}
