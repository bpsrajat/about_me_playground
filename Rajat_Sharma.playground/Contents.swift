//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Foundation
import QuartzCore
import AVFoundation


//Player
//var player;
var allMoveExp = [UIView]()
allMoveExp.reserveCapacity(10)

/// The player.
protocol PlayerDelegate : class {
    func soundFinished(_ sender: Any)
}
var stories = [String]()
stories.append( Bundle.main.path(forResource: "part1.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part2.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part3.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part4.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part5.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part6.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part7.mp3", ofType:nil)!)
stories.append( Bundle.main.path(forResource: "part8.mp3", ofType:nil)!)

var oPlayer : AVAudioPlayer!
class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var playCount = stories.count
    var initialCount = 0
    var forever = false
    weak var delegate : PlayerDelegate?
    
    func playFile(atPath path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = URL(fileURLWithPath: path)
        guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return} // nicer
        self.player = p
        // error-checking omitted
        self.player.prepareToPlay()
        self.player.delegate = self
        self.player.play()
        
        
    }
    
    // delegate method
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) { // *
        //self.player.play()
        self.initialCount += 1
        if(self.initialCount < self.playCount)
        {
            allMoveExp.forEach { $0.alpha = 0.6 }
            allMoveExp[self.initialCount].alpha = 1.0
            let fileURL = URL(fileURLWithPath: stories[self.initialCount])
            guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return} // nicer
            self.player = p
            // error-checking omitted
            self.player.prepareToPlay()
            self.player.delegate = self
            self.player.play()
        }
        
        
        
        //self.delegate?.soundFinished(self)
    }
    
    func stop () {
    
        self.player?.pause()
    }
    func realStop () {
        
        if let play = player {
            play.pause()
            player = nil
            }
    }
    
    func toggle () {
        if let play = player {
            if play.isPlaying {
                play.pause()
            }
            else
            {
                play.play()
            }
        }
        else
        {
            self.initialCount = 0
            if(self.initialCount < self.playCount)
            {
                allMoveExp.forEach { $0.alpha = 0.6 }
                allMoveExp[self.initialCount].alpha = 1.0
                let fileURL = URL(fileURLWithPath: stories[self.initialCount])
                guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return} // nicer
                self.player = p
                // error-checking omitted
                self.player.prepareToPlay()
                self.player.delegate = self
                self.player.play()
            }
        }
        
    }
    
    deinit {
        self.player?.delegate = nil
    }
    
}

var player = Player()


//GAME VIEW
let gameView: UIView = {
    let view =  UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 450))
    view.backgroundColor = UIColor.black
    view.layer.borderWidth = 1;
    view.layer.borderColor =  UIColor.white.cgColor
    
    return view
}()

let score_label = UILabel(frame: CGRect(x: 580, y: 5, width: 130, height: 50))
score_label.textAlignment = .center
score_label.font = UIFont(name: "American Typewriter", size: 20)
score_label.textColor = UIColor.white
score_label.text = "Taps: 0"
score_label.numberOfLines = 0

class Ball: UIImageView {
    var animator2 = UIDynamicAnimator(referenceView: gameView)
    var behavior = UIDynamicItemBehavior()
    var taps:Int = 0
    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ball.mp3", ofType:nil)!)
    var bombSoundEffect: AVAudioPlayer!
    var tap_check:Int = 0
    var testLabel = UILabel(frame: CGRect(x: 140, y: 280, width: 420, height: 150))
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.image = UIImage(named: "basketball.png")
        self.isUserInteractionEnabled = true
        testLabel.text="Tap here to Start the Game!\nRules: Keep on Tapping the ball until you can, if it falls down, your game ends.\nKeep trying to get maximum Tap Score."
        testLabel.font = UIFont(name: "American Typewriter", size: 20)
        testLabel.textColor = UIColor.white
        testLabel.textAlignment = .center
        testLabel.numberOfLines = 0
        testLabel.isUserInteractionEnabled = true
        
