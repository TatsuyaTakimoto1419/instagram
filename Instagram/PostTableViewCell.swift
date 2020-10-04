//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/03.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var CommentButton: UIButton!
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
   
    @IBOutlet weak var captionLabel: UILabel!
    
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var commentText:[String?] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //// PostDataの内容をセルに表示  HomeViewControllerのテーブル表示処理から呼び出される
    func setPostData(_ postData:PostData){
        // 画像の表示
       //ダウンロード中であることを示すインジケーター firebaseUIより
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        //保存場所を指定してダウンロード 
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //画像を表示
        postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        
        // 日時の表示
        self.dateLabel.text = ""
        //日付が空でない時
        if let date = postData.date{
            
            //日付のフォーマット
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
          
            //date (型　Date)をstringに変える
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
            
        }
        // いいね数の表示
        //postDataのlikesの配列の数を表示
        let likeNumber = postData.likes.count
        //int -> string表記
        likeLabel.text = "\(likeNumber)"
        
        
        // いいねボタンの表示
        // (likes の配列　に　１番初めのindex がある時)
        if postData.isLiked {
         
            //ボタンイメージを取得
            let buttonImage = UIImage(named: "like_exist")
            //ボタンのイメージを変える
            self.likeButton.setImage(buttonImage, for: .normal)
            
        }else{
            //// (likes の配列　に　１番初めのindex がない時)
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
            
        }
        
        //コメントを表示
        let LatestComment = postData.comment.last
        
        commentLabel.text = LatestComment
        
        
    }
    
}
