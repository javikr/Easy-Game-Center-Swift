# Easy Game Center [![](http://img.shields.io/badge/Swift-1.2-blue.svg)]() [![](http://img.shields.io/badge/iOS-7.0%2B-blue.svg)]() [![](http://img.shields.io/badge/iOS-8.0%2B-blue.svg)]() [![](https://img.shields.io/packagist/l/doctrine/orm.svg)]()

#[![](http://img.shields.io/badge/Swift-2.0-blue.svg)]() Version beta : http://bit.ly/1QPd56Y

<p align="center">
        <img src="http://s2.postimg.org/jr6rlurax/easy_Game_Center_Swift.png" height="200" width="200" />
</p>
<p align="center">
        <img src="https://img.shields.io/badge/Easy Game Center-3.5-D8B13C.svg" />
</p>
**Easy Game Center** helps to manage Game Center in iOS. Report and track **high scores**, **achievements** and **Multiplayer**. Easy Game Center falicite management of Game Center.  

<p align="center">
        <img src="http://g.recordit.co/aEYan5qPW3.gif" height="500" width="280" />
        
</p>

####Example Game with Easy Game Center
#####Hipster Moustache : http://bit.ly/1zGJMNG  By Stephan Yannick
#####Dyslexia : http://apple.co/1L3D6xS By Nicolas Morelli
#####Kicuby : https://goo.gl/BzNXBW By Kicody

# Project Features
Easy Game Center is a great way to use Game Center in your iOS app.

* Swift
* Manage **multiplayers**
* Manage **leaderboards**
* Manage **achievements**
* Manages in **single line of code** most function of Game Center
* GKachievements & GKachievementsDescription are save in cache and automatically refreshed
* Delegate function when player is connected, not connected, multiplayer etc...
* Most of the functions callBack (Handler, completion)
* Useful methods and properties by use Singleton (EasyGameCenter.exampleFunction)
* Just drag and drop the files into your project (EasyGameCenter.swift)
* Easy Game Center is asynchronous
* **Frequent updates** to the project based on user issues and requests.
* **Example project**
* Easily contribute to the project :)


