
import SpriteKit
import GameplayKit
import PlaygroundSupport

public enum Direction : String, CaseIterable, Codable {
    case center, north, northeast, east, southeast, south, southwest, west, northwest
    
    public func positionOfNode(_ node : SKNode, inParentOfSize parentSize: CGSize, withAnchorPoint anchorPoint : CGPoint = CGPoint(x: 0.5, y: 0.5) ) -> CGPoint {
        
        let childPointX : CGFloat
        let childPointY : CGFloat
        let childWidth : CGFloat
        let childHeight : CGFloat
            
        if let isSprite = node as? SKSpriteNode {
            childWidth = isSprite.size.width
            childHeight = isSprite.size.height
            childPointX = -(childWidth / 2) + (childWidth * (1 - isSprite.anchorPoint.x))
            childPointY = -(childHeight / 2) + (childHeight * (1 - isSprite.anchorPoint.y))
        } else {
            childHeight = 0
            childWidth = 0
            childPointX = 0
            childPointY = 0
        }
        
        let parentCentreX = -(parentSize.width / 2) + (parentSize.width * (1 - anchorPoint.x))
        let parentCentreY = -(parentSize.height / 2) + (parentSize.height * (1 - anchorPoint.y))
        
        let finalX =  parentCentreX - childPointX
        let finalY =  parentCentreY - childPointY
        
        let offsetX = ((parentSize.width / 2) - (childWidth / 2))
        let offsetY = ((parentSize.height / 2) - (childHeight / 2))
        
        let point : CGPoint
        switch self {
        case .center:
            point = CGPoint(x: finalX, y: finalY)
        case .north:
            point = CGPoint(x: finalX, y: finalY + offsetY)
        case .northeast:
            point = CGPoint(x: finalX + offsetX, y: finalY + offsetY)
        case .east:
            point = CGPoint(x: finalX + offsetX, y: finalY)
        case .southeast:
            point = CGPoint(x: finalX + offsetX, y: finalY - offsetY)
        case .south:
            point = CGPoint(x: finalX, y: finalY - offsetY)
        case .southwest:
            point = CGPoint(x: finalX - offsetX, y: finalY - offsetY)
        case .west:
            point = CGPoint(x: finalX - offsetX, y: finalY)
        case .northwest:
            point = CGPoint(x: finalX - offsetX, y: finalY + offsetY)
        }
        
        return point
    }
    
}


class GameScene : SKScene {
    
    let redSquare = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 300))
    let label = SKLabelNode(text: "")
    let labelDirection : Direction = .center
    var currentDirection : Direction = .center
    
    override func didMove(to view: SKView) {
        
        self.calculatePositionForSquare()
        self.redSquare.zPosition = 30
        self.addChild(redSquare)
        self.label.verticalAlignmentMode = .bottom
        self.label.fontSize = 16
        self.label.fontColor = .white
        self.label.zPosition = 50
        self.addChild(self.label)
    }
    
    
    func calculatePositionForSquare() {
        if var idx = Direction.allCases.firstIndex(of: self.currentDirection) {
            idx = idx + 1
            if idx == Direction.allCases.count {
                idx = 0
            }
            self.currentDirection = Direction.allCases[idx]
        }
        
        redSquare.position = self.currentDirection.positionOfNode(self.redSquare, inParentOfSize: self.size, withAnchorPoint: self.anchorPoint)
        self.label.position = self.labelDirection.positionOfNode(self.label, inParentOfSize: self.size, withAnchorPoint: self.anchorPoint)
        
        let positonText = String(format: "(%.2f, %.2f)", self.redSquare.position.x, self.redSquare.position.y)
        let anchorPointText = String(format: "(%.2f, %.2f)", self.anchorPoint.x, self.anchorPoint.y)
        
        self.label.text = "Position: \(positonText) and anchorPoint \(self.redSquare.anchorPoint) in scene with anchorPoint \(anchorPointText)"
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else {
            return 
        }
        let randomx = (CGFloat.random(in: 0...1) * 100).rounded(.toNearestOrEven) / 100
        let randomY = (CGFloat.random(in: 0...1) * 1000).rounded(.toNearestOrEven) / 1000
        self.anchorPoint = CGPoint(x: randomx, y: randomY)
        self.calculatePositionForSquare()
    }
}

let view = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 800))
let scene = GameScene(size: view.frame.size)
scene.scaleMode = .aspectFit
view.presentScene(scene)
PlaygroundPage.current.liveView = view
