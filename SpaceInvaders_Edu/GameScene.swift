//
//  GameScene.swift
//  SpaceInvaders_Edu
//
//  Created by Alumne on 22/4/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let lowerMargin: CGFloat = 80
    /*lazy var verticalPosition: CGFloat = {
        let maxSize = -(self.size.height / 2)
        
    }*/
    
    let enemySize = CGSize(width: 35, height: 35)
    let enemySpace = 15.0
    
    private var spriteNode: SKSpriteNode!
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        (0...5).forEach { row in
            (0...9).forEach { col in
                generateEnemyAt(row: row, col: col)
            }
        }
        
    }
    
    func generateEnemyAt(row: Int, col: Int) {
        let n = Int(row % 3)
        let imageName = "enemy_\(n)_"
        let enemy = SKSpriteNode(imageNamed: imageName + "0")
        enemy.name = "Enemy_\(row)_\(col)"
        enemy.size = enemySize
        
        let moveAction = SKAction.sequence([
            SKAction.run { enemy.texture = SKTexture(imageNamed: imageName + "0") },
            SKAction.wait(forDuration: 0.5),
            SKAction.run { enemy.texture = SKTexture(imageNamed: imageName + "1") },
            SKAction.wait(forDuration: 0.5)
        ])
        
        enemy.run(SKAction.repeatForever(moveAction))
        
        enemy.position = CGPoint(x: -(self.size.width / 2.5) + CGFloat(col) * (enemySize.width + enemySpace) + 2 * enemySpace,
                                 y: (self.size.height / 2.5) - CGFloat(row) * (enemySize.width + enemySpace))
        
        self.addChild(enemy)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let enemyList = self.children.filter { $0.name?.split(separator: "_").first == "enemy" }
        enemyList.forEach { enemy in
            
            enemy.position.x = enemy.position.x + (self.enemySize.width + self.enemySpace) * currentTime
            
        }
    }
}
