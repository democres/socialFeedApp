//
//  HomeFeedViewController.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeFeedViewController: UITableViewController, HomeFeedViewProtocol{
    
    // MARK: - Outlets
    
    
    
    // MARK: - Properties
    internal var presenter: HomeFeedPresenterProtocol!
    private let disposeBag = DisposeBag()
    private var posts: Observable<[Post]>!
    
    private var postArray = [Post](){
        didSet{
            bindTableView()
        }
    }
    
     var rowHeights:[Int:CGFloat] = [:]
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Helpers
    func configureView(){
        tableView.dataSource = nil
        presenter.showSocialPosts()
    }

    func bindTableView(){
        self.tableView.reloadData()
        self.posts = Observable.just(postArray)
        self.posts.bind(to: tableView.rx.items(cellIdentifier: "HomeFeedCell")) { (row, post, cell) in
            if let currentCell = cell as? HomeFeedTableViewCell {
                self.setupCell(currentCell: currentCell, post: post, row: row)
            }
        }.addDisposableTo(disposeBag)
    }
    
    func setupCell(currentCell: HomeFeedTableViewCell, post: Post, row: Int){
        
        //USER AVATAR
        let avatarURL = URL(string: post.author?.pictureLink ?? "https://pbs.twimg.com/media/D9QyPw_XoAAN-p6.jpg")
        currentCell.authorPictureImg.kf.setImage(with: avatarURL, placeholder: UIImage(named: "avatar"))
        
        //SOCIAL ICON
        switch post.network {
            case "twitter":
                currentCell.socialNetworkIcon.image = UIImage(named: "twitter")
            case "facebook":
                currentCell.socialNetworkIcon.image = UIImage(named: "facebook")
            case .none:
                break
            case .some(_):
                break
        }
        currentCell.socialNetworkIcon.contentMode = .scaleAspectFit
        
        setupPostImage(currentCell: currentCell, url: URL(string: post.attachmentPictureLink ?? "https://pbs.twimg.com/media/D_Hheh5WsAE_81H.jpg")!, size: CGSize(width: post.attachmentWidth, height: post.attachmentHeight), row: row)
        
        
        //TEXT INFO
        currentCell.dateLbl.text = post.date
        currentCell.postTextView.text = post.text
        currentCell.authorNameLbl.text = post.author?.name
        currentCell.authorNickLbl.text = "@\(post.author?.account ?? "user459")"
        
    }
    
    
    func setupPostImage(currentCell: HomeFeedTableViewCell, url: URL, size: CGSize, row: Int){
        
        let processor = DownsamplingImageProcessor(size: size)
        currentCell.postImage.kf.indicatorType = .activity
        currentCell.postImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                let aspectRatio = size.width/size.height
                let imageHeight = self.view.frame.width * aspectRatio
                self.rowHeights[row] = imageHeight
            case .failure(let error):
                self.rowHeights[row] = 333
            }
        }

    }
    
    
    
    // MARK: - Handle Presenter Output
    func handlePresenterOutput(_ output: HomeFeedPresenterOutput) {
        switch output {
        case .showSocialPosts(let postArray):
            self.postArray = postArray
        }
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.rowHeights[indexPath.row]{
            return height
        }else{
            return 333
        }
    }
    
}