        gameView.addSubview(testLabel)
        gameView.addSubview(self)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mytapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
        
        
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(mytapHandler2(gesture:)))
        testLabel.addGestureRecognizer(tapRecognizer2)
        
        
    }
    
    func start()
    {
        self.tap_check = 1
        self.taps = 0
        let gravity = UIGravityBehavior(items: [self])
        
        animator2.removeAllBehaviors()
        
        animator2.addBehavior(gravity)
        behavior = UIDynamicItemBehavior()
        let collision = UICollisionBehavior(items: [self])
        
        collision.translatesReferenceBoundsIntoBoundary = true
        animator2.addBehavior(collision)
        animator2.addBehavior({
            behavior = UIDynamicItemBehavior(items: [self])
            behavior.allowsRotation = false
            behavior.elasticity = 1.0
            behavior.action = {
                
                let val_y_ball  = self.layer.presentation()?.frame.origin.y
                if(val_y_ball != nil)
                {
                    if(Double(val_y_ball!)>350.0)
                    {
                        self.tap_check = 0
                        self.animator2.removeAllBehaviors()
                        self.frame =  CGRect(x: 260, y: 60, width: 80, height: 80)
                        score_label.text = "Taps: 0"
                        
                        self.testLabel.alpha =  1.0

                        
                    }
                }
            }
            return behavior
            }())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mytapHandler(gesture: UITapGestureRecognizer) {
        if(self.tap_check == 1)
        {
            self.taps = self.taps + 1
        }
        let val_x_ball  = Double((self.layer.presentation()?.frame.origin.x)!)+40.0
        let val_x_mouse = Double(gesture.location(in: gameView).x)
        //if x of mouse > ball means mouse is in right of ball add velocity to a bit left
        if(val_x_mouse>val_x_ball)
        {
            behavior.addLinearVelocity(CGPoint(x: -50, y: -1000) , for: self)
        }
        else
        {
            behavior.addLinearVelocity(CGPoint(x: 50, y: -1000) , for: self)
            
        }
        
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect = sound
            sound.play()
            
        } catch {
            print("couldnt load ball Sound")
        }

        
        score_label.text = "Taps: \(self.taps)"
        
    }
    
    func mytapHandler2(gesture: UITapGestureRecognizer) {
            self.testLabel.alpha = 0.0
            self.start()
    }
}


//Ball - Game
let ball: Ball = {
    let ball = Ball(frame: CGRect(x: 260, y: 60, width: 80, height: 80))
    return ball
}()


//main class for views

class SUIView: UIViewController {
    var myView: UIView!
    
    override func viewDidLoad() {
        self.view.frame =  CGRect(x: 0, y: 0, width: 700, height: 450)
        self.view.backgroundColor = UIColor.black
        self.myView = UIView(frame:self.view.frame)
        self.view.addSubview(self.myView)
    }
    
}


//VIEWS


//Set Main View
let mainView: UIView = {
    let view =  UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 450))
    view.backgroundColor = UIColor.black
    view.layer.borderWidth = 1;
    view.layer.borderColor =  UIColor.white.cgColor
    
    return view
}()

//Journey
let expView = SUIView()


//About View
let abtView: UIView = {
    let view =  UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 450))
    view.backgroundColor = UIColor.black
    view.layer.borderWidth = 1;
    view.layer.borderColor =  UIColor.white.cgColor
    
    return view
}()


//Why WWDC
let wwdcView: UIView = {
    let view =  UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 450))
    view.backgroundColor = UIColor.black
    view.layer.borderWidth = 1;
    view.layer.borderColor =  UIColor.white.cgColor
    
    return view
}()


//nView
let nView: UIView = {
    let view =  UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 450))
    view.backgroundColor = UIColor.green
    view.layer.borderWidth = 1;
    view.layer.borderColor =  UIColor.white.cgColor
    
    return view
}()

//CENTRE PART - NVIEW
let nCenter =  UIView(frame: CGRect(x:250, y: 130, width: 200, height: 200))
nCenter.backgroundColor = UIColor.white
nCenter.layer.cornerRadius = 100

//Main Journey View - Center
let JView: UIView = {
    let view =  UIView(frame: CGRect(x: 30, y: 100, width: 650, height: 300))
    view.backgroundColor = UIColor.black
    view.layer.borderWidth = 1;
    view.layer.borderColor =  UIColor.white.cgColor
    
    return view
}()

//Puck



var cross1 = UIView(frame: CGRect(x: 0, y: 230, width: 0, height: 1))
cross1.backgroundColor = UIColor.white


var cross2 = UIView(frame: CGRect(x: 340, y: 0, width: 1, height: 0))
cross2.backgroundColor = UIColor.white


var cross3 = UIView(frame: CGRect(x: 20, y: 50, width: 660, height: 1))
cross3.backgroundColor = UIColor.white
cross3.alpha = 0.0


var cross4 = UIView(frame: CGRect(x: 140, y: 350, width: 60, height: 5))
cross4.backgroundColor = UIColor.white
cross4.alpha = 1.0

var cross5 = UIView(frame: CGRect(x: 20, y: 50, width: 660, height: 1))
cross5.backgroundColor = UIColor.white
cross5.alpha = 1.0

var cross6 = UIView(frame: CGRect(x: 140, y: 165, width: 60, height: 5))
cross6.backgroundColor = UIColor.white
cross6.alpha = 1.0

var cross7 = UIView(frame: CGRect(x: 320, y: 165, width: 60, height: 5))
cross7.backgroundColor = UIColor.white
cross7.alpha = 1.0

var cross8 = UIView(frame: CGRect(x: 500, y: 165, width: 60, height: 5))
cross8.backgroundColor = UIColor.white
cross8.alpha = 1.0

var cross9 = UIView(frame: CGRect(x: 320, y: 350, width: 60, height: 5))
cross9.backgroundColor = UIColor.white
cross9.alpha = 1.0

