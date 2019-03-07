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

    let urls = ["hey"]

    init() {
        flowLayout = UICollectionViewFlowLayout()
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

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

}

