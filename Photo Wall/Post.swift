//
//  Post.swift
//  Myinsta
//
//  Created by Nanxin Jin on 3/19/17.
//  Copyright © 2017 Nanxin Jin. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        //Create object
        let post = PFObject(className: "Post")
        
        post["media"] = getPFFileFromImage(image)
        post["author"] = PFUser.current()
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        post.saveInBackground(block: completion)
    }
    
    class func getPFFileFromImage(_ image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
