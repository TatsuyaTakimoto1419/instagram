//
//  HomeViewController.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/02.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    // Firestoreのリスナー


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録する
        //xibファイルを読み込み
     let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    
    
    
 

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil{
                // listener未登録なら、登録してスナップショットを受信す
              //  ドキュメントを投稿日時の新しい順に取得
                let postsRef =  Firestore.firestore().collection(Const.PostPath).order(by: "date",descending: true)
               // ドキュメントを addSnapshotListenerメソッドで監視
                listener = postsRef.addSnapshotListener() { (querySnapshot, error)in
                    
                    //snapshot取得 エラー
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                      return
                    }
                    
                    
                    //snapshot 取得　成功
                    //取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。

                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                        
                    }
                    
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
                
        }else{
                // ログイン未(またはログアウト済み)
               
               if listener != nil{
                   // listener登録済みなら削除してpostArrayをクリアする
                   listener.remove()
                   listener = nil
                   postArray = []
              
               }
        }
       
        tableView.reloadData()
        
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //xib のいいねボタンaction
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //xibで　コメントボタン　action
        cell.CommentButton.addTarget(self, action: #selector(doComment(_:forEvent:)), for: .touchUpInside)
    
        
        return cell
    }
   
    
     //xib セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender:UIButton, forEvent event:UIEvent){
        print("DEBUG_PRINT: likeボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid{
            // 更新データを作成する

            var updateValue :FieldValue
           
           // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
            if postData.isLiked{
                
                updateValue = FieldValue.arrayRemove([myid])
                
            }else{
                //myid がない場合　＝＝　いいねがない　、
                //myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
        
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            
            //firebase にデータのアップデート
            postRef.updateData(["likes":updateValue])
        
        
        }
        
    }
    
    
    @objc func doComment(_ sender:UIButton, forEvent event:UIEvent){
        print("DEBUG_PRINT: Commentボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        
       
        
        
        //CommenViewControllerに画面遷移　モーデル
        let CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment")as! CommentViewController
        
       
        //CommentViewControllerに値を送る
        CommentViewController.postdata = postData
        
        self.present(CommentViewController, animated: true, completion: nil)
        
    }

}