var cross10 = UIView(frame: CGRect(x: 500, y: 350, width: 60, height: 5))
cross10.backgroundColor = UIColor.white
cross10.alpha = 1.0

var cross11 = UIView(frame: CGRect(x: 620, y: 220, width: 5 , height: 90))
cross11.backgroundColor = UIColor.white
cross11.alpha = 1.0


//LABELS
// Label Class
class main_Labels: UILabel {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.textAlignment = .center
        self.font = UIFont(name: "American Typewriter", size: 20)
        self.textColor = UIColor.white
        self.numberOfLines = 0

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class wwdc_Labels: UILabel {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.textAlignment = .center
        self.font = UIFont(name: "American Typewriter", size: 16)
        self.textColor = UIColor.white
        self.numberOfLines = 0
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//Main Intro
let intro_label = UILabel(frame: CGRect(x: 60, y: 120, width: 130, height: 120))
intro_label.textAlignment = .center
intro_label.font = UIFont(name: "American Typewriter", size: 18)
intro_label.textColor = UIColor.black
intro_label.backgroundColor = UIColor.clear
intro_label.text = "Please Click on any Icon to Continue"
intro_label.numberOfLines = 0
intro_label.alpha = 0.0


UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {
    intro_label.alpha = 1.0
}, completion:nil)



let wwdc_name: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 80, y: 280, width: 120, height: 130))
    alogo.text = "Why WWDC?"
    return alogo
}()

let about_me: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 480, y: 45, width: 120, height: 130))
    alogo.text = "About Me"
    return alogo
}()

let Something_new: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 480, y: 280, width: 120, height: 130))
    alogo.text = "Play Game?"
    return alogo
}()


let My_Journey: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 80, y: 45, width: 120, height: 130))
    alogo.text = "My Journey"
    
    return alogo
}()

let wwdc1: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 50, y: 80, width: 600, height: 100))
    alogo.text = "Being From a small town, its challenging to get opportunities, Although as its said if there's a will there's a way!"
    alogo.font = UIFont(name: "American Typewriter", size: 16)
    alogo.textAlignment = .left
    alogo.alpha = 0.0
    return alogo
}()
let wwdc2: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 50, y: 120, width: 600, height: 150))
    alogo.text = "Each year during April, everyone talks about something special, even with their friends, colleges, teachers, you see that something in television news, newspapers, something that makes you wonder what if you were there to experience it?"
    alogo.font = UIFont(name: "American Typewriter", size: 16)
    alogo.textAlignment = .left
    alogo.alpha = 0.0
    return alogo
}()
let wwdc3: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 50, y: 180, width: 600, height: 200))
    alogo.text = "Because that something is nothing else than WWDC, the exciting event for which the whole world holds it breath for the new products and services Apple is going to launch, which are nothing except great innovations."
    alogo.textAlignment = .left
    alogo.alpha = 0.0
    alogo.font = UIFont(name: "American Typewriter", size: 16)
    return alogo
}()
let wwdc4: main_Labels = {
    let alogo = main_Labels(frame: CGRect(x: 50, y: 310, width: 600, height: 100))
    alogo.text = "I want to thank you for providing me an opportunity to present myself.\n\nThank You\nRajat Sharma"
    alogo.textAlignment = .left
    alogo.alpha = 0.0
    alogo.font = UIFont(name: "American Typewriter", size: 16)
    return alogo
}()

//Journey Label
let journey_label = UILabel(frame: CGRect(x: 150, y: 5, width: 400, height: 100))
journey_label.textAlignment = .center
journey_label.font = UIFont(name: "American Typewriter", size: 24)
journey_label.textColor = UIColor.white

//Journey-Story Label

let story_heading = UILabel(frame: CGRect(x: 50, y: 20, width: 550, height: 50))
story_heading.textAlignment = .center
story_heading.font = UIFont(name: "American Typewriter", size: 22)
story_heading.textColor = UIColor.white
story_heading.numberOfLines = 0
story_heading.text = ""
story_heading.alpha = 1.0

let story_label = UILabel(frame: CGRect(x: 50, y: 80, width: 550, height: 200))
story_label.textAlignment = .center
story_label.font = UIFont(name: "American Typewriter", size: 16)
story_label.textColor = UIColor.white
story_label.numberOfLines = 0
story_label.text = "Hi! Welcome to My Journey!\n\n I did my Bachelor's of Technology from from Kurukshetra University, INDIA in 2015."
story_label.alpha = 1.0



//About me Label
let about_me_label = UILabel(frame: CGRect(x: 20, y: 20, width: 460, height: 500))
about_me_label.font = UIFont(name: "American Typewriter", size: 14)
about_me_label.textAlignment = .left
about_me_label.backgroundColor = UIColor.clear
about_me_label.textColor = UIColor.white
about_me_label.numberOfLines = 0


class playPause: UILabel {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.textAlignment = .center
        self.font = UIFont(name: "American Typewriter", size: 20)
        self.textColor = UIColor.white
        self.numberOfLines = 0
        
