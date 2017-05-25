# about_me_playground
Its a Playround Application created for Apple's WWDC 2017.

For the whole app, the main screen size is set to width: 700 and height: 450. While developing it, To create the views and manage the application i used the UIKit which enables the user interaction and has event handling structure to handle the users input, For user interaction and wanted to have a control over my live view i used PlaygroundSupport Framework Also for the game part used UIAnimations, structures, shapes to include it,used QuartzCore Framework,

Further to extend the object behaviour so that used classes,imported Foundation, Also added recorded voice on GarageBand and used it in various views like "My Journey", "Play Game?". To include the voice used AVFoundation Framework which includes the AVAudioPlayer.

 Further in Game Part, used UIDynamicAnimator with to define the referenceView as well as add behaviour to the Ball, also included Gravity Behaviour on the ball and for handling the collision (UICollisionBehavior). To recognise the tap on screen used UITapGestureRecognizer, Further at each point of collision between mouse and ball, the impact position is calculated which is used to decide in which direction(left or right) the ball will receive a external velocity e.g if mouse strike ball at left end ball will go to a bit right and vice-versa. 
 
 Also to set the frame(position) of each View/Subviews CGRect is defined. Further to change the views dynamically i have used bringSubview(toFront: ViewName). Further multiple methods are applied to the views to make them in different form like circle, big rectangles( as in "My Journey Page").

In this project the main list of Views are:
JView - The Popup being used at Journey
abtView - The About me Page
gameView - The Game Page
wwdcView - Why WWDC Page?
expView.view - The Journey Page
nView - The Landing Page with Menu
