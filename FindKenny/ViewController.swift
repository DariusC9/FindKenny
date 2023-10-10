//
//  ViewController.swift
//  FindKenny
//
//  Created by Darius Couti on 10.10.2023.
//

import UIKit

class ViewController: UIViewController {
    // UI elements
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    private let kenny = UIImageView(image: UIImage(named: "kenny"))
    // variables
    private var timer = Timer()
    private var count = 10
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startGame()
    }

    private func startGame() {
        setupViews()
        setupImage()
        startTimer()
    }
    
    private func setupViews() {
        timerLabel.text = "\(10)"
        highScoreLabel.text = UserDefaults.standard.object(forKey: "highScore") as? Int == nil ? "Highscore: 0" : "Highscore: \( UserDefaults.standard.object(forKey: "highScore") as! Int)"
    }
    
    private func setupImage() {
        kenny.translatesAutoresizingMaskIntoConstraints = false
        kenny.contentMode = .scaleAspectFit
        kenny.isUserInteractionEnabled = true
        addTapGestureToImage()
        // things to improve: try make viewHeights and viewWidth as file variables
        let viewHeight = containerView.bounds.height
        let viewWidth = containerView.bounds.width
        
        containerView.addSubview(kenny)
        NSLayoutConstraint.activate([
            kenny.heightAnchor.constraint(equalToConstant: 200),
            kenny.widthAnchor.constraint(equalToConstant: 200),
            kenny.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat(Int.random(in: 0...Int(viewHeight - 200)))),
            kenny.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CGFloat(Int.random(in: 0...Int(viewWidth - 200))))
        ])
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerIsOn), userInfo: nil, repeats: true)
    }
    
    @objc func timerIsOn() {
        count -= 1
        timerLabel.text = "\(count)"
        // change kenny position every second
        resetKennyPosition()
        
        if count == 0 {
            checkForHighScoreAndSaveIt()
            reset()
            showAlert()
        }
    }
    
    private func addTapGestureToImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        kenny.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {
        score += 1
        currentScoreLabel.text = "Score: \(score)"
        // also change kenny position when user tapps it
        resetKennyPosition()
    }
    
    private func resetKennyPosition() {
        // with removeFromSuperView method you are able to reset the constraints and set new ones
        kenny.removeFromSuperview()
        containerView.addSubview(kenny)
        
        let viewHeight = containerView.bounds.height
        let viewWidth = containerView.bounds.width
        
        NSLayoutConstraint.activate([
            kenny.topAnchor.constraint(equalTo: containerView.topAnchor, constant: CGFloat(Int.random(in: 0...Int(viewHeight - 200)))),
            kenny.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CGFloat(Int.random(in: 0...Int(viewWidth - 200))))
        ])
    }
    
    private func reset() {
        timer.invalidate()
        count = 10
        score = 0
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel)
        let replayAction = UIAlertAction(title: "Replay", style: .default) { action in
            //need to remove the last constraints for the new game, otherwise will be console errors with the constraints
            self.kenny.removeFromSuperview()
            self.startGame()
        }
        alert.addAction(noAction)
        alert.addAction(replayAction)
        self.present(alert, animated: true)
    }
    
    private func checkForHighScoreAndSaveIt() {
        let oldHighscore = UserDefaults.standard.object(forKey: "highScore") as? Int
        guard let oldHighscore else {
            UserDefaults.standard.set(score, forKey: "highScore")
            return
        }
        if score > oldHighscore {
            UserDefaults.standard.set(score, forKey: "highScore")
        } else {
            return
        }
    }
}