        self.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mytapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mytapHandler(gesture: UITapGestureRecognizer) {
        player.toggle()
    }
}

//Replay Label

let replay: playPause = {
    let alogo = playPause(frame: CGRect(x: 130, y: 245, width: 460, height: 30))
    alogo.text = "Play/Pause or Click on Each Icon to Know More"
    alogo.textAlignment = .left
    return alogo
}()


//IMAGEVIEWS
//Small Thumbnail Image
let myPic = UIImage(named: "mypic.png")
let myPicView = UIImageView(image: myPic!)
myPicView.frame = CGRect(x: 5, y: 5, width: 60, height: 60)


//Back Button Class
class play_Pause: UIImageView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.image = UIImage(named: "play_pause.png")
        self.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mytapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func mytapHandler(gesture: UITapGestureRecognizer) {
        player.toggle()
        
    }
    
}

let playPicView: play_Pause = {
    let back_btn = play_Pause(frame: CGRect(x: 100, y: 250, width: 25, height: 25))
    return back_btn
}()


//Small Thumbnail Image - GRAD
let myGrad = UIImage(named: "mypic.png")
let myGradView = UIImageView(image: myGrad!)
myGradView.frame = CGRect(x: 5, y: 5, width: 60, height: 60)

//Small Thumbnail Image - GRAD
let expViewBack = UIImage(named: "back_exp.jpg")
let expViewImg = UIImageView(image: expViewBack!)
expViewImg.frame = CGRect(x: 0, y: 0, width: 700, height: 450)


//Small Kid VIew
let kidPic = UIImage(named: "small_kid.jpg")
let kidPicView = UIImageView(image: kidPic!)
kidPicView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)

//Small tenager Image - GRAD
let learningkidPic = UIImage(named: "learning_kid.jpg")
let learningkidPicView = UIImageView(image: learningkidPic!)
learningkidPicView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)

//Small Interested Kid Image - GRAD
let interestedKid = UIImage(named: "learning_kid2.png")
let learningkid2PicView = UIImageView(image: interestedKid!)
learningkid2PicView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)


//Before Grad
let beforegrad = UIImage(named: "beforegrad.jpg")
let beforegradView = UIImageView(image: beforegrad!)
beforegradView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)



//after grad
let aftergrad = UIImage(named: "aftergrad.jpg")
let aftergradView = UIImageView(image: aftergrad!)
aftergradView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)

//move canada
let movecanada = UIImage(named: "movecanada.png")
let movecanadaView = UIImageView(image: movecanada!)
movecanadaView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)

//wwdc
let wwdcImg = UIImage(named: "og.jpg")
let wwdcimgView = UIImageView(image: wwdcImg!)
wwdcimgView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)

//maybe apple?
let maybeapple = UIImage(named: "maybeapple.jpg")
let maybeappleView = UIImageView(image: maybeapple!)
maybeappleView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)

//Back Button Class
class CLOSE: UIImageView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.image = UIImage(named: "close.png")
        self.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mytapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func mytapHandler(gesture: UITapGestureRecognizer) {
        player.realStop()
        mainView.bringSubview(toFront: expView.view)
        
    }
    
}





//Back Button - About
let closeView: CLOSE = {
    let back_btn = CLOSE(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
    return back_btn
}()

//Now
let now = UIImage(named: "clock.png")
let nowView = UIImageView(image: now!)
nowView.frame = CGRect(x: 5, y: 5, width: 60, height: 60)


let myPicView2 = UIImageView(image: myPic!)
myPicView2.frame = CGRect(x: 5, y: 5, width: 60, height: 60)

let myPic3 = UIImage(named: "abtme_1.jpeg")
let myPicView3 = UIImageView(image: myPic3!)
myPicView3.frame = CGRect(x: 500, y: 145, width: 160, height: 200)
//main wwdc
//wwdc pic
let wwdcPic = UIImage(named: "wwdc_logo.png")
let wwdcPicViewM = UIImageView(image: wwdcPic!)
wwdcPicViewM.frame = CGRect(x: 317, y: 20, width: 70, height: 70)


//wwdc pic
let wwdcPicView = UIImageView(image: wwdcPic!)
wwdcPicView.frame = CGRect(x: 3, y: 3, width: 60, height: 60)


//Main View 2
let image1 = UIImage(named: "background1.jpg")
let imageView1 = UIImageView(image: image1!)
imageView1.frame = CGRect(x: 0, y: 0, width: 700, height: 450)

//apple shape
let appleN = UIImage(named: "apple_nView.png")
let appleNView = UIImageView(image: appleN!)
appleNView.frame = CGRect(x:225, y: 60, width: 250, height: 280)

//Exp Pic
let expPic = UIImage(named: "map.png")
let expPicView = UIImageView(image: expPic!)
expPicView.frame = CGRect(x: 5, y: 5, width: 60, height: 60)

//Exp Pic 2
let expPicView1 = UIImageView(image: expPic!)
expPicView1.frame = CGRect(x: 5, y: 5, width: 60, height: 60)

//Exp Pic 2
let gamePic = UIImage(named: "basketball.png")
let game_logo = UIImageView(image: gamePic!)
game_logo.frame = CGRect(x: 5, y: 5, width: 60, height: 60)


//Classes

//Sview - handling Game
class SView: UIImageView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(sender:)))
        addGestureRecognizer(panRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func panHandler(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: gameView)
        var newPos = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        newPos.y = 410
        if newPos.x>26.0 && newPos.x<674 {
            sender.view!.center = newPos
            sender.setTranslation(CGPoint.zero, in: gameView)
        }
        
    }
    
}

