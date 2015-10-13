//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 7.0+ & iOS 8.0+
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Red Wolf Studio & Yannick Stephan
//  http://www.redwolfstudio.fr
//  http://yannickstephan.com
//  Version 1.5 for Swift 2.0

import Foundation
import GameKit
import SystemConfiguration

/**
TODO List
- REMEMBER report plusieur score  pour plusieur leaderboard  en array
*/

// Protocol Easy Game Center
@objc protocol EGCDelegate:NSObjectProtocol {
    /**
    Authentified, Delegate Easy Game Center
    */
    optional func EGCAuthentified(authentified:Bool)
    /**
    Not Authentified, Delegate Easy Game Center
    */
    //optional func EGCNotAuthentified()
    /**
    Achievementes in cache, Delegate Easy Game Center
    */
    optional func EGCInCache()
    /**
    Method called when a match has been initiated.
    */
    optional func EGCMatchStarted()
    /**
    Method called when the device received data about the match from another device in the match.
    
    - parameter match:          GKMatch
    - parameter didReceiveData: NSData
    - parameter fromPlayer:     String
    */
    optional func EGCMatchRecept(match: GKMatch, didReceiveData: NSData, fromPlayer: String)
    /**
    Method called when the match has ended.
    */
    optional func EGCMatchEnded()
    /**
    Cancel match
    */
    optional func EGCMatchCancel()
}

// MARK: - Public Func
extension EGC {
    /**
    CheckUp Connection the new
    
    - returns: Bool Connection Validation
    
    */
    static var isConnectedToNetwork: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
}

