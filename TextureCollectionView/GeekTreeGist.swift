import AsyncDisplayKit

struct VideoProcessing {
    private static let loadOperation: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        operationQueue.name = "com.VideoFeedController.VideoLoaderOperation"
        operationQueue.qualityOfService = .utility
        return operationQueue
    }()

    private static let playerOperation: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.name = "com.VideoFeedController.VideoPlayerOperation"
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()

    enum QueueScope {
        case play(TimeInterval)
        case load
    }

    static func tasksExecution(_ operation: Operation, scope: QueueScope) {
        switch scope {
        case .play(let time):
            DispatchQueue.global().asyncAfter(deadline: .now() + time, execute: {
                playerOperation.addOperation(operation)
            })
        case .load:
            loadOperation.addOperation(operation)
        }
    }

}

class VideoFeedController: ASViewController<ASTableNode>, ASTableDataSource, ASTableDelegate {

    required init() {
        super.init(node: ASTableNode.init(style: .plain))
        self.node.dataSource = self
        self.node.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return VideoCellNode()
        }
    }

}

class VideoCellNode: ASCellNode {

    let videoNode = ASVideoNode.init()
    private var videoLoadWorker: Operation?
    private var videoPlayerWorker: Operation?

    let url: URL = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8")!

    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.isOpaque = true
        self.videoNode.backgroundColor = .white
        self.videoNode.isOpaque = true
        videoNode.shouldAutorepeat = true
        videoNode.placeholderColor = .gray
    }

    override func didEnterPreloadState() {
        self.autoLoad()
        super.didEnterPreloadState()
    }

    override func didEnterVisibleState() {
        self.autoplay()
        super.didEnterVisibleState()
    }


    func autoLoad(_ priority: Operation.QueuePriority = .normal) {
        guard self.videoNode.assetURL == nil else { return }
        let operation = BlockOperation(block: { [weak self] in
            DispatchQueue.main.sync { }
            guard let `self` = self else {
                fatalError()
            }
            ASPerformBlockOnMainThread {
                self.videoNode.asset = AVAsset(url: self.url)
                guard self.isVisible else { return }
                self.videoNode.play()
            }
        })
        operation.queuePriority = priority
        videoLoadWorker = operation
        VideoProcessing.tasksExecution(operation, scope: .load)
    }

    func autoplay() {
        if self.videoNode.assetURL == nil {
            self.autoLoad(.veryHigh)
            return
        }
        let operation = BlockOperation(block: { [weak self] in
            DispatchQueue.main.sync { }
            ASPerformBlockOnMainThread {
                guard self?.isVisible ?? false else { return }
                self?.videoNode.play()
            }
        })
        self.videoPlayerWorker = operation
        VideoProcessing.tasksExecution(operation, scope: .play(2.0))
    }

    override func didExitVisibleState() {
        videoLoadWorker?.cancel()
        videoPlayerWorker?.cancel()
        super.didExitVisibleState()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let videoRatioLayout = ASRatioLayoutSpec.init(ratio: 0.5, child: videoNode)
        let insets: UIEdgeInsets = .init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        return ASInsetLayoutSpec.init(insets: insets, child: videoRatioLayout)
    }
}
