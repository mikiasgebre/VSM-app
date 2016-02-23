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
        //sentView?.backgroundColor = UIColor.orangeColor()
        sentView?.tintColor = UIColor.orangeColor()
    }
    
    
    func buttonGreenColorPressed(sender: UIButton!){
        let sentView = sender.superview
        //sentView?.backgroundColor = UIColor.greenColor()
        sentView?.tintColor = UIColor.greenColor()
    }
    
    
    func buttonRedColorPressed(sender: UIButton!){
        let sentView = sender.superview
        //sentView?.backgroundColor = UIColor.redColor()
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
        
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        //let view = UIView()
        //view.frame = CGRectMake(30, 50, 200, 120)
        imageView.frame = CGRectMake(30, 50, 300, 200 )
        // view.layer.cornerRadius = 6
        view.tag = stickerNumber
        imageView.layer.cornerRadius = 6
        imageView.tag = stickerNumber
        view.addSubview(imageView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        //view.addGestureRecognizer(gesture)
        imageView.addGestureRecognizer(gesture)
        view.userInteractionEnabled = true
        imageView.userInteractionEnabled = true
        
        
        
        
        func awakeFromNib()
        {
            let tap = UITapGestureRecognizer(target: self, action: ("doubleTapped:"))
            tap.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(tap)
            
        }
        
        
        let textLabel = UITextField(frame: CGRectMake(2.0, 1.0, 200.0, 8.0))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.font = UIFont.italicSystemFontOfSize(8)
        textLabel.textColor = UIColor.blackColor()
        textLabel.text = stickerLabel
        
        let textField = UITextView(frame: CGRectMake(35.0, 19.0, 200.0, 160.0))
        textField.textAlignment = NSTextAlignment.Justified
        textField.textColor = UIColor.blackColor()
        textField.font = UIFont.boldSystemFontOfSize(15)
        // textField.borderStyle = UITextBorderStyle.Line
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
        textField.backgroundColor = UIColor.clearColor()
        //textField.borderStyle = UITextBorderStyle.None
        
        let buttonOrangeColor:UIButton! = UIButton(type: .System)
        buttonOrangeColor.frame = CGRectMake(50, 160, 40, 28.0)
        
        buttonOrangeColor.layer.cornerRadius = 3
        buttonOrangeColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonOrangeColor.layer.cornerRadius = 0.5 * buttonOrangeColor.bounds.size.width
        buttonOrangeColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonOrangeColor.backgroundColor = UIColor.orangeColor()
        buttonOrangeColor.setTitle("Orange", forState: UIControlState.Normal)
        buttonOrangeColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonOrangeColor.addTarget(self, action: "buttonOrangeColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let buttonGreenColor:UIButton! = UIButton(type: .System)
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
        
        
        
        
        
        let buttonRedColor:UIButton! = UIButton(type: .System)
        buttonRedColor.frame = CGRectMake(170, 160, 40, 28.0)
        buttonRedColor.layer.cornerRadius = 3
        buttonRedColor.backgroundColor = UIColor.redColor()
        buttonRedColor.layer.cornerRadius = 0.5 * buttonRedColor.bounds.size.width
        buttonRedColor.titleLabel?.font = UIFont.italicSystemFontOfSize(8)
        buttonRedColor.titleLabel?.textAlignment = NSTextAlignment.Center
        buttonRedColor.setTitle("Red", forState: UIControlState.Normal)
        buttonRedColor.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonRedColor.addTarget(self, action: "buttonRedColorPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let buttonDelete:UIButton! = UIButton(type: .System)
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
        
        
        
        imageView.addSubview(buttonGreenColor)
        imageView.addSubview(buttonOrangeColor)
        imageView.addSubview(buttonRedColor)
        imageView.addSubview(buttonDelete)
        
        
        func doubleTapped(gesture : UITapGestureRecognizer)
        {
            print("Hello")
            
        }
        /*
        view.addSubview(textLabel)
        view.addSubview(textField)
        view.addSubview(buttonOrangeColor)
        view.addSubview(buttonGreenColor)
        view.addSubview(buttonBlueColor)
        view.addSubview(buttonDelete)
        */
        
        
        stickerDictionary[stickerLabel] = imageView
        
        //self.view.addSubview(view)
        self.view.addSubview(imageView)
        
        
    }
    
    
    
    
    
    
    func dragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.locationInView(self.view)
        let gesturedView = gesture.view
        
        gesturedView!.center = loc
    }
    
}
