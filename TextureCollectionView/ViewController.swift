//
//  ViewController.swift
//  TextureCollectionView
//
//  Created by Amanda Wixted on 3/7/19.
//  Copyright © 2019 Amanda Wixted. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class VideoViewController: ASViewController<ASVideoNode> {

    init(url: String) {
        
        let videoNode = ASVideoNode()
        videoNode.assetURL = URL(string: url)
        videoNode.shouldAutoplay = true
        videoNode.shouldAutorepeat = true
        videoNode.backgroundColor = .blue
        super.init(node: videoNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: ASViewController<ASCollectionNode>, ASCollectionDelegate, ASCollectionDataSource {

    let flowLayout: UICollectionViewFlowLayout
    let collectionNode: ASCollectionNode

    let urls = ["https://res.cloudinary.com/howtoinc/video/upload/s3/832A2BD4-9225-42E5-A9EE-131B7AD9B27C.mp4",
                "https://res.cloudinary.com/howtoinc/video/upload/s3/8C0465B0-065F-4309-BC7C-90755A95CDEF.mp4",
                "https://res.cloudinary.com/howtoinc/video/upload/s3/8F3D8EE6-01A7-4E23-B5F9-0633CE13C251.mp4",
                "https://res.cloudinary.com/howtoinc/video/upload/s3/80239FB2-C9F8-49A8-861E-67EF0F17F5CB.mp4",
                "https://res.cloudinary.com/howtoinc/video/upload/s3/3FE0A80E-3AE2-4E6F-A4EA-702B0C1337D7.mp4",
                "https://res.cloudinary.com/howtoinc/video/upload/s3/2B11F82A-849A-47AC-970A-C892B6A8C1D3.mp4"]

    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.backgroundColor = .green
        super.init(node: collectionNode)

        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionNode.dataSource = self
        collectionNode.delegate = self
    }

    // still choppy
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard (0..<urls.count).contains(indexPath.row) else { return { return ASCellNode() } }

        let url = urls[indexPath.row]
        let size = collectionNode.bounds.size

        return { () -> ASCellNode in
            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
                return VideoViewController(url: url)
            }, didLoad: nil)

            node.style.preferredSize = size
            return node
        }
    }

/*
    // still choppy
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        guard (0..<urls.count).contains(indexPath.row) else { return ASCellNode() }

        let url = urls[indexPath.row]

        let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
            return VideoViewController(url: url)
        }, didLoad: { (displayNode) in
            print("didLoad \(displayNode)")
        })

        node.style.preferredSize = collectionNode.bounds.size
        return node
    }
 */

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

}

