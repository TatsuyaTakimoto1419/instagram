//
//  PostData.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/03.
//

import UIKit
import Firebase

// firebase から取得、格納

class PostData: NSObject {
  
       var id: String
       var name: String?
       var caption: String?
       var date: Date?
       var likes: [String] = []
       var isLiked: Bool = false
    var comment: [String] = []
    
    
     init(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        
        //コメントをFirebase から取得、格納
        if let comment = postDic["comment"] as? [String]{
            self.comment = comment
        }
        
        //配列を取得
        if let likes = postDic["likes"] as? [String]{
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid{
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            // likes の配列　に　１番初めのindex がある　== not nil
            if self.likes.firstIndex(of: myid) != nil{
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
                
            }
            
        }
        
        
    }
    

}
