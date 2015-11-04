//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var translatedText: UITextView!
    
    @IBOutlet weak var pickerFromTextField: UITextField!
    @IBOutlet weak var pickerToTextField: UITextField!
    
    var pickOption = ["English" ,"French", "Turkish", "Gaelic", "Hindi"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromPickerView = UIPickerView()
        let toPickerView = UIPickerView()
        // setting the tags for multiple PickerView selection
        fromPickerView.tag = 0
        toPickerView.tag = 1
        fromPickerView.delegate = self
        toPickerView.delegate = self
        pickerFromTextField.inputView = fromPickerView
        pickerToTextField.inputView = toPickerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // selection through different PickerView tags
        if(pickerView.tag == 0){
            pickerFromTextField.text = pickOption[row]
        }
        else{
            pickerToTextField.text = pickOption[row]
        }
    }
    
    func getLanguage()->String{
        var to:String
        var from:String
        switch(pickerFromTextField.text){
        case "English"?:
            from = "en"
        case "French"?:
            from = "fr"
        case "Turkish"?:
            from = "tr"
        case "Gaelic"?:
            from = "ga"
        case "Hindi"?:
            from = "hi"
        default:
            from = "en"
        }
        
        switch(pickerToTextField.text){
        case "English"?:
            to = "en"
        case "French"?:
            to = "fr"
        case "Turkish"?:
            to = "tr"
        case "Gaelic"?:
            to = "ga"
        case "Hindi"?:
            to = "hi"
        default:
            to = "fr"
        }
        
        var fromTo = from+"|"+to
        return fromTo
    }
    
    @IBAction func translate(sender: AnyObject) {
        
        // error check for same language selection
        if(getLanguage() == "en|en" || getLanguage() == "fr|fr" || getLanguage() == "tr|tr" || getLanguage() == "ga|ga" || getLanguage() == "hi|hi"){
            let alertController = UIAlertController(title: "Warning", message: "Please select two different languages", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Got it?", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let str = textToTranslate.text
            let escapedStr = str!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
            let langStr = (getLanguage()).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
            let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
            let url = NSURL(string: urlStr)
        
            let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData()
        
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.startAnimating()
        
            var result = "<Translation Error>"
        
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
                indicator.stopAnimating()
            
                if let httpResponse = response as? NSHTTPURLResponse {
                    if(httpResponse.statusCode == 200){
                    
                        let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                        if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                            let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                            result = responseData.objectForKey("translatedText") as! String
                        }
                    }
                
                    self.translatedText.text = result
                }
            }
        }

    }
}