## Requirements
[![](http://img.shields.io/badge/Swift-1.2-blue.svg)]()

[![](http://img.shields.io/badge/iOS-7.0%2B-blue.svg)]() 

[![](http://img.shields.io/badge/iOS-8.0%2B-blue.svg)]()

[![](https://img.shields.io/badge/Easy Game Center-3.1-D8B13C.svg)]()

## Contributions & Share
* Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub. :D
* Send me your application's link, if you use Easy Game center, I will add on the cover page and for support [@RedWolfStudioFR](https://twitter.com/RedWolfStudioFR) 
[@YannickSteph](https://twitter.com/YannickSteph)

## Support
* Contact for support [Issues](https://github.com/DaRkD0G/Easy-Game-Center-Swift/issues)
* [@RedWolfStudioFR](https://twitter.com/RedWolfStudioFR) // [@YannickSteph](https://twitter.com/YannickSteph)

# Documentation
## Setup
Setting up Easy Game Center it's really easy. Read the instructions after.

**1.** Add the `GameKit`, `SystemConfiguration` frameworks to your Xcode project
<p align="center">
        <img src="http://s27.postimg.org/45wds3jub/Capture_d_cran_2558_03_20_19_56_34.png" height="100" width="500" />
</p>

**2.** Add the following classes (GameCenter.swift) to your Xcode project (make sure to select Copy Items in the dialog)

**3.** You can initialize Easy Game Center by using the following method call (This is an example, see doc)
```swift 
// Add Protocol for delegate fonction "EasyGameCenterDelegate"
class MainViewController: UIViewController,EasyGameCenterDelegate {
    /**
        This method is called after the view controller has loaded
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*** Set Delegate UIViewController ***/
        EasyGameCenter.sharedInstance(self)
        
        /*** If you want not message just delete this ligne ***/
        EasyGameCenter.debugMode = true
    }
    /**
        Notifies the view controller that its view was added
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*** Set View Controller delegate, that's when you change UIViewController ***/
        EasyGameCenter.delegate = self
    }
    /*####################################################################################################*/
    /*                           Authentification Delegate Function                                       */
    /*####################################################################################################*/
    /**
        Player conected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterAuthentified() {
        println("\n[AuthenticationActions] Player Authentified\n")
    }
    /**
        Player not connected to Game Center, Delegate Func of Easy Game Center
    */
    func easyGameCenterNotAuthentified() {
        println("\n[AuthenticationActions] Player not authentified\n")
    }
    /**
        When GkAchievement & GKAchievementDescription in cache, Delegate Func of Easy Game Center
    */
    func easyGameCenterInCache() {
        println("\n[AuthenticationActions] GkAchievement & GKAchievementDescription in cache\n")
    }
    /*####################################################################################################*/
    /*                           MultiPlayer Delegate Function                                            */
    /*####################################################################################################*/
    /**
        Match Start, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchStarted() {
        println("\n[MultiPlayerActions] Match Started !")
    }
    /**
        Match Recept Data, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchRecept(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        println("\n[MultiPlayerActions] Recept Data from Match !")
    }
    /**
    Match End / Error (No NetWork example), Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchEnded() {
        println("\n[MultiPlayerActions] Match Ended !")
    }
    /**
    Match Cancel, Delegate Func of Easy Game Center
    */
    func easyGameCenterMatchCancel() {
        println("\n[MultiPlayerActions] Match cancel")
    }
}
```

## Initialize
###Protocol Easy Game Center
* **Description :** You should add **EasyGameCenterDelegate** protocol if you want use delegate functions (**easyGameCenterAuthentified,easyGameCenterNotAuthentified,easyGameCenterInCache**)
* **Option :** It is optional (if you do not use the functions, do not add)
```swift
    class ExampleViewController: UIViewController,EasyGameCenterDelegate { }
```
###Initialize Easy Game Center
* **Description :** You should setup Easy Game Center when your app is launched. I advise you to **viewDidLoad()** method
```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Easy Game Center
        EasyGameCenter.sharedInstance(self)
    }
```
###Set new delegate when you change UIViewController
* **Description :** If you have several UIViewController just add this in your UIViewController for set new Delegate
* **Option :** It is optional 
```swift
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //Set New view controller delegate, that's when you change UIViewController
        EasyGameCenter.delegate = self
    }
```
##Delegate function for listen
###Listener Player is authentified
* **Description :** This function is call when player is authentified to Game Center
* **Option :** It is optional 
```swift
    func easyGameCenterAuthentified() {
        println("\nPlayer Authentified\n")
    }
```
###Listener Player is not authentified
* **Description :** This function is call when player is not authentified to Game Center
* **Option :** It is optional 
```swift
    func easyGameCenterNotAuthentified() {
        println("\nPlayer not authentified\n")
    }
```
###Listener when Achievement is in cache
* **Description :** This function is call when GKachievements GKachievementsDescription is in cache
* **Option :** It is optional 
```swift
    func easyGameCenterInCache() {
        println("\nGkAchievement & GKAchievementDescription in cache\n")
    }
```
#Show Methods
##Show Achievements
* **Show Game Center Achievements with completion**
* **Option :** Without completion 
```swift 
    EasyGameCenter.showGameCenterAchievements()
```
* **Option :** With completion
```swift
    EasyGameCenter.showGameCenterAchievements { 
        (isShow) -> Void in
        if isShow {
                println("Game Center Achievements is shown")
        }
    }
```
##Show Leaderboard
* **Show Game Center Leaderboard  with completion**
* **Option :** Without completion 
```swift
    EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "IdentifierLeaderboard")
```
* **Option :** With completion
```swift
    EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "IdentifierLeaderboard") { 
        (isShow) -> Void in
        if isShow {
            println("Game Center Leaderboards is shown")
        }
    }
```
##Show Challenges
* **Show Game Center Challenges  with completion**
* **Option :** Without completion 
```swift 
    EasyGameCenter.showGameCenterChallenges()
```
* **Option :** With completion 
```swift
    EasyGameCenter.showGameCenterChallenges {
        (isShow) -> Void in
        if isShow {
            println("Game Center Challenges Is shown")
        }
    }
```
##Show authentification page Game Center
* **Show Game Center authentification page with completion**
* **Option :** Without completion 
```swift
    EasyGameCenter.showGameCenterAuthentication()
```
* **Option :** With completion 
```swift
    EasyGameCenter.showGameCenterAuthentication { 
        (result) -> Void in
        if result {
            println("Game Center Authentication is open")
        }
    }
```
##Show custom banner
* **Show custom banner Game Center with completion**
* **Option :** Without completion 
```swift
    EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...")
```
* **Option :** With completion 
```swift
    EasyGameCenter.showCustomBanner(title: "Title", description: "My Description...") { 
        () -> Void in
        println("Custom Banner is finish to Show")
    }
```
##Show custom dialog
* **Show custom dialog Game Center Authentication with completion**
* **Option :** Without completion
```swift
    EasyGameCenter.openDialogGameCenterAuthentication(
        titre: Title", 
        message: "Please login you Game Center", 
        buttonOK: "Cancel", 
        buttonOpenGameCenterLogin: "Open Game Center")
```
* **Option :** With completion
```swift
    EasyGameCenter.openDialogGameCenterAuthentication(title: "Game Center", message: "Open ?", buttonOK: "No", buttonOpenGameCenterLogin: "Yes") {
        (openGameCenterAuthentification) -> Void in
        if openGameCenterAuthentification {
            println("\n[Easy Game Center] Open Game Center Authentification\n")
        } else {
            println("\n[Easy Game Center] Not open Game Center Authentification\n")
        }
    }
```
#Achievements Methods
<p align="center">
        <img src="http://g.recordit.co/K1I3O6BEXq.gif" height="500" width="280" />
</p>
##Progress Achievements
* **Add progress to an Achievement with show banner**
* **Option :** Report achievement 
```swift
    EasyGameCenter.reportAchievement(progress: 42.00, achievementIdentifier: "Identifier")
```
* **Option :** Without show banner 
```swift 
    EasyGameCenter.reportAchievement(progress: 42.00, achievementIdentifier: "Identifier", showBannnerIfCompleted: false)
```
* **Option :** Add progress to existing (addition to the old)
```swift
    EasyGameCenter.reportAchievement(progress: 42.00, achievementIdentifier: "Identifier", addToExisting: true)
```
* **Option :** Without show banner & add progress to existing (addition to the old)
```swift
    EasyGameCenter.reportAchievement(progress: 42.00, achievementIdentifier: "Identifier", showBannnerIfCompleted: false ,addToExisting: true)
```
##If Achievement completed 
* **Is completed Achievement**
```swift
    if EasyGameCenter.isAchievementCompleted(achievementIdentifier: "Identifier") {
        println("\n[Easy Game Center]Yes\n")
    } else {
        println("\n[Easy Game Center] No\n")
    }
```
##Get All Achievements completed for banner not show
* **Get All Achievements completed and banner not show with completion**
```swift
    if let achievements : [GKAchievement] = EasyGameCenter.getAchievementCompleteAndBannerNotShowing() {
        for oneAchievement in achievements  {
            println("\n[Easy Game Center] Achievement where banner not show \(oneAchievement.identifier)\n")
        }
    } else {
        println("\n[Easy Game Center] No Achievements with banner not showing\n")
    }
```
##Show all Achievements completed for banner not show
* **Show All Achievements completed and banner not show with completion**
* **Option :** Without completion 
```swift
    EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing()
```
* **Option :** With completion 
```swift
    EasyGameCenter.showAllBannerAchievementCompleteForBannerNotShowing { 
        (achievementShow) -> Void in
        if let achievementIsOK = achievementShow {
            println("\n[Easy Game Center] Achievement show is \(achievementIsOK.identifier)\n")
        } else {
            println("\n[Easy Game Center] No Achievements with banner not showing\n")
        }
    }
```
## Get all Achievements GKAchievementDescription
* **Get all achievements descriptions (GKAchievementDescription) with completion**
```swift
    EasyGameCenter.getGKAllAchievementDescription {
        (arrayGKAD) -> Void in
        if let arrayAchievementDescription = arrayGKAD {
            for achievement in arrayAchievementDescription  {
                println("\n[Easy Game Center] ID : \(achievement.identifier)\n")
                println("\n[Easy Game Center] Title : \(achievement.title)\n")
                println("\n[Easy Game Center] Achieved Description : \(achievement.achievedDescription)\n")
                println("\n[Easy Game Center] Unachieved Description : \(achievement.unachievedDescription)\n")
            }
        }
    }
```
##Get Achievements GKAchievement
* **Get One Achievement (GKAchievement)**
```swift
    if let achievement = EasyGameCenter.getAchievementForIndentifier(identifierAchievement: "AchievementIdentifier") {
        println("\n[Easy Game Center] ID : \(achievement.identifier)\n")
    }
```
##Get Achievements GKAchievement GKAchievementDescription (Tuple)
* **Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement**
```swift
    EasyGameCenter.getTupleGKAchievementAndDescription(achievementIdentifier: "AchievementIdentifier") {            
        (tupleGKAchievementAndDescription) -> Void in
        if let tupleInfoAchievement = tupleGKAchievementAndDescription {
            // Extract tuple
            let gkAchievementDescription = tupleInfoAchievement.gkAchievementDescription
            let gkAchievement = tupleInfoAchievement.gkAchievement
            // The title of the achievement.
            println("\n[Easy Game Center] Title : \(gkAchievementDescription.title)\n")
            // The description for an unachieved achievement.
            println("\n[Easy Game Center] Achieved Description : \(gkAchievementDescription.achievedDescription)\n")
        }
    }
```
##Achievement progress
* **Get Progress to an achievement**
```swift
    let progressAchievement = EasyGameCenter.getProgressForAchievement(achievementIdentifier: "AchievementIdentifier")
```
##Reset all Achievements
* **Reset all Achievement**
* **Option :** Without completion 
```swift
    EasyGameCenter.resetAllAchievements()
```
```swift
    EasyGameCenter.resetAllAchievements { 
        (achievementReset) -> Void in
        println("\n[Easy Game Center] ID : \(achievementReset.identifier)\n")
    }
```
#Leaderboards
##Report
* **Report Score Leaderboard**
```swift
    EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "LeaderboardIdentifier", score: 100)
```
##Get GKLeaderboard
* **Get GKLeaderboard with completion**
```swift
    EasyGameCenter.getGKLeaderboard { 
        (resultArrayGKLeaderboard) -> Void in
        if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard {
            for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
                println("\n[Easy Game Center] ID : \(oneGKLeaderboard.identifier)\n")
                println("\n[Easy Game Center] Title :\(oneGKLeaderboard.title)\n")
                println("\n[Easy Game Center] Loading ? : \(oneGKLeaderboard.loading)\n")
            }
        }
    }
```
##Get GKScore
* **Get GKScore Leaderboard with completion**
```swift
    EasyGameCenter.getGKScoreLeaderboard(leaderboardIdentifier: "LeaderboardIdentifier") {
        (resultGKScore) -> Void in
        if let resultGKScoreIsOK = resultGKScore as GKScore? {
            println("\n[Easy Game Center] Leaderboard Identifier : \(resultGKScoreIsOK.leaderboardIdentifier)\n")
            println("\n[Easy Game Center] Date : \(resultGKScoreIsOK.date)\n")
            println("\n[Easy Game Center] Rank :\(resultGKScoreIsOK.rank)\n")
            println("\n[Easy Game Center] Hight Score : \(resultGKScoreIsOK.value)\n")
        }
    }
```
##Get Hight Score (Tuple)
* **Get Hight Score Leaderboard with completion, (Tuple of name,score,rank)**
```swift
    EasyGameCenter.getHighScore(leaderboardIdentifier: "LeaderboardIdentifier") {
        (tupleHighScore) -> Void in
        //(playerName:String, score:Int,rank:Int)?
        if let tupleIsOk = tupleHighScore {
            println("\n[Easy Game Center] Player name : \(tupleIsOk.playerName)\n")
            println("\n[Easy Game Center] Score : \(tupleIsOk.score)\n")
            println("\n[Easy Game Center] Rank :\(tupleIsOk.rank)\n")
        }
    }
```
#MultiPlayer
<p align="center">
        <img src="http://g.recordit.co/ApqB4QkOEv.gif" height="500" width="280" />
</p>

###Protocol Easy Game Center
* **Description :** You should add **EasyGameCenterDelegate** protocol if you want use delegate functions (**easyGameCenterMatchStarted,easyGameCenterMatchRecept,easyGameCenterMatchEnded,easyGameCenterMatchCancel**)
* **Option :** It is optional (if you do not use the functions, do not add)
```swift
    class ExampleViewController: UIViewController,EasyGameCenterDelegate { }
```
##Delegate function for listen MultiPlayer
###Listener When Match Started 
* **Description :** This function is call when the match Started
* **Option :** It is optional 
```swift
    func easyGameCenterMatchStarted() {
        println("\n[MultiPlayerActions] MatchStarted")
    }
```
###Listener When Match Recept Data
* **Description :** This function is call when player send data to all player
* **Option :** It is optional 
```swift
    func easyGameCenterMatchRecept(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        // See Packet 
        let autre =  Packet.unarchive(data)
        println("\n[MultiPlayerActions] Recept From player = \(playerID)")
        println("\n[MultiPlayerActions] Recept Packet.name = \(autre.name)")
        println("\n[MultiPlayerActions] Recept Packet.index = \(autre.index)")
    }
```
###Listener When Match End
* **Description :** This function is call when the match is Ended
* **Option :** It is optional 
```swift
    func easyGameCenterMatchEnded() {
        println("\n[MultiPlayerActions] MatchEnded")
    }
```
###Listener When Match Cancel
* **Description :** This function is call when the match is cancel by the local Player
* **Option :** It is optional 
```swift
    func easyGameCenterMatchCancel() {
        println("\n[MultiPlayerActions] Match cancel")
    }
```
#MultiPlayer method
##Find player By number of player
* **Find Player By min and max player**
```swift
    EasyGameCenter.findMatchWithMinPlayers(2, maxPlayers: 4)
```
##Send Data to all Player
* **Send Data to all Player (NSData)**
```swift
    // Example Struc
    var myStruct = Packet(name: "My Data to Send !", index: 1234567890, numberOfPackets: 1)
    
    //Send Data
    EasyGameCenter.sendDataToAllPlayers(myStruct.archive(), modeSend: .Reliable): 4)
```
##Get Player in match
* **Get Player in match return Set**
```swift
    if let players = EasyGameCenter.getPlayerInMatch() {
        for player in players{
            println(player.alias)
        }
    }
```
##Get match
* **Get current match**
```swift
    if let match = EasyGameCenter.getMatch() {
        print(match)
    }
```
##Disconnect Match / Stop
* **Disconnect Match or Stop for send data to all player in match**
```swift
    EasyGameCenter.disconnectMatch()
```
#Other methods Game Center
##Player identified to Game Center
* **Is player identified to gameCenter**
```swift
    if EasyGameCenter.isPlayerIdentifiedToGameCenter() { /* Player identified */ } 
```
##Get Local Player
* **Get local Player (GKLocalPlayer)**
```swift
    let localPlayer = EasyGameCenter.getLocalPlayer()
```
##Get information on Local Player
```swift
    EasyGameCenter.getlocalPlayerInformation {
        (playerInformationTuple) -> () in
        //playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)
            
        if let typleInformationPlayer = playerInformationTuple {
                
            self.PlayerID.text = "Player ID : \(typleInformationPlayer.playerID)"
            self.Name.text = "Name : \(typleInformationPlayer.alias)"
            self.PlayerAuthentified.text = "Player Authentified : True"
                
            if let haveProfilPhoto = typleInformationPlayer.profilPhoto {
                self.PlayerProfil.image = haveProfilPhoto
            }
                
        }
    }
```
#NetWork
* **Is Connected to NetWork**
```swift
    if EasyGameCenter.isConnectedToNetwork() { /* You have network */ } 
```
#Debug Mode
* **If you doesn't want see message of Easy Game Center**
```swift
    // If you doesn't want see message Easy Game Center, delete this ligne
    // EasyGameCenter.debugMode = true
```
### Legacy support
For support of iOS 7+ & iOS 8+ 

[@RedWolfStudioFR](https://twitter.com/RedWolfStudioFR) 

[@YannickSteph](https://twitter.com/YannickSteph)

Yannick Stephan works hard to have as high feature parity with **Easy Game Center** as possible. 

### License
The MIT License (MIT)

Copyright (c) 2015 Red Wolf Studio, Yannick Stephan

[Red Wolf Studio](http://www.redwolfstudio.fr)

[Yannick Stephan](http://yannickstephan.com)
