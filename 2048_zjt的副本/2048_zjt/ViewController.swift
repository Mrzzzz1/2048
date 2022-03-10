//
//  ViewController.swift
//  2048_zjt
//
//  Created by 张金涛 on 2022/1/16.
//

import UIKit

class ViewController: UIViewController,gameViewDelegate,successViewDelegate {
    func failure() {
        self.view.addSubview(EndView)
        EndView.endLabel.text="Defeat! Your score is \(mask) !"
        EndView.setUpView()
        
    }
    
    func success() {
        self.view.addSubview(EndView)
        EndView.endLabel.text="Victory! Your score is \(mask) !"
        EndView.setUpView()
        
    }
    
   @objc func playAgain() {
        Game.Arr=Game.emptyArr()
        GameView.removeAll()
        mask=0
        maskLabel.text="score:\(mask)"
        startGame()
    }
    
    func slideEnded(offset: CGPoint) {
        let direction:direction
        
        if offset.y>offset.x{
            if offset.y > -offset.x{
                direction = .up
            }
            else {
                direction = .right}
        }
        else {
            if offset.y > -offset.x{
                direction = .left
            }else{
                direction = .down           }
        }
        Game.move(direction: direction){
            (action) in GameView.performActions(action)
        }
    }
    
   private lazy var Game=game()
    lazy var GameView=gameView()
    lazy var EndView=endView()
    var restartButton=UIButton()
    var maskLabel=UILabel()
    var mask=0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(GameView)
        GameView.setUpView()
        GameView.delegate=self
        EndView.delegate=self
        view.addSubview(maskLabel)
        setUpMaskLabel()
        view.addSubview(restartButton)
        setUpRestartButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)){
            self.startGame()
            //self.success()
        }
    }
    private func startGame(){
        self.Game.start {
            (startCards) in
            self.GameView.performActions(startCards)
        }
    }
    func setUpMaskLabel(){
        maskLabel.translatesAutoresizingMaskIntoConstraints=false
        maskLabel.bottomAnchor.constraint(equalTo: GameView.topAnchor).isActive=true
        maskLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive=true
        maskLabel.heightAnchor.constraint(equalToConstant:  40).isActive=true
        maskLabel.textColor = .black
        maskLabel.font=UIFont.boldSystemFont(ofSize: 20)
        maskLabel.text="得分:\(mask)"
        
        
    }
    func changeMask(value:Int){
        mask+=value
        maskLabel.text="score:\(mask)"
    }
    func setUpRestartButton(){
        restartButton.translatesAutoresizingMaskIntoConstraints=false
        restartButton.bottomAnchor.constraint(equalTo: maskLabel.topAnchor).isActive=true
        restartButton.backgroundColor = .white
        restartButton.trailingAnchor.constraint(equalTo: maskLabel.trailingAnchor).isActive=true
        restartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        restartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        restartButton.setTitle("restart", for: .normal)
        restartButton.setTitleColor( .red, for: .normal)
        restartButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        
    }
}