class PView: UIView{
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(sender:)))
        addGestureRecognizer(panRecognizer)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func panHandler(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: gameView)
        var newPos = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        newPos.y = 410
        if newPos.x>26.0 && newPos.x<654 {
            sender.view!.center = newPos
            sender.setTranslation(CGPoint.zero, in: gameView)
        }
        
    }
    
}




//Class to handle tap on selected - in about
class move_exp2Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
        story_heading.text = "WWDC"
        
        story_label.text="Apple is one of the top positioned tech companies in the world. Getting a chance to visit the annual WWDC Conference of apple would be like a dream come true for a guy like me. I am genuinely excited about getting closer to this opportunity. If given the chance I am sure, i would make the most of it. This opportunity in turn will help me to make a great impact in the industry. Last but not the least I am thankful to apple for giving me a chance to present my work and give me an opportunity to be a part of such a big event. See you at the conference ;)"
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart7.mp3", ofType:nil)!)
       
        mainView.bringSubview(toFront: JView)
    }
}

class move_exp3Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
        story_heading.text = "Moving Canada"
        
        story_label.text="After graduation, I spent some time doing more freelance work. After gaining some experience, I had found what I wanted to pursue ahead. Hence, I decided to upgrade myself . I came to Canada, to do my post grad studies in Mobile Application Design and Development, Its been almost 8 months, and every day is a new challenging learning experience, In my current studies I am gaining in depth knowledge of how to develop mobile applications using latest tools like XCODE. I am hoping that at the my end of this course, I will be a well innovation engineer and will be able to contribute my bit to this great age of technology"
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart6.mp3", ofType:nil)!)
        mainView.bringSubview(toFront: JView)

    }
}

class move_exp4Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
    
        story_heading.text = "After Graduation"
        
        story_label.text="As I walked into college, I learned in more details about Object Oriented  which was a pretty new concept, I was totally taken aback oh how programs created using code can be compared to real life situations and incorporated with the same. Before I could graduate I had already started my career as a freelancer and worked with various companies and international clients. I graduate out of college in 2015 and after that i published my two research papers in Cloud Computing within a span of one year."
        
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart5.mp3", ofType:nil)!)
        
        mainView.bringSubview(toFront: JView)

    }
}

class move_exp5Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
    
        story_heading.text = "Childhood Traits"
        
        story_label.text="I was born in family, where my dad and uncles were all a part of the financial industry. Everybody who came to my house was either from a finance background or business, considering this I had totally opposite traits. As a child I used rip open every toy given to me and try to fix it back myself. I use to love doing these kind of things. I was always inquisitive about how things work and function."
       
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart1.mp3", ofType:nil)!)
        
        mainView.bringSubview(toFront: JView)

    }
}


class move_exp6Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
    
        story_heading.text = "Curious Kid"
        
        story_label.text="As kid I was always fascinated about video games, computer softwares, cars, and all different kind of technologies. I always ripped apart all the new gadgets that came in my view to understand how they really work ?? As a 6-7 year old when my other friends had barely started reading short story books, I had subscribed for Digit the technology magazine. I used to be super excited to receive my subscription and all the newbies that came with it. I spent hours together trying to figure out the logic behind all of this and every single day I learnt something new which fascinated me and excited me to explore more. That is when me as well as my parents knew I am definitely going to be a techie :P"
        
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart2.mp3", ofType:nil)!)
        
        mainView.bringSubview(toFront: JView)

    }
}


class move_exp7Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
    
        story_heading.text = "Crazy for Technology"
        
        story_label.text="As I grew up in a joint family I had two of my cousin brothers who were elder to me, I used to watch  and hear them day in and day out about computer hardware, software, applications, games, etc. Both of them used to work on their projects on c and java language and use to create amazing software as well as utility applications  which really amazed me, I though to myself there so much I can be do with programming and this is where my journey started."
        
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart3.mp3", ofType:nil)!)
        
        mainView.bringSubview(toFront: JView)

    
    }
}

class move_exp8Class: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer){
        
        story_heading.text = "Graduation in Computers"
        
        story_label.text="At a very young age I use to assist my brothers in development and slowly began to create my own little blocks of code, to more complicated ones. I spent my vacations learning about different programming languages and getting my logical game strong. I then decided I want to pursue this as my career and took a step closer by enrolling myself in Bachelors Of Technology in Computer Science & Engineering"
    
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart4.mp3", ofType:nil)!)
        
