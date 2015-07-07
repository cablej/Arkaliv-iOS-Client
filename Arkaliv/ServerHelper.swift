//
//  ServerHelper.swift
//  Arkaliv
//
//  Created by Jack Cable on 7/3/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit

class ServerHelper: NSObject {
    
    let SIGN_UP_URL = "http://arkaliv2.byethost10.com/SignUp.php"
    let SIGN_IN_URL = "http://arkaliv2.byethost10.com/SignIn.php"
    let GET_LINKS_URL = "http://arkaliv2.byethost10.com/GetLinks.php"
    let GET_LINK_URL = "http://arkaliv2.byethost10.com/GetLink.php"
    let UPLOAD_LINK_URL = "http://arkaliv2.byethost10.com/UploadLink.php"
    let ADD_COMMENT_URL = "http://arkaliv2.byethost10.com/AddComment.php"
    
    func sendRequest(url: String, postString: String, completionHandler : (String) -> ()){
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var responseString = ""
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if(error != nil) {
                print("error=\(error)")
                return
            }
            
            responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            
            //print(responseString)
            
            completionHandler(responseString)
            
        }
        
        task?.resume()
    }
    
    func saveUserInformation(information: String) {
        if let json = stringToJSON(information) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            let key = json["key"].stringValue
            
            let username = json["username"].stringValue
            
            userDefaults.setObject(key, forKey: "key")
            userDefaults.setObject(username, forKey: "username")
        }
    }
    
    func linkObjectFromJSON(json: JSON) -> Link {
        return Link(newProperties: propertiesFromJSON(json))
    }
    
    func commentObjectFromJSON(json: JSON) -> Comment {
        return Comment(newProperties: propertiesFromJSON(json))
    }
    
    
    func propertiesFromJSON(json: JSON) -> Dictionary<String, String> {
        var properties = Dictionary<String, String>()
        
        for (key, object) in json {
            properties[key] = object.stringValue
        }
        
        return properties
    }
    
    func stringToJSON(string: String) -> JSON? {
        let jsonObject : AnyObject?
        
        let json : JSON
        
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(string.dataUsingEncoding(NSUTF8StringEncoding)!,
                options: NSJSONReadingOptions.AllowFragments)
            json = JSON(jsonObject!)
            
            return json
            
            
        } catch {
            
        }
        return nil;
    }
    
    func getKey() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let key = userDefaults.objectForKey("key") as? String
        return key == "" ? nil : key
    }
    
    func getUsername() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username = userDefaults.objectForKey("username") as? String
        return username == "" ? nil : username
    }
    
    func error(response: String) -> String? {
        if let json = stringToJSON(response) {
            let error = json["error"].stringValue
            
            if(error != "") {
                return error
            }
        }
        return nil
    }

}
