//
//  ViewController.swift
//  Mapudungun
//
//  Created by Pablo Araya Romero on 8/19/15.
//  Copyright (c) 2015 Pablo Araya Romero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //UI
    @IBOutlet weak var txtWords: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    //VARS
    var from = "spanish";
    var to = "mapudungun";
    
    //CONS
    let PARAM_SPANISH = "spanish";
    let PARAM_MAPUDUNGUN = "mapudungun";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnChange(sender: UIButton) {
        change()
    }
    
    @IBAction func txtWordsEditingChanged(sender: UITextField) {
        call(sender.text)
    }

    func call(word: NSString){
        //validar primero
        if ((from==PARAM_SPANISH || from==PARAM_MAPUDUNGUN) && (to==PARAM_SPANISH || to==PARAM_MAPUDUNGUN) && word != "" ){
            //hago la consulta al servidor
            let url = NSURL(string: "http://mapudungun.org/api?from=\(from)&to=\(to)&word=\(word)")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                //Leo el retorno
                if (!self.validateIfString(data)){
                    let result = self.parseJSON(data)
                    //Pregunto si la respuesta es statusCode 200 para mostrar resultado
                    if (result["statusCode"] as! Int == 200){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.lblResult.text = (result["message"] as! String)
                        });
                    }
                }
            }
            task.resume()
        }
    }
    
    func validateIfString(data: AnyObject) -> Bool {
        if (data as? [String] != nil) {
            return true
        }
        return false
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        
        return boardsDictionary
    }
    
    func change(){
        if (from == "spanish" && to == "mapudungun"){
            //Cambiamos idioma
            from = PARAM_MAPUDUNGUN
            to = PARAM_SPANISH
            //Cambiamos textos de botones
            btnLeft.setTitle("Mapudungun", forState: UIControlState.Normal)
            btnRight.setTitle("Español", forState: UIControlState.Normal)
            
        }else{
            //Cambiamos idioma
            from = PARAM_SPANISH
            to = PARAM_MAPUDUNGUN
            //Cambiamos textos de botones
            btnLeft.setTitle("Español", forState: UIControlState.Normal)
            btnRight.setTitle("Mapudungun", forState: UIControlState.Normal)
        }
        //Volvemos a buscar
        call(txtWords.text)
    }
}