        mainView.bringSubview(toFront: JView)
        
    }
}




class Info2: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 20
        self.alpha = 0.6
        self.clipsToBounds = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func tapHandler(gesture: UITapGestureRecognizer) {
        
        story_heading.text = "Maybe Apple?"
        story_label.text="So my name is Rajat Sharma and that was my story ....\nThis is the part for how i what I want my future to be #MayBeAFutureAppleEmployee? :P\n\nJokes aside I am really hoping to make my mark in the industry and contributing to this 'Modern age of technology.'"
        
        player.playFile(atPath: Bundle.main.path(forResource: "detailPart8.mp3", ofType:nil)!)
        
        mainView.bringSubview(toFront: JView)

    }
}
//exp
let move_exp2: move_exp2Class = {
    let view = move_exp2Class(frame: CGRect(x: 560, y: 305, width: 120, height: 100))
    return view
}()




//exp
let move_exp: Info2 = {
    let view = Info2(frame: CGRect(x: 560, y: 305, width: 120, height: 100))
    return view
}()

//exp
let move_exp3: move_exp3Class = {
    let view = move_exp3Class(frame: CGRect(x: 560, y: 305, width: 120, height: 100))
    return view
}()


//exp
let move_exp4: move_exp4Class = {
    let view = move_exp4Class(frame: CGRect(x: 560, y: 305, width: 120, height: 100))
    return view
}()

//exp
let move_exp5: move_exp5Class = {
    let view = move_exp5Class(frame: CGRect(x: 20, y: 120, width: 120, height: 100))
    return view
}()


//exp
let move_exp6: move_exp6Class = {
    let view = move_exp6Class(frame: CGRect(x: 20, y: 120, width: 120, height: 100))
    return view
}()


//exp
let move_exp7: move_exp7Class = {
    let view = move_exp7Class(frame: CGRect(x: 20, y: 120, width: 120, height: 100))
    return view
}()


//exp
let move_exp8: move_exp8Class = {
    let view = move_exp8Class(frame: CGRect(x: 20, y: 120, width: 120, height: 100))
    return view
}()

allMoveExp.append(move_exp5)
allMoveExp.append(move_exp6)
allMoveExp.append(move_exp7)
allMoveExp.append(move_exp8)
allMoveExp.append(move_exp4)
allMoveExp.append(move_exp3)
allMoveExp.append(move_exp2)
allMoveExp.append(move_exp)


//exp page
let exps: UIView = {
    let view =  UIView(frame: CGRect(x: 317, y: 20, width: 70, height: 70))
    view.backgroundColor = UIColor.white
    view.layer.borderWidth = 2;
    view.layer.borderColor =  UIColor.black.cgColor
    view.layer.cornerRadius = 35
    view.alpha = 1.0
    return view
}()



