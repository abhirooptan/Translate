//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    //var data = NSMutableData()
    var pickOption = ["French", "Turkish", "Gaelic", "Hindi"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField.inputView = pickerView
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
        pickerTextField.text = pickOption[row]
    }
    
    func getLanguage()->String{
        switch(pickerTextField.text){
        case "French"?:
            return "en|fr";
        case "Turkish"?:
            return "en|tr";
        case "Gaelic"?:
            return "en|ga";
        case "Hindi"?:
            return "en|hi";
        default:
            return "en|fr";
        }
    }
    
    @IBAction func translate(sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        //let langStr = ("en|fr").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
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

