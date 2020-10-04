//
//  PostViewController.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/02.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
  //
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
     // 投稿ボタンをタップしたときに呼ばれるメソッド
   @IBAction func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する
        let imageData = image.jpegData(compressionQuality: 0.75)
   
    //投稿データ用　データの保存場所を定義する               Const.swiftに繋がってる
    let postRef = Firestore.firestore().collection(Const.PostPath).document()
    //画像データ用　データの保存場所を定義する    firebase のstorageに保存する設定  　 Const.swift に繋がってる
    let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
    
    // HUDで投稿処理中の表示を開始
    SVProgressHUD.show()
    
    // Storageに画像をアップロードする
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    imageRef.putData(imageData!, metadata: metadata){(metadata, error)in
        //error　アップロード
        if error != nil{
            // 画像のアップロード失敗
            print(error!)
            SVProgressHUD.showInfo(withStatus: "画像のアップロードが失敗しました")
            // 投稿処理をキャンセルし、先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }//end of error
        
        
        //成功　アップロード
        // FireStoreに投稿データを保存する
     let name = Auth.auth().currentUser?.displayName
        let postDic = [
            "name" : name!,
            //キャプションのテキスト
            "caption": self.textField.text!,
            //サーバーから時間をとる
            "date": FieldValue.serverTimestamp(),
        ] as [String:Any]
        
       //setData ドキュメント新規に作成
        postRef.setData(postDic)
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        // 投稿処理が完了したので先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }

    
    
    
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