//Class to handle tap on selected
class Info: UIView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2;
        self.layer.borderColor =  UIColor.black.cgColor
        self.layer.cornerRadius = 35
        self.alpha = 0.0
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tapHandler(gesture: UITapGestureRecognizer) {
        
        let val_x = self.frame.origin.x
        
        let val_y = self.frame.origin.y
        var view_tapped = UIView()
        
        if(val_x > 250 && val_y > 200)
        {
            view_tapped = gameView
        }
        else if(val_x < 250 && val_y > 200)
        {
            view_tapped = wwdcView
        }
        else if(val_x < 250 && val_y < 200)
        {
            view_tapped = expView.view
        }
        else
        {
            view_tapped = abtView
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
            self.frame = CGRect(x: 317, y: 20, width: 70, height: 70)
            
            
        }, completion: {
            (value: Bool) in
            mainView.bringSubview(toFront: view_tapped)
            if(view_tapped == abtView)
            {
                about_me_label.text = "Hey There ... My name is Rajat Sharma! I am currently an international student studying my post graduation in Mobile Application Design and Development. I am an aspiring Mobile Innovation Developer (Focussing mainly on IOS development :p #AppleFanForLife)\n\nI am passionate about development and innovation, by which I am hoping to make a valuable contribution to the future age of technology.\n\nIn my young and budding career that I have had so far which is pretty new and amateur I have worked on very interesting projects which include web and mobile development technologies.\n\nOther than that my hobbies include playing video games, reading books, travelling, socialising and networking and listening to music.\n\nShoot me an email at bpsrajat@gmail.com, or contact me on +1 (647) 746-2900 to know more about me."
                
                
                UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                    cross3.alpha = 1.0
                }, completion:nil)
                
            }
            else if (view_tapped == wwdcView)
            {
                UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                    cross5.alpha = 1.0
                }, completion:{
                    (value:Bool) in
                    UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                        wwdc1.alpha = 1.0
                    }, completion:{
                        (value:Bool) in
                        UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                            wwdc2.alpha = 1.0
                        }, completion:{(value:Bool) in
                            UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                                wwdc3.alpha = 1.0
                            }, completion:{(value:Bool) in
                                UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                                    wwdc4.alpha = 1.0
                                }, completion:nil)
                            })
                        })
                    })
                })
            }
            else if(view_tapped == expView.view)
            {
                
                //Reset things
                move_exp.frame = CGRect(x: 560, y: 305, width: 120, height: 100)
                move_exp.alpha = 0.6
                move_exp2.frame = CGRect(x: 560, y: 305, width: 120, height: 100)
                move_exp2.alpha = 0.6
                move_exp3.frame = CGRect(x: 560, y: 305, width: 120, height: 100)
                move_exp3.alpha = 0.6
                move_exp4.frame = CGRect(x: 560, y: 305, width: 120, height: 100)
                move_exp4.alpha = 0.6
                move_exp5.frame =  CGRect(x: 20, y: 120, width: 120, height: 100)
                move_exp5.alpha = 0.6
                move_exp6.frame =  CGRect(x: 20, y: 120, width: 120, height: 100)
                move_exp6.alpha = 0.6
                move_exp7.frame = CGRect(x: 20, y: 120, width: 120, height: 100)
                move_exp7.alpha = 0.6
                move_exp8.frame = CGRect(x: 20, y: 120, width: 120, height: 100)
                move_exp8.alpha = 0.6
                cross4.alpha = 0.0
                cross6.alpha = 0.0
                cross7.alpha = 0.0
                cross8.alpha = 0.0
                cross9.alpha = 0.0
                cross10.alpha = 0.0
                cross11.alpha = 0.0
                //intialize
                
                UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
                    exps.frame = CGRect(x: 117, y: 20, width: 70, height: 70)
                }, completion:{
                    (value: Bool) in
                    journey_label.text = "My Journey till 2017"
                })
                
                UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseInOut], animations: {
                    move_exp.frame = CGRect(x: 20, y: 305, width: 120, height: 100)
                     move_exp2.frame = CGRect(x: 200, y: 305, width: 120, height: 100)
                    move_exp3.frame = CGRect(x: 380, y: 305, width: 120, height: 100)
                    move_exp6.frame = CGRect(x: 200, y: 120, width: 120, height: 100)
                    move_exp7.frame = CGRect(x: 380, y: 120, width: 120, height: 100)
                    move_exp8.frame = CGRect(x: 560, y: 120, width: 120, height: 100)
                   
                    
                }, completion:nil )
                
                UIView.animate(withDuration: 3, delay: 2, options: [.curveEaseInOut], animations: {
                    cross4.alpha = 0.6
                    cross6.alpha = 0.6
                    cross7.alpha = 0.6
                    cross8.alpha = 0.6
                    cross9.alpha = 0.6
                    cross10.alpha = 0.6
                    cross11.alpha = 0.6
                    move_exp5.alpha = 1.0
                    
                }, completion:{(value:Bool) in
                player.playFile(atPath: stories[0])
                    
                } )
                
            
                
                //else ends
            }
        
        })
    

        
    }
}


//Abt Me
let abt: Info = {
    let view = Info(frame: CGRect(x: 390, y: 135, width: 70, height: 70))
    view.layer.borderColor =  UIColor.red.cgColor
    return view
}()

//PLAY GAME
let game_icon: Info = {
    let view = Info(frame: CGRect(x: 390, y: 260, width: 70, height: 70))
    view.layer.borderColor =  UIColor.blue.cgColor
    return view
}()

//My Experience
let exp_icon: Info = {
    let view = Info(frame: CGRect(x: 245, y: 135, width: 70, height: 70))
    view.layer.borderColor =  UIColor.black.cgColor
    return view
}()

//Why WWDC
let wwdc: Info = {
    let view = Info(frame: CGRect(x: 245, y: 260, width: 70, height: 70))
    view.layer.borderColor =  UIColor.purple.cgColor
    return view
}()

//ABOUT PAGE
let abt2: Info = {
    let view = Info(frame: CGRect(x: 317, y: 20, width: 70, height: 70))
    view.layer.borderColor =  UIColor.red.cgColor
    view.alpha = 1.0
    return view
}()


//Back Button Class
class BACK: UIImageView {
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.image = UIImage(named: "back_btn.png")
        self.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mytapHandler(gesture:)))
        addGestureRecognizer(tapRecognizer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func mytapHandler(gesture: UITapGestureRecognizer) {
        mainView.bringSubview(toFront: nView)
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
           wwdc.frame =  CGRect(x: 245, y: 260, width: 70, height: 70)
            game_icon.frame =  CGRect(x: 390, y: 260, width: 70, height: 70)
            abt.frame =  CGRect(x: 390, y: 135, width: 70, height: 70)
            exp_icon.frame =  CGRect(x: 245, y: 135, width: 70, height: 70)
            player.realStop()
            
        }, completion:nil)
    }
    
}


