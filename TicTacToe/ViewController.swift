//
//  ViewController.swift
//  TicTacToe
//
//  Created by Boran Liu on 2/25/16.
//  Copyright © 2016 Boran Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // flag that determines if game is terminated or not
    var isDone = false
    // winning side(1 is player, -1 is AI)
    var whoWins = 0
    // A list that stores gamestate
    var gameState = [0,0,0,0,0,0,0,0,0]
    // flag that determines if game starts or not
    var startGame = false

    @IBOutlet var aiFirst: UIButton!
    
    @IBOutlet var playerFirst: UIButton!
    
    @IBAction func decideTurn(sender: UIButton) {
        playerFirst.hidden = true
        aiFirst.hidden = true
        startGame = true
        if (sender.tag == 10){
        } else {
            aiPlay()
        }
    }
    
    // reset button
    @IBOutlet var reset: UIButton!
    
    // enable reset when game is terminated
    @IBAction func resetEnabled(sender: UIButton) {
        reset.hidden = true
        winMessage.hidden = true
        playerFirst.hidden = false
        aiFirst.hidden = false
        startGame = false
        gameState = [0,0,0,0,0,0,0,0,0]
        whoWins = 0
        isDone = false
        var place:UIButton
        for(var i = 1; i < 10; i++) {
            place = self.view.viewWithTag(i) as! UIButton
            place.setImage(nil, forState: .Normal)
        }
    }
    
    // message label that will be displayed when game is terminated
    @IBOutlet var winMessage: UILabel!
    
    // Places on board to place cross or circle
    @IBOutlet var button: UIButton!
    
    // Perform actions when a place is clicked
    @IBAction func buttonClicked(sender: UIButton) {
        var pieceImage = UIImage()
        // check if the game is not terminated or there is available moves
        if(startGame) {
            if(!isDone && gameState[sender.tag - 1] == 0) {
                gameState[sender.tag - 1] = 1
                pieceImage = UIImage(named: "circle.png")!
                sender.setImage(pieceImage, forState: .Normal)
            }
        
            testWinningState()
        
            if isDone{
                resultAndReset()
            
            // else: AI's move if game is not terminated
            }else {
                aiPlay()
                testWinningState()
                if isDone{
                    resultAndReset()
                }
            }
        }
    }
    
    // checking if the game is terminated by checking all winning conditions and the possibility of a draw
    func testWinningState() {
        
        // all possible winning conditions
        let winningLists = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8],[0,4,8], [2,4,6]]
        // checking all winning conditions
        for winCondition in winningLists {
            if (gameState[winCondition[0]] != 0 && gameState[winCondition[0]] == gameState[winCondition[1]] && gameState[winCondition[1]] == gameState[winCondition[2]]) {
                isDone = true
                whoWins = gameState[winCondition[0]]
                return;
            }
        }
        
        // check for a draw by checking if all places have been taken
        var i = 0
        for(; i < 9; i++) {
            if (gameState[i] == 0) {
                break;
            }
        }
        if(i == 9){
            isDone = true
        }
        
    }
    
    // Randomize ai's next move and return the button tag number if will play
    func aiNextMove() -> Int {
        var available = [Int]()
        for (var i = 0; i < gameState.count; i++) {
            if(gameState[i] == 0){
                available.append(i+1)
            }
        }
        let randomIndex = Int(arc4random_uniform(UInt32(available.count)))
        return available[randomIndex]
    }
    
    // AI playing its move
    func aiPlay() {
        var aiChoice = aiNextMove()
        gameState[aiChoice - 1] = -1
        var pieceImage = UIImage(named: "cross.jpg")!
        var aiPiece = self.view.viewWithTag(aiChoice) as! UIButton
        aiPiece.setImage(pieceImage, forState: .Normal)
    }
    
    // game end by showing result and reset button for re-play
    func resultAndReset() {
        winMessage.hidden = false
        reset.hidden = false
        if(whoWins == 1){
            winMessage.text = "You win!"
        } else if whoWins == -1 {
            winMessage.text = "You lose!"
        } else {
            winMessage.text = "Tie!"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        winMessage.hidden = true
        reset.hidden = true
        playerFirst.hidden = false
        aiFirst.hidden = false

    }
    
    // For simplicity disable rotation for the game
    // Reference: http://stackoverflow.com/questions/25651969/setting-device-orientation-in-swift-ios
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

