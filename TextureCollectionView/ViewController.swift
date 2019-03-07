//
//  ViewController.swift
//  TextureCollectionView
//
//  Created by Amanda Wixted on 3/7/19.
//  Copyright © 2019 Amanda Wixted. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: ASViewController<ASCollectionNode> {

    let flowLayout: UICollectionViewFlowLayout
    let collectionNode: ASCollectionNode

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
        // Do any additional setup after loading the view, typically from a nib.
    }


}