//Class for View

//View Based on Classes


//Draw Logo
let apple_logo: SView = {
    let alogo = SView(frame: CGRect(x: 280, y: 150, width: 120, height: 130))
    alogo.image = UIImage(named: "Apple_logo1.png")
    alogo.isUserInteractionEnabled = true
    return alogo
}()

//Back Button - About
let back_abt: BACK = {
    let back_btn = BACK(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
    return back_btn
}()

//Back Button - Journey
let back_journey: BACK = {
    let back_btn = BACK(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
    return back_btn
}()

//Back Button - Journey
let back_wwdc: BACK = {
    let back_btn = BACK(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
    return back_btn
}()

//Back Button - Game
let back_game: BACK = {
    let back_btn = BACK(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
    return back_btn
}()

//Functions

//Function to RESET nView
func reset_nview()
{
    UIView.animate(withDuration: 1, delay: 1, options: [.curveLinear], animations: {
        abt.alpha = 1.0
    }, completion: nil)
    
    UIView.animate(withDuration: 1, delay: 2, options: [.curveLinear], animations: {
        game_icon.alpha = 1.0
    }, completion: nil)
    
    UIView.animate(withDuration: 1, delay: 3, options: [.curveLinear], animations: {
        wwdc.alpha = 1.0
    }, completion: nil)
    
    UIView.animate(withDuration: 1, delay: 4, options: [.curveLinear], animations: {
        exp_icon.alpha = 1.0
    }, completion: nil)
    
    UIView.animate(withDuration: 3, delay: 1, options: [.curveLinear], animations: {
        
        cross1.frame =  CGRect(x: 0, y: 230, width: 700, height: 1)
        cross2.frame =  CGRect(x: 350, y: 0, width: 1, height: 500)
    }, completion: nil)
    
}


//set images in nview

wwdc.addSubview(wwdcPicView)
abt.addSubview(myPicView)
exp_icon.addSubview(expPicView)

nView.addSubview(imageView1)
nView.addSubview(cross1)
nView.addSubview(cross2)
appleNView.addSubview(intro_label)
nView.addSubview(appleNView)
nView.addSubview(abt)
game_icon.addSubview(game_logo)
nView.addSubview(game_icon)
nView.addSubview(wwdc)
nView.addSubview(exp_icon)
nView.addSubview(wwdc_name)
nView.addSubview(about_me)
nView.addSubview(Something_new)
nView.addSubview(My_Journey)


//About View
abtView.addSubview(myPicView3)
abtView.addSubview(cross3)
abtView.addSubview(about_me_label)
abt2.addSubview(myPicView2)
abtView.addSubview(abt2)
abtView.addSubview(back_abt)

//EXP PIC
exps.addSubview(expPicView1)
move_exp4.addSubview(nowView)
move_exp.addSubview(myGradView)

//add picutres in move_exp
move_exp5.addSubview(kidPicView)
move_exp6.addSubview(learningkid2PicView)
move_exp7.addSubview(learningkidPicView)
move_exp8.addSubview(beforegradView)
move_exp4.addSubview(aftergradView)
move_exp3.addSubview(movecanadaView)
move_exp2.addSubview(wwdcimgView)
move_exp.addSubview(maybeappleView)
expView.view.addSubview(expViewImg)
expView.view.addSubview(exps)
    expView.view.addSubview(journey_label)
    expView.view.addSubview(cross4)
    expView.view.addSubview(cross6)
    expView.view.addSubview(cross7)
    expView.view.addSubview(cross8)
    expView.view.addSubview(cross9)
    expView.view.addSubview(cross10)
    expView.view.addSubview(cross11)
    expView.view.addSubview(move_exp8)
    expView.view.addSubview(move_exp7)
    expView.view.addSubview(move_exp6)
    expView.view.addSubview(move_exp5)
    expView.view.addSubview(move_exp4)
    expView.view.addSubview(move_exp3)
    expView.view.addSubview(move_exp2)
    expView.view.addSubview(move_exp)
    expView.view.addSubview(playPicView)
    expView.view.addSubview(replay)


JView.addSubview(story_heading)
JView.addSubview(story_label)
JView.addSubview(closeView)
expView.view.addSubview(back_journey)

//WWDC VIEW
wwdcView.addSubview(cross5)
wwdcView.addSubview(wwdcPicViewM)
wwdcView.addSubview(wwdc1)
wwdcView.addSubview(wwdc2)
wwdcView.addSubview(wwdc3)
wwdcView.addSubview(wwdc4)
wwdcView.addSubview(back_wwdc)

//Game
gameView.addSubview(back_game)
gameView.addSubview(score_label)


//add data to main VIew

mainView.addSubview(JView)
mainView.addSubview(abtView)
mainView.addSubview(gameView)
mainView.addSubview(wwdcView)
mainView.addSubview(expView.view)
mainView.addSubview(nView)

reset_nview()

PlaygroundPage.current.liveView = mainView
