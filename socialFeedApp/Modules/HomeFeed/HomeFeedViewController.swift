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
import NVActivityIndicatorView

class HomeFeedViewController: UITableViewController, HomeFeedViewProtocol{
    
    // MARK: - Outlets
    
    
    
    // MARK: - Properties
    internal var presenter: HomeFeedPresenterProtocol!
    private let disposeBag = DisposeBag()
    private var posts: Observable<[Post]>!
    
    private var postArray = [Post](){
        didSet{
            bindTableView()
            self.tableView.reloadData()
        }
    }
    
    lazy var rowHeights:[Int:CGFloat] = [:]
    
    var currentIndex = 1
    
    var recentlyUpdated = false
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home Feed"
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.tableView.reloadData()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    
    
    // MARK: - Helpers
    func configureView(){
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        
        presenter.showSocialPosts(index: currentIndex)
    }
    
    @objc func refresh(sender:AnyObject){
        // Updating your data here...
        if currentIndex > 1 {
            currentIndex -= 1
            let indexPath = IndexPath(row: postArray.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            self.recentlyUpdated = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.recentlyUpdated = false
            }
        }
        presenter.showSocialPosts(index: currentIndex)
    }
    

    func bindTableView(){
        tableView.dataSource = nil
        self.posts = Observable.just(postArray)
        self.posts.bind(to: tableView.rx.items(cellIdentifier: "HomeFeedCell")) {[weak self] (row, post, cell) in
            if let currentCell = cell as? HomeFeedTableViewCell {
                self?.setupCell(currentCell: currentCell, post: post, row: row)
            }
        }.disposed(by: disposeBag)
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
        if !(post.text?.isEmpty ?? true) {
            currentCell.postTextView.text = post.text
        }
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
                .transition(.fade(5)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                
                let aspectRatio = size.width/size.height
                
                let imageSize = (currentCell.postImage.frame.size.width) / (currentCell.postImage.image?.size.width ?? 32) * (currentCell.postImage.image?.size.height ?? 32)
                
                currentCell.postImageHeight.constant = imageSize
                
                self.rowHeights[row] = (imageSize + (100/aspectRatio)) * aspectRatio
                if aspectRatio == 1 {
                    self.rowHeights[row]! += (currentCell.postImage.image?.size.width ?? 100) - (100/aspectRatio)
                }
            case .failure(let error):
                self.rowHeights[row] = 333
                currentCell.postImageHeight.constant = 125
            }
        }

    }
    
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.postArray[indexPath.row].link ?? "https://google.com") else { return }
        UIApplication.shared.open(url)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.rowHeights[indexPath.row]{
            return height
        } else {
            return 333
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard self.postArray.count > 5 else { return }

        if indexPath.row == self.postArray.count - 1 && !NVActivityIndicatorPresenter.sharedInstance.isAnimating && !self.recentlyUpdated{
            currentIndex += 1
            presenter.showSocialPosts(index: currentIndex)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
            let indexPath = IndexPath(row: 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        
    }

    // MARK: - Handle Presenter Output
    func handlePresenterOutput(_ output: HomeFeedPresenterOutput) {
        switch output {
        case .showSocialPosts(let postArray):
            self.postArray = postArray
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tableView.reloadData()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    
}
