//
//  PostCollectionViewCell.swift
//  TalkShop
//
//  Created by Samarth on 23/03/24.
//

import UIKit
import SDWebImage

class PostCollectionViewCell: UICollectionViewCell, HighlightFeedback {

    @IBOutlet weak var postThumbnailImageView: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            scaleDownFeedback(highlighted: isHighlighted, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(post: Post) {
        self.postThumbnailImageView.image = nil
        self.postThumbnailImageView.sd_setImage(with: post.video.thumbnailUrl, placeholderImage: nil)
    }
}