/// Easy Game Center Swift
public class EGC: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    /*####################################################################################################*/
    /*                                    Private    Instance                                             */
    /*####################################################################################################*/
    
    /// Achievements GKAchievement Cache
    private var achievementsCache:[String:GKAchievement] = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    private var achievementsDescriptionCache = [String:GKAchievementDescription]()
    
    /// Save for report late when network working
    private var achievementsCacheShowAfter = [String:String]()
    
    /// When is load
  //  private var loginIsLoading: Bool = false
    
    /// When is caching
    private var inCacheIsLoading: Bool = false
    
    /// Checkup net and login to GameCenter when have Network
    private var timerNetAndPlayer:NSTimer?
    
    /// Debug mode for see message
    private var debugModeGetSet:Bool = false
    
    /// The match object provided by GameKit.
    public var match: GKMatch?
    public var playersInMatch = Set<GKPlayer>()
    public var invitedPlayer: GKPlayer?
    public var invite: GKInvite?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*####################################################################################################*/
    /*                                    Singleton Public Instance                                       */
    /*####################################################################################################*/
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authenticationChanged", name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
    /**
    Static EGC
    
    */
    struct Static {
        /// Async EGC
        static var onceToken: dispatch_once_t = 0
        /// Instance of EGC
        static var instance: EGC? = nil
        /// Delegate of UIViewController
        static weak var delegate: UIViewController? = nil
    }
    /**
    Start Singleton GameCenter Instance
    
    */
    public class func sharedInstance(delegate:UIViewController)-> EGC {
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = EGC()
                Static.delegate = delegate
                Static.instance!.loginPlayerToGameCenter()
            }
        }
        return Static.instance!
    }
    /// Delegate UIViewController
    class var delegate: UIViewController {
        get {
            do {
                let delegateInstance = try EGC.sharedInstance.getDelegate()
                return delegateInstance
            } catch  {
                EGCError.NoDelegate.errorCall()
                fatalError("Dont work\(error)")
            }
        }
        
        set {
            guard newValue != EGC.delegate else {
                return
            }
            Static.delegate = EGC.delegate
            
            EGC.debug("\n[Easy Game Center] New delegate UIViewController is \(_stdlib_getDemangledTypeName(newValue))\n")
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func / Object                                          */
    /*####################################################################################################*/
    
    public class var debugMode:Bool {
        get {
            return EGC.sharedInstance.debugModeGetSet
        }
        set {
            EGC.sharedInstance.debugModeGetSet = newValue
        }
    }
    /**
    If player is Identified to Game Center
    
    - returns: Bool is identified
    
    */
    static var isPlayerIdentified: Bool {
        get {
             return GKLocalPlayer.localPlayer().authenticated
        }
    }
  //  class func isPlayerIdentified -> Bool { }
    /**
    Get local player (GKLocalPlayer)
    
    - returns: Bool True is identified
    
    */
    static var localPayer: GKLocalPlayer {
        get {
            return GKLocalPlayer.localPlayer()
        }
    }
 //   class func getLocalPlayer() -> GKLocalPlayer {  }
    /**
    Get local player Information (playerID,alias,profilPhoto)
    
    :completion: Tuple of type (playerID:String,alias:String,profilPhoto:UIImage?)
    
    */
    class func getlocalPlayerInformation(completion completionTuple: (playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)?) -> ()) {
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EGC.isConnectedToNetwork else {
                completionTuple(playerInformationTuple: nil)
                EGCError.NoConnection.errorCall()
                return
            }
            
            guard EGC.isPlayerIdentified else {
                completionTuple(playerInformationTuple: nil)
                EGCError.NoLogin.errorCall()
                return
            }
            
            EGC.localPayer.loadPhotoForSize(GKPhotoSizeNormal, withCompletionHandler: {
                (image, error) -> Void in
                
                var playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)
                playerInformationTuple.profilPhoto = nil
                
                playerInformationTuple.playerID = EGC.localPayer.playerID!
                playerInformationTuple.alias = EGC.localPayer.alias!
                if error == nil { playerInformationTuple.profilPhoto = image }
                completionTuple(playerInformationTuple: playerInformationTuple)
            })
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Show                                              */
    /*####################################################################################################*/
    
    /**
    Show Game Center Player Achievements
    
    - parameter completion: Viod just if open Game Center Achievements
    */
    public class func showGameCenterAchievements(completion: ((isShow:Bool) -> Void)? = nil) {
        
        let delegate = EGC.delegate as UIViewController
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NoLogin.errorCall()
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance!
        gc.viewState = GKGameCenterViewControllerState.Achievements
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            if completion != nil { completion!(isShow:true) }
        })
    }
    /**
    Show Game Center Leaderboard
    
    - parameter leaderboardIdentifier: Leaderboard Identifier
    - parameter completion:            Viod just if open Game Center Leaderboard
    */
    public class func showGameCenterLeaderboard(leaderboardIdentifier leaderboardIdentifier :String, completion: ((isShow:Bool) -> Void)? = nil) {
        
        let delegate = EGC.delegate as UIViewController
        let instanceEGC = EGC.sharedInstance
        
        var validation:Bool = true
        guard leaderboardIdentifier != "" else {
            EGCError.Empty.errorCall()
            validation = false
            // TODO break loginPlayerToGameCenter ont le coupe
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            validation = false
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.NoLogin.errorCall()
            validation = false
            return
        }
        defer {
            if completion != nil && !validation { completion!(isShow:false) }
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = instanceEGC
        gc.leaderboardIdentifier = leaderboardIdentifier
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            
            if completion != nil { completion!(isShow:true) }
        })
        
    }
    /**
    Show Game Center Challenges
    
    - parameter completion: Viod just if open Game Center Challenges
    
    */
    public class func showGameCenterChallenges(completion: ((isShow:Bool) -> Void)? = nil) {
        
        let delegate = EGC.delegate as UIViewController
        let instanceEGC = EGC.sharedInstance
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NoLogin.errorCall()
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate =  instanceEGC
        gc.viewState = GKGameCenterViewControllerState.Challenges
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            
            if completion != nil { completion!(isShow:true) }
        })
        
    }
    /**
    Show banner game center
    
    - parameter title:       title
    - parameter description: description
    - parameter completion:  When show message
    
    */
    public class func showCustomBanner(title title:String, description:String,completion: (() -> Void)? = nil) {
        guard EGC.isPlayerIdentified else {
            EGCError.NoLogin.errorCall()
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: {
                () -> Void in
                if completion != nil { completion!() }
            })
        }
        
    }
    /**
    Show page Authentication Game Center
    
    - parameter completion: Viod just if open Game Center Authentication
    
    */
    public class func showGameCenterAuthentication(completion: ((result:Bool) -> Void)? = nil) {
        if completion != nil {
            completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!))
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func LeaderBoard                                       */
    /*####################################################################################################*/
    
    /**
    Get Leaderboards
    
    - parameter completion: return [GKLeaderboard] or nil
    
    */
    public class func getGKLeaderboard(completion completion: ((resultArrayGKLeaderboard:Set<GKLeaderboard>?) -> Void)) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EGC.isConnectedToNetwork else {
                completion(resultArrayGKLeaderboard: nil)
                EGCError.NoConnection.errorCall()
                return
            }
            
            guard EGC.isPlayerIdentified else {
                completion(resultArrayGKLeaderboard: nil)
                EGCError.NoLogin.errorCall()
                return
            }
            
            GKLeaderboard.loadLeaderboardsWithCompletionHandler {
                (leaderboards:[GKLeaderboard]?, error:NSError?) ->
                Void in
                
                guard EGC.isPlayerIdentified else {
                    completion(resultArrayGKLeaderboard: nil)
                    EGCError.CantLoadLeaderboards.errorCall()
                    return
                }
                
                guard let leaderboardsIsArrayGKLeaderboard = leaderboards as [GKLeaderboard]? else {
                    completion(resultArrayGKLeaderboard: nil)
                    EGCError.CantLoadLeaderboards.errorCall()
                    return
                }
                
                completion(resultArrayGKLeaderboard: Set(leaderboardsIsArrayGKLeaderboard))
                
            }
        }
    }
    /**
    Reports a  score to Game Center
    
    - parameter The: score Int
    - parameter Leaderboard: identifier
    - parameter completion: (bool) when the score is report to game center or Fail
    
    
    */
    public class func reportScoreLeaderboard(leaderboardIdentifier leaderboardIdentifier:String, score: Int) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EGC.isConnectedToNetwork else {
                EGCError.NoConnection.errorCall()
                // TODO break loginPlayerToGameCenter ont le coupe
                return
            }
            
            guard EGC.isPlayerIdentified else {
                EGCError.NoLogin.errorCall()
                // TODO break loginPlayerToGameCenter ont le coupe
                return
            }
            
            let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
            gkScore.value = Int64(score)
            gkScore.shouldSetDefaultLeaderboard = true
            GKScore.reportScores([gkScore], withCompletionHandler: nil)
        }
    }
    /**
    Get High Score for leaderboard identifier
    
    - parameter leaderboardIdentifier: leaderboard ID
    - parameter completion:            Tuple (playerName: String, score: Int, rank: Int)
    
    */
    public class func getHighScore(leaderboardIdentifier leaderboardIdentifier:String, completion:((playerName:String, score:Int,rank:Int)? -> Void)) {
        EGC.getGKScoreLeaderboard(leaderboardIdentifier: leaderboardIdentifier, completion: {
            (resultGKScore) -> Void in
            
            guard let valGkscore = resultGKScore else {
                completion(nil)
                return
            }
            
            let rankVal = valGkscore.rank
            let nameVal  = EGC.localPayer.alias!
            let scoreVal  = Int(valGkscore.value)
            completion((playerName: nameVal, score: scoreVal, rank: rankVal))
            
        })
    }
    /**
    Get GKScoreOfLeaderboard
    
    - parameter completion: GKScore or nil
    
    */
    public class func  getGKScoreLeaderboard(leaderboardIdentifier leaderboardIdentifier:String, completion:((resultGKScore:GKScore?) -> Void)) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard EGC.isConnectedToNetwork else {
                EGCError.NoConnection.errorCall()
                completion(resultGKScore: nil)
                return
            }
            
            guard EGC.isPlayerIdentified else {
                EGCError.NoLogin.errorCall()
                completion(resultGKScore: nil)
                return
            }
            
            let leaderBoardRequest = GKLeaderboard()
            leaderBoardRequest.identifier = leaderboardIdentifier
            
            leaderBoardRequest.loadScoresWithCompletionHandler {
                (resultGKScore, error) ->Void in
                
                if error != nil || resultGKScore == nil {
                    completion(resultGKScore: nil)
                    
                } else  {
                    completion(resultGKScore: leaderBoardRequest.localPlayerScore)
                }
            }
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Achievements                                      */
    /*####################################################################################################*/
    /**
    Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
    - parameter achievementIdentifier: Identifier Achievement
    
    - returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    
    */
    public class func getTupleGKAchievementAndDescription(achievementIdentifier achievementIdentifier:String,completion completionTuple: ((tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let instanceEGC = EGC.sharedInstance
            
            guard EGC.isPlayerIdentified else {
                EGCError.NoLogin.errorCall()
                completionTuple(tupleGKAchievementAndDescription: nil)
                return
            }
            
            let achievementGKScore = instanceEGC.achievementsCache[achievementIdentifier]
            let achievementGKDes =  instanceEGC.achievementsDescriptionCache[achievementIdentifier]
            
            if achievementGKScore != nil && achievementGKDes != nil {
                completionTuple(tupleGKAchievementAndDescription: (achievementGKScore!,achievementGKDes!))
            } else {
                if instanceEGC.achievementsCache.count > 0 {
                    EGC.debug("\n[EGC] Achievements ID not real\n")
                } else {
                    EGC.debug("\n[EGC] Haven't load cache\n")
                }
                completionTuple(tupleGKAchievementAndDescription: nil)
            }
        }
    }
    /**
    Get Achievement
    
    - parameter identifierAchievement: Identifier achievement
    
    - returns: GKAchievement Or nil if not exist
    
    */
    public class func getAchievementForIndentifier(identifierAchievement identifierAchievement : NSString) -> GKAchievement? {
        if identifierAchievement != "" {
            let instanceEGC = EGC.sharedInstance
            guard EGC.isPlayerIdentified else {
                EGCError.NoLogin.errorCall()
                return nil
            }
            
            if let achievementFind = instanceEGC.achievementsCache[identifierAchievement as String] {
                return achievementFind
            } else {
                if instanceEGC.achievementsCache.count == 0 {
                    EGC.debug("\n[Easy Game Center] Not have cache\n")
                } else {
                    EGC.debug("\n[Easy Game Center] Achievement ID \(identifierAchievement) is not real \n")
                }
            }
            
        }
        return nil
    }
    /**
    Add progress to an achievement
    
    - parameter progress:               Progress achievement Double (ex: 10% = 10.00)
    - parameter achievementIdentifier:  Achievement Identifier
    - parameter showBannnerIfCompleted: if you want show banner when now or not when is completed
    - parameter completionIsSend:       Completion if is send to Game Center
    
    */
    public class func reportAchievement( progress progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool = true ,addToExisting: Bool = false) {
        if achievementIdentifier != "" {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                if !EGC.isAchievementCompleted(achievementIdentifier: achievementIdentifier) {
                    let instanceEGC = EGC.sharedInstance
                    
                    if let achievement = EGC.getAchievementForIndentifier(identifierAchievement: achievementIdentifier) {
                        
                        let currentValue = achievement.percentComplete
                        let newProgress: Double = !addToExisting ? progress : progress + currentValue
                        
                        achievement.percentComplete = newProgress
                        
                        /* show banner only if achievement is fully granted (progress is 100%) */
                        if achievement.completed && showBannnerIfCompleted {
                            EGC.debug("[Easy Game Center] Achievement \(achievementIdentifier) completed")
                            
                            if EGC.isConnectedToNetwork {
                                achievement.showsCompletionBanner = true
                            } else {
                                //oneAchievement.showsCompletionBanner = true << Bug For not show two banner
                                // Force show Banner when player not have network
                                EGC.getTupleGKAchievementAndDescription(achievementIdentifier: achievementIdentifier, completion: {
                                    (tupleGKAchievementAndDescription) -> Void in
                                    
                                    if let tupleIsOK = tupleGKAchievementAndDescription {
                                        let title = tupleIsOK.gkAchievementDescription.title
                                        let description = tupleIsOK.gkAchievementDescription.achievedDescription
                                        
                                        EGC.showCustomBanner(title: title!, description: description!)
                                    }
                                })
                            }
                        }
                        if  achievement.completed && !showBannnerIfCompleted {
                            instanceEGC.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
                        }
                        instanceEGC.reportAchievementToGameCenter(achievement: achievement)
                    }
                } else {
                    EGC.debug("[Easy Game Center] Achievement is already completed")
                }
            }
        }
    }
    /**
    Get GKAchievementDescription
    
    - parameter completion: return array [GKAchievementDescription] or nil
    
    */
    public class func getGKAllAchievementDescription(completion completion: ((arrayGKAD:Set<GKAchievementDescription>?) -> Void)){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let instanceEGC = EGC.sharedInstance
            if EGC.isPlayerIdentified {
                if instanceEGC.achievementsDescriptionCache.count > 0 {
                    var tempsEnvoi = Set<GKAchievementDescription>()
                    for achievementDes in instanceEGC.achievementsDescriptionCache {
                        tempsEnvoi.insert(achievementDes.1)
                    }
                    completion(arrayGKAD: tempsEnvoi)
                } else {
                    EGC.debug("\n[Easy Game Center] Not have cache\n")
                }
            }
        }
    }
    /**
    If achievement is Completed
    
    - parameter Achievement: Identifier
    :return: (Bool) if finished
    
    */
    public class func isAchievementCompleted(achievementIdentifier achievementIdentifier: String) -> Bool{
        if let achievement = EGC.getAchievementForIndentifier(identifierAchievement: achievementIdentifier) {
            if achievement.completed || achievement.percentComplete == 100.00 {
                return true
            }
        }
        return false
    }
    /**
    Get Achievements Completes during the game and banner was not showing
    
    - returns: [String : GKAchievement] or nil
    
    */
    public class func getAchievementCompleteAndBannerNotShowing() -> [GKAchievement]? {
        let instanceEGC = EGC.sharedInstance
        
        let achievements : [String:String] = instanceEGC.achievementsCacheShowAfter
        var achievementsTemps = [GKAchievement]()
        
        if achievements.count > 0 {
            
            for achievement in achievements  {
                if let achievementExtract = EGC.getAchievementForIndentifier(identifierAchievement: achievement.1) {
                    if achievementExtract.completed && achievementExtract.showsCompletionBanner == false {
                        achievementsTemps.append(achievementExtract)
                    }
                }
            }
            return achievementsTemps
        }
        return nil
    }
    /**
    Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    
    - parameter completion: if is Show Achievement banner
    (Bug Game Center if you show achievement by showsCompletionBanner = true when you report and again you show showsCompletionBanner = false is not show)
    
    */
    public class func showAllBannerAchievementCompleteForBannerNotShowing(completion: ((achievementShow:GKAchievement?) -> Void)? = nil) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let instanceEGC = EGC.sharedInstance
            
            if !EGC.isPlayerIdentified {
                EGC.debug("\n[Easy Game Center] Player not identified\n")
                if completion != nil { completion!(achievementShow: nil) }
            } else {
                if let achievementNotShow: [GKAchievement] = EGC.getAchievementCompleteAndBannerNotShowing() {
                    for achievement in achievementNotShow  {
                        
                        EGC.getTupleGKAchievementAndDescription(achievementIdentifier: achievement.identifier!, completion: {
                            (tupleGKAchievementAndDescription) -> Void in
                            
                            if let tupleOK = tupleGKAchievementAndDescription {
                                //oneAchievement.showsCompletionBanner = true
                                let title = tupleOK.gkAchievementDescription.title
                                let description = tupleOK.gkAchievementDescription.achievedDescription
                                
                                EGC.showCustomBanner(title: title!, description: description!, completion: { () -> Void in
                                    if completion != nil { completion!(achievementShow: achievement) }
                                })
                            } else {
                                if completion != nil { completion!(achievementShow: nil) }
                            }
                        })
                    }
                    instanceEGC.achievementsCacheShowAfter.removeAll(keepCapacity: false)
                } else {
                    if completion != nil { completion!(achievementShow: nil) }
                }
            }
        }
    }
    /**
    Get progress to an achievement
    
    - parameter Achievement: Identifier
    
    - returns: Double or nil (if not find)
    
    */
    public class func getProgressForAchievement(achievementIdentifier achievementIdentifier:String) -> Double? {
        let instanceEGC = EGC.sharedInstance
        if EGC.isPlayerIdentified {
            if let achievementInArrayInt = instanceEGC.achievementsCache[achievementIdentifier]?.percentComplete {
                return achievementInArrayInt
            } else {
                EGC.debug("\n[EGC] Haven't cache\n")
            }
        } else {
            EGC.debug("\n[EGC] Player not identified\n")
        }
        return nil
    }
    /**
    Remove All Achievements
    
    completion: return GKAchievement reset or Nil if game center not work
    sdsds
    */
    public class func resetAllAchievements( completion:  ((achievementReset:GKAchievement?) -> Void)? = nil)  {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            if EGC.isPlayerIdentified {
                GKAchievement.resetAchievementsWithCompletionHandler({
                    (error:NSError?) -> Void in
                    if error != nil {
                        EGC.debug("\n[Easy Game Center] Couldn't Reset achievement (Send data error) \n")
                    } else {
                        let gameCenter = EGC.Static.instance!
                        for lookupAchievement in gameCenter.achievementsCache {
                            let achievementID = lookupAchievement.0
                            let achievementGK = lookupAchievement.1
                            achievementGK.percentComplete = 0
                            achievementGK.showsCompletionBanner = false
                            if completion != nil { completion!(achievementReset:achievementGK) }
                            EGC.debug("\n[Easy Game Center] Reset achievement (\(achievementID))\n")
                        }
                    }
                })
            } else {
                EGC.debug("\n[Easy Game Center] Player not identified\n")
                if completion != nil { completion!(achievementReset: nil) }
            }
        }
    }
    
    /*####################################################################################################*/
    /*                                          Mutliplayer                                               */
    /*####################################################################################################*/
    /**
    Find player By number
    
    - parameter minPlayers: Int
    - parameter maxPlayers: Max
    */
    public class func findMatchWithMinPlayers(minPlayers: Int, maxPlayers: Int) {
        
        let instance = EGC.sharedInstance
        
        do {
            let delegateUI = try instance.getDelegate()
            try instance.getDelegateEGC()
            
            EGC.disconnectMatch()
            
            let request = GKMatchRequest()
            request.minPlayers = minPlayers
            request.maxPlayers = maxPlayers
            
            
            let controlllerGKMatch = GKMatchmakerViewController(matchRequest: request)
            controlllerGKMatch!.matchmakerDelegate = EGC.sharedInstance
            
            var delegeteParent:UIViewController? = delegateUI.parentViewController
            if delegeteParent == nil {
                delegeteParent = delegateUI
            }
            delegeteParent!.presentViewController(controlllerGKMatch!, animated: true, completion: nil)
            
        } catch EGCError.DelegateNotHaveProtocolEGCDelegate {
            EGCError.DelegateNotHaveProtocolEGCDelegate.errorCall()
            
        } catch EGCError.NoInstance {
            EGCError.NoInstance.errorCall()
            
        } catch {
            fatalError("Dont work\(error)")
        }
    }
    /**
    Get Player in match
    
    - returns: Set<GKPlayer>
    */
    public class func getPlayerInMatch() -> Set<GKPlayer>? {
        let instanceEGC = EGC.sharedInstance
        
        if instanceEGC.match == nil {
            EGC.debug("\n[Easy Game Center] No Match\n")
        } else {
            if instanceEGC.playersInMatch.count > 0 {
                return instanceEGC.playersInMatch
            }
        }
        return nil
    }
    /**
    Deconnect the Match
    */
    public class func disconnectMatch() {
        let instanceEGC = EGC.sharedInstance
        
        if instanceEGC.match != nil {
            EGC.debug("\n[Easy Game Center] Disconnect from match \n")
            instanceEGC.match!.disconnect()
            instanceEGC.match = nil
            guard let delegateEGC = self.delegate  as? EGCDelegate else {
                return
            }
            delegateEGC.EGCMatchEnded?()
        }
    }
    /**
    Get match
    
    - returns: GKMatch or nil if haven't match
    */
    public class func getMatch() -> GKMatch? {
        let instanceEGC = EGC.sharedInstance
        if instanceEGC.match == nil {
            EGC.debug("\n[Easy Game Center] No Match\n")
        } else {
            return instanceEGC.match!
        }
        return nil
    }
    /**
    player in net
    */
    @available(iOS 8.0, *)
    private func lookupPlayers() {
        let instance = EGC.sharedInstance
        
        do {
            let delegateEGC = try instance.getDelegateEGC()
            
            guard instance.match != nil else {
                EGC.debug("\n[Easy Game Center] No Match\n")
                return
            }
            
            let playerIDs = match!.players.map { ($0 as GKPlayer).playerID! }
            
            /* Load an array of player */
            GKPlayer.loadPlayersForIdentifiers(playerIDs) {
                (players, error) -> Void in
                
                guard error == nil else {
                    EGC.debug("[Easy Game Center] Error retrieving player info: \(error!.localizedDescription)")
                    EGC.disconnectMatch()
                    return
                }
                
                if let arrayPlayers = players as [GKPlayer]? { self.playersInMatch = Set(arrayPlayers) }
                
                GKMatchmaker.sharedMatchmaker().finishMatchmakingForMatch(self.match!)
                delegateEGC.EGCMatchStarted?()
                
            }
        } catch EGCError.DelegateNotHaveProtocolEGCDelegate {
            EGCError.DelegateNotHaveProtocolEGCDelegate.errorCall()
            
            
        } catch EGCError.NoInstance {
            EGCError.NoInstance.errorCall()
            
        } catch {
            fatalError("Dont work\(error)")
            
        }
    }
    
    /**
    Transmits data to all players connected to the match.
    
    - parameter data:     NSData
    - parameter modeSend: GKMatchSendDataMode
    
    :GKMatchSendDataMode Reliable: a.s.a.p. but requires fragmentation and reassembly for large messages, may stall if network congestion occurs
    :GKMatchSendDataMode Unreliable: Preferred method. Best effort and immediate, but no guarantees of delivery or order; will not stall.
    */
    public class func sendDataToAllPlayers(data: NSData!, modeSend:GKMatchSendDataMode) {
        
        let instance = EGC.sharedInstance
        
        do {
            let delegateEGC = try instance.getDelegateEGC()
            
            guard instance.match != nil else {
                EGC.debug("\n[Easy Game Center] No Match\n")
                return
            }
            
            
            do {
                try instance.match!.sendDataToAllPlayers(data, withDataMode: modeSend)
                EGC.debug("\n[Easy Game Center] Succes sending data all Player \n")
            } catch  {
                EGC.disconnectMatch()
                delegateEGC.EGCMatchEnded?()
                EGC.debug("\n[Easy Game Center] Fail sending data all Player\n")
            }
            
        } catch {
            EGCError.DelegateNotHaveProtocolEGCDelegate.errorCall()
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*####################################################################################################*/
    /*                                    Singleton  Private  Instance                                    */
    /*####################################################################################################*/
    
    /**
    ShareInstance Private
    
    - throws: .NoInstance
    
    - returns: Instance of EGC
    */
    class private func getInstance() throws -> EGC {
        guard let instanceEGC = Static.instance else {
            throw EGCError.NoInstance
        }
        return instanceEGC
    }
    /// ShareInstance Private
    class private var sharedInstance : EGC {
        do {
            let instance = try EGC.getInstance()
            return instance
        } catch  {
            EGCError.NoInstance.errorCall()
            fatalError("Dont work\(error)")
        }
    }
    /**
    Delegate UIViewController
    
    
    - throws: .NoDelegate
    
    - returns: UIViewController
    */
    private func getDelegate() throws -> UIViewController {
        guard let delegate = Static.delegate else {
            throw EGCError.NoDelegate
        }
        return delegate
    }
    /**
    Delegate UIViewController repect protocol EGCDelegate
    
    - throws: .DelegateNotHaveProtocolEGCDelegate
    
    - returns: Instance of EGC Delegate Protocol
    */
    private func getDelegateEGC() throws -> EGCDelegate {
        guard let delegateEGC = Static.delegate as? EGCDelegate else {
            throw EGCError.DelegateNotHaveProtocolEGCDelegate
        }
        return delegateEGC
    }
    
    /*####################################################################################################*/
    /*                                            private Start                                           */
    /*####################################################################################################*/
    /**
    Init Implemented by subclasses to initialize a new object
    
    - returns: An initialized object
    */
    //override init() { super.init() }
    
    /**
    Completion for cachin Achievements and AchievementsDescription
    
    - parameter achievementsType: GKAchievement || GKAchievementDescription
    */
    private static func completionCachingAchievements(achievementsType :[AnyObject]?) {
        
        let instance = EGC.sharedInstance
        
        func finish() {
            if instance.achievementsCache.count > 0 && instance.achievementsDescriptionCache.count > 0 {
                do {
                    let _ = try? instance.getDelegateEGC().EGCInCache?()
                }
            }
            instance.inCacheIsLoading = false
        }
        
        
        // Type GKAchievement
        if achievementsType is [GKAchievement] {
            
            guard let arrayGKAchievement = achievementsType as? [GKAchievement] where arrayGKAchievement.count > 0 else {
                return
            }
            
            for anAchievement in arrayGKAchievement where  anAchievement.identifier != nil {
                instance.achievementsCache[anAchievement.identifier!] = anAchievement
            }
            finish()
            
            // Type GKAchievementDescription
        } else if achievementsType is [GKAchievementDescription] {
            
            guard let arrayGKAchievementDes = achievementsType as? [GKAchievementDescription] where arrayGKAchievementDes.count > 0 else {
                EGCError.CantCachingNoAchievements.errorCall()
                return
            }
            
            for anAchievementDes in arrayGKAchievementDes where  anAchievementDes.identifier != nil {
                
                // Add GKAchievement
                if instance.achievementsCache.indexForKey(anAchievementDes.identifier!) == nil {
                    instance.achievementsCache[anAchievementDes.identifier!] = GKAchievement(identifier: anAchievementDes.identifier!)
                    
                }
                // Add CGAchievementDescription
                instance.achievementsDescriptionCache[anAchievementDes.identifier!] = anAchievementDes
            }
            
            GKAchievement.loadAchievementsWithCompletionHandler({
                ( allAchievements:[GKAchievement]?, error:NSError?) -> Void in
                
                guard (error == nil) && allAchievements!.count != 0  else {
                    finish()
                    return
                }
                
                EGC.completionCachingAchievements(allAchievements)
                
            })
        }
    }
    
    
    
    /**
    Load achievements in cache
    (Is call when you init EGC, but if is fail example for cut connection, you can recall)
    And when you get Achievement or all Achievement, it shall automatically cached
    
    */
    private func cachingAchievements() {
        if !self.inCacheIsLoading {
            self.inCacheIsLoading = true
            
            guard EGC.isConnectedToNetwork else {
                self.inCacheIsLoading = false
                EGCError.NoConnection.errorCall()
                return
            }
            guard EGC.isPlayerIdentified else {
                self.inCacheIsLoading = false
                EGCError.NoLogin.errorCall()
                return
            }
            
            // Load GKAchievementDescription
            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler({
                ( achievementsDescription:[GKAchievementDescription]?, error:NSError?) -> Void in
                if  (error != nil) {
                    self.inCacheIsLoading = false
                    EGCError.CantCachingA.errorCall()
                } else {
                    EGC.completionCachingAchievements(achievementsDescription)
                }
            })
        }
    }
    /**
    Login player to GameCenter With Handler Authentification
    This function is recall When player connect to Game Center
    
    - parameter completion: (Bool) if player login to Game Center
    */
    /// Authenticates the user with their Game Center account if possible

    // MARK: Internal functions
    
    internal func authenticationChanged() {
        
        guard let delegateEGC = try? self.getDelegateEGC() else {
            EGCError.NoDelegate.errorCall()
            return
        }
        
        if EGC.isPlayerIdentified {
            delegateEGC.EGCAuthentified?(true)
            print("Authentication changed: player authenticated")
            EGC.sharedInstance.cachingAchievements()
        } else {
            delegateEGC.EGCAuthentified?(false)
            print("Authentication changed: player not authenticated")

        }
    }
    
    private func loginPlayerToGameCenter()  {
        
        guard !EGC.isPlayerIdentified else {
            //    authentified()
            return
        }
        
        guard let delegateEGC = try? self.getDelegateEGC(), delegateVC = delegateEGC as? UIViewController  else {
            EGCError.NoDelegate.errorCall()
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            return
        }

        /**
        Send Authentified

        func authentified() {
          //  self.loginIsLoading = false
            dispatch_async(dispatch_get_main_queue()) {
                 delegateEGC.EGCAuthentified?(true)
                
            }
        }  */
        

      /*  if EGC.isPlayerIdentified {
            
            return
        }*/
        
        /*
print("Authenticating local user...")
if GKLocalPlayer.localPlayer().authenticated == false {
GKLocalPlayer.localPlayer().authenticateHandler = { (view, error) in
if error == nil {
self.authenticated = true
} else {
print("\(error?.localizedDescription)")
}
}
} else {
print("Already authenticated")
}
*/
        //if !loginIsLoading {
       //     self.loginIsLoading = true

            GKLocalPlayer.localPlayer().authenticateHandler = {

                (gameCenterVC, error) in
                /* If got error / Or player not set value for login */
                guard error == nil else {
                  //  self.loginIsLoading = false
                    EGCError.Error(error!.localizedDescription).errorCall()
                    return
                }
                guard let gcVC = gameCenterVC else {
                   // EGCError.NoLogin.errorCall()
                    return
                  /*  guard !EGC.isPlayerIdentified else {
                       // authentified()
                        return
                    }*/
                   /* if EGC.isPlayerIdentified {
                        
                        
                    } else  {
                        //  self.loginIsLoading = false
                        
                    }*/
                    
                   // EGCError.Error(error!.localizedDescription).errorCall()
                  //  return
                }
              //  if error != nil {

                    
                    /* Login to game center need Open page */
                //} else {
                    //if gameCenterVC != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                           /* do {
                                let delegate = try self.getDelegate()*/
                                delegateVC.presentViewController(gcVC, animated: true, completion: nil)
                            /*} catch {
                                //EGCError
                                EGC.debug(error)
                            }*/
                            /*var delegeteParent:UIViewController? = EGC.delegate.parentViewController
                            if delegeteParent == nil {
                                delegeteParent = EGC.delegate
                            }*/
                           // delegeteParent!.presentViewController(gameCenterVC!, animated: true, completion: nil)
                        }
                    //}
               // }
            }
        }
  //  }
    /*####################################################################################################*/
    /*                              Private Timer checkup                                                 */
    /*####################################################################################################*/
    /**
    Function checkup when he have net work login Game Center
    */
    func checkupNetAndPlayer() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.timerNetAndPlayer == nil {
                self.timerNetAndPlayer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkupNetAndPlayer"), userInfo: nil, repeats: true)
            }
            
            if EGC.isConnectedToNetwork {
                self.timerNetAndPlayer!.invalidate()
                self.timerNetAndPlayer = nil
                
                EGC.sharedInstance.loginPlayerToGameCenter()
            }
        }
    }
    
    /*####################################################################################################*/
    /*                                      Private Func Achievements                                     */
    /*####################################################################################################*/
    /**
    Report achievement classic
    
    - parameter achievement: GKAchievement
    */
    private func reportAchievementToGameCenter(achievement achievement:GKAchievement) {
        /* try to report the progress to the Game Center */
        
        GKAchievement.reportAchievements([achievement], withCompletionHandler:  {
            (error:NSError?) -> Void in
            if error != nil { /* Game Center Save Automatique */ }
        })
    }
    /*####################################################################################################*/
    /*                             Public Delagate Game Center                                          */
    /*####################################################################################################*/
    /**
    Dismiss Game Center when player open
    - parameter GKGameCenterViewController:
    
    Override of GKGameCenterControllerDelegate
    
    */
    public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*####################################################################################################*/
    /*                                          GKMatchDelegate                                           */
    /*####################################################################################################*/
    /**
    Called when data is received from a player.
    
    - parameter theMatch: GKMatch
    - parameter data:     NSData
    - parameter playerID: String
    */
    public func match(theMatch: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        
        let instance = EGC.sharedInstance
        
        do {
            let delegateEGC = try instance.getDelegateEGC()
            
            guard instance.match == theMatch else {
                return
            }
            
            delegateEGC.EGCMatchRecept?(theMatch, didReceiveData: data, fromPlayer: playerID)
        } catch {
            EGCError.DelegateNotHaveProtocolEGCDelegate.errorCall()
        }
    }
    /**
    Called when a player connects to or disconnects from the match.
    
    Echange avec autre players
    
    - parameter theMatch: GKMatch
    - parameter playerID: String
    - parameter state:    GKPlayerConnectionState
    */
    public func match(theMatch: GKMatch, player playerID: String, didChangeState state: GKPlayerConnectionState) {
        /* recall when is desconnect match = nil */
        guard self.match == theMatch else { return }
        
        switch state {
            /* Connected */
        case .StateConnected:
            if theMatch.expectedPlayerCount == 0 {
                if #available(iOS 8.0, *) {
                    self.lookupPlayers()
                } else {
                    // Fallback on earlier versions
                }
            }
            
            /* Lost deconnection */
        case .StateDisconnected:
            EGC.disconnectMatch()
        default:
            break
        }
    }
    /**
    Called when the match cannot connect to any other players.
    
    - parameter theMatch: GKMatch
    - parameter error:    NSError
    
    */
    public func match(theMatch: GKMatch, didFailWithError error: NSError?) {
        guard self.match == theMatch else { return }
        
        if error != nil {
            EGC.debug("[Easy Game Center] Match failed with error: \(error!.localizedDescription)")
            EGC.disconnectMatch()
        }
    }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewControllerDelegate                                      */
    /*####################################################################################################*/
    /**
    Called when a peer-to-peer match is found.
    
    - parameter viewController: GKMatchmakerViewController
    - parameter theMatch:       GKMatch
    */
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch theMatch: GKMatch) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        self.match = theMatch
        self.match!.delegate = self
        if match!.expectedPlayerCount == 0 {
            if #available(iOS 8.0, *) {
                self.lookupPlayers()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    /*####################################################################################################*/
    /*                             GKLocalPlayerListener                                                  */
    /*####################################################################################################*/
    /**
    Called when another player accepts a match invite from the local player
    
    - parameter player:         GKPlayer
    - parameter inviteToAccept: GKPlayer
    */
    public func player(player: GKPlayer, didAcceptInvite inviteToAccept: GKInvite) {
        let gkmv = GKMatchmakerViewController(invite: inviteToAccept)
        gkmv!.matchmakerDelegate = self
        
        let delegate = EGC.delegate
        
        var delegeteParent:UIViewController? = delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = delegate
        }
        delegeteParent!.presentViewController(gkmv!, animated: true, completion: nil)
    }
    /**
    Initiates a match from Game Center with the requested players
    
    - parameter player:          The GKPlayer object containing the current player’s information
    - parameter playersToInvite: An array of GKPlayer
    */
    public func player(player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) { }
    
    /**
    Called when the local player starts a match with another player from Game Center
    
    - parameter player:            The GKPlayer object containing the current player’s information
    - parameter playerIDsToInvite: An array of GKPlayer
    */
    public func player(player: GKPlayer, didRequestMatchWithPlayers playerIDsToInvite: [String]) { }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewController                                              */
    /*####################################################################################################*/
    /**
    Called when the user cancels the matchmaking request (required)
    
    - parameter viewController: GKMatchmakerViewController
    */
    public func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        do {
            let delegateEGC = try EGC.sharedInstance.getDelegateEGC()
            delegateEGC.EGCMatchCancel?()
            EGC.debug("\n[Easy Game Center] Player cancels the matchmaking request \n")
        } catch {
            EGCError.DelegateNotHaveProtocolEGCDelegate.errorCall()
        }
    }
    /**
    Called when the view controller encounters an unrecoverable error.
    
    - parameter viewController: GKMatchmakerViewController
    - parameter error:          NSError
    */
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        do {
            let delegateEGC = try EGC.sharedInstance.getDelegateEGC()
            delegateEGC.EGCMatchCancel?()
            EGC.debug("\n[Easy Game Center] Error finding match: \(error.localizedDescription)\n")
            
        } catch {
            EGCError.DelegateNotHaveProtocolEGCDelegate.errorCall()
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////




extension EGC {
    private class func debug(object: Any) {
        if EGC.debugMode {
            dispatch_async(dispatch_get_main_queue()) {
                Swift.print(object)
            }
        }
    }
}
// MARK: - Debug  /  Error Func
extension EGC {

    /**
    Init Implemented by subclasses to initialize a new object
    
    - returns: An initialized object
    */
    private enum EGCError : ErrorType {
        case Error(String)
        case CantCachingAds
        case CantCachingA
        case CantCachingNoA
        case CantCachingNoAchievements
        case Empty
        case IndexOut
        case NoConnection
        case NoLogin
        case NoDelegate
        case DelegateNotHaveProtocolEGCDelegate
        case NoInstance
        case NoUIViewController
        case ParamEmpty
        case CantLoadLeaderboards
        
        /// Description
        var description : String {
            defer { }
            
            switch self {
            case .Error( let error):
                return "[Easy Game Center] \(error)"
            case .CantLoadLeaderboards:
                return "[Easy Game Center] Couldn't load Leaderboards"
                
            case .CantCachingAds:
                return "[Easy Game Center] Can't caching Achievement Description\n( Have you create achievements in ItuneConnect ? )"
            case .CantCachingA:
                return "[Easy Game Center] Can' t caching Achievement\n( Have you create achievements in ItuneConnect ? )"
            case .CantCachingNoA:
                return "[Easy Game Center] Can't caching Achievement they are no create"
            case .CantCachingNoAchievements:
                return "[Easy Game Center] Can't caching GKAchievement and GKAchievementDescription\n\n( Have you create achievements in ItuneConnect ? )"
            case .NoConnection:
                return "[Easy Game Center] No connexion"
            case .NoLogin:
                return "[Easy Game Center] No login"
            case .NoDelegate :
                return "\n[Easy Game Center] Error delegate UIViewController not set\n"
            case .NoUIViewController:
                return "\n[Easy Game Center] Error delegate is not UIViewController\n"
            default:
                return ""
            }
        }
        
        private func printError() { EGC.debug(self.description) }
        
        private func errorCall() {
            
            defer { self.printError() }
            
            switch self {
            case .NoLogin:
                guard let delegateEGC = EGC.delegate  as? EGCDelegate else {
                    return
                }
                delegateEGC.EGCAuthentified?(false)
                break
            case .CantCachingNoA:
                EGC.sharedInstance.inCacheIsLoading = false
                EGC.sharedInstance.checkupNetAndPlayer()
                break
            case .CantCachingA:
                //EGC.sharedInstance.checkupNetAndPlayer()
                break
            default:
                break
            }
        }
    }
    
    
    
}