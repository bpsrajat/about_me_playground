# About Me - WWDC 2017 Playground
Its a Playround Application created for Apple's WWDC 2017 in Swift 3.

For the whole app, the main screen size is set to width: 700 and height: 450. While developing it, To create the views and manage the application i used the UIKit which enables the user interaction and has event handling structure to handle the users input, For user interaction and wanted to have a control over my live view i used PlaygroundSupport Framework Also for the game part used UIAnimations, structures, shapes to include it,used QuartzCore Framework,

Further to extend the object behaviour so that used classes,imported Foundation, Also added recorded voice on GarageBand and used it in various views like "My Journey", "Play Game?". To include the voice used AVFoundation Framework which includes the AVAudioPlayer.

 Further in Game Part, used UIDynamicAnimator with to define the referenceView as well as add behaviour to the Ball, also included Gravity Behaviour on the ball and for handling the collision (UICollisionBehavior). To recognise the tap on screen used UITapGestureRecognizer, Further at each point of collision between mouse and ball, the impact position is calculated which is used to decide in which direction(left or right) the ball will receive a external velocity e.g if mouse strike ball at left end ball will go to a bit right and vice-versa. 
 
 Also to set the frame(position) of each View/Subviews CGRect is defined. Further to change the views dynamically i have used bringSubview(toFront: ViewName). Further multiple methods are applied to the views to make them in different form like circle, big rectangles( as in "My Journey Page").

In this project the main list of Views are:

nView - The Landing Page with Menu
<img width="700" alt="homescreen" src="https://user-images.githubusercontent.com/13946443/43971452-1a345554-9c9f-11e8-9255-4cfac4b4746f.png">

expView - The Journey Page
<img width="700" alt="myjourney" src="https://user-images.githubusercontent.com/13946443/43971495-48400fc4-9c9f-11e8-938a-e59f08c77fb2.png">

JView - The Popup being used at Journey
<img width="700" alt="jview" src="https://user-images.githubusercontent.com/13946443/43971552-817e2316-9c9f-11e8-8a01-709cff4d0272.png">

abtView - The About me Page
<img width="700" alt="aboutme" src="https://user-images.githubusercontent.com/13946443/43971570-9114ebca-9c9f-11e8-873d-4a141e84a2a7.png">

gameView - The Game Page
<img width="700" alt="game" src="https://user-images.githubusercontent.com/13946443/43971578-9aef3826-9c9f-11e8-82ec-6c7d81bab9dd.png">

wwdcView - Why WWDC Page?
<img width="700" alt="whywwdc" src="https://user-images.githubusercontent.com/13946443/43971589-a3da877e-9c9f-11e8-8a5a-1a6398221a7c.png">



