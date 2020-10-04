//
//  CommentViewController.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/04.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    @IBOutlet weak var CommentTextField: UITextField!
    
    @IBOutlet weak var backButoon: UIButton!
    
    //PostDataを受け取る
    var postdata : PostData!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        //TextField からText取得
        var commentText:String?
        commentText = CommentTextField.text!
        
        commentText = (Auth.auth().currentUser?.displayName!)! + ":" + commentText!
        
       var updateValue:FieldValue
        
        // 今回新たにいいねを押した場合は、commentidを追加する更新データを作成
        updateValue = FieldValue.arrayUnion([commentText!])
        
        
        //アップデートする
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postdata.id)
        postRef.updateData(["comment":updateValue])
        
       
        
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
