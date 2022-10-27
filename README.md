# Smart Video iOS SDK 

The VideoEngager SDK for iOS allows you to integrate SmartVideo application in your own iOS mobile applications. This way, you would enable your customers to call your agents directly from your iOS application through Click to Audio / Video buttons.


## SDK Highlights

* Click to audio
* Click to video
* supports Genesys Cloud
* support SmartVideo standalone
* supports Genesys Engage (coming soon)
* Localization (supports English, Spanish, Portuguese, German, and Bulgarian)


## Prerequisites

* Xcode 12.0 or higher
* Swift 4.0 or higher
* iOS 13.0 or higher


## Installation

We currently support installation only by using CocoaPods. To install SmartVideo simply add the following pod to your Podfile:

```bash
pod 'SmartVideo', :git => 'https://github.com/VideoEngager/SmartVideo-iOS-SDK'
```

Also, when building your own project, please bear in mind that the latest version the the SmartVideo SDK requires bitcode to be disabled. This repo contains a `Podfile` that can be reused when setting up our project. Alternatively, please include the following code snippet in your `Podfile` to disable bitcode: 

```bash
post_install do |installer|
  installer.pods_project.targets.each do |target|
      if target.name == "GoogleWebRTC" || target.name == "SmartVideo"
          puts "Processing for disable bit code in #{target.name}"
          target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
      end
  end
end
```

Your main target shall also disable bitcode. To do so, please go to `Build settings`, find `Enable Bitcode`, and set it to `No` for both `Debug` and `Release`.

Once a `Podfile` is created, please run pod install --verbose to install all the required dependencies to your project.


## Configure to use with your Genesys Cloud Center

### Run within the VideoEngage Genesys Cloud organization
The demo app comes with pre-configured Genesys Cloud account, within the Video Engager organization. To quickly test the demo app, one needs to:
* visit Genesys Cloud [https://login.mypurecloud.com/](https://login.mypurecloud.com/)
* login as agent, by using the following credentials
    * username: mobiledev@videoengager.com 
    * password: [ask Video Engager support team to obtain your password](mailto:support@videoengager.com)
* clone and compile this project without any change of parameters in `SmartVideo-Info.plist`
* run the compiled project in his/her iPhone
* select `Genesys Cloud` and tap on `Start Video` or `Start Audio` button.

Please refer to the following video, from one of our webinars to get a better understand of how to use it the iOS SDK.


### Run within the VideoEngage Genesys Cloud organization
If you want to configure the demo app to run with your own Genesys Cloud organization, then `SmartVideo-Info.plist` file shall be updated to provide the correct parameters of your organization. 


| Name                        | Type            | Value      |
| --------------------------- | --------------- | ---------------------------------------------------------------- |
| SmartVideo URL (required)   | String          | `videome.videoengager.com` (unless you have a custom subdomain)  |
| Environment (required)      | String          | `live`, if SmartVideo URL is set to `videome.videoengager.com` or `staging`, if SmartVideo URL is set to `videome-staging.videoengager.com` |
| Agents (required) <ul><li>item 0</li><ul><li>Tenant Id</li><li>Name</li></ul></ul> | Array  <ul><li>Dictionary</li><ul><li>String</li><li>String</li></ul></ul> | <br /><br /><ul><li>`0FphTk091nt7G1W7`, as in this example here or your SmartVideo tenant Id</li><li>`slava`, as in this example here or your SmartVideo short URL</li></ul>   |
| Environment Url (required)  | String          | `https://api.mypurecloud.com` or your preferred Genesys Cloud location |
| Queue Name (required     )  | String          | Here you need to provide the name of your GenesysCloud queue. This the queue that is setup to process SmartVideo interactions |
| Organization ID (required)  | String          |  Your GenesysCloud organization Id |
| Engine (required)           | String          | `genesys` |
| Deployment ID (required)    | String          | Your SmartVideo deployment Id |

For more details on how to obtain some of your specific parameters, please consult with your Genesys Cloud administrator or refer to our [HelpDesk article](https://help.videoengager.com/hc/en-us/articles/360061175891-How-to-obtain-my-Genesys-Cloud-Parameters-required-to-setup-SmartVideo-SDKs).

### Parameters could be set by two different ways
1. Setup by add to the project a SmartVideo-Info.plist provided by us
2. Setup parameters on the beginning of any call

```
let configurations = GenesysConfigurations(environment: "Environment ID",
                                           organizationID: "Organization ID",
                                           deploymentID: "Deployment ID",
                                           tenantId: "Tenant ID",
                                           environmentURL: "Environment URL",
                                           queue: "Queue",
                                           engineUrl: "smartVideo URL")
                                           
let engine = GenesysEngine(environment: environment, isVideo: isVideo, configurations: configurations, memberInfo: memberInfo)
```

## Get started with SmartVideo SDK
After installation and configuration is done, it is time to integrate the SmartVideo SDK within your own app. Easiest would be to use the demo app in this repository. If you want to do so, pls type in the terminal:

```bash
cd <SmartVideo Demo Project Directory>
open DemoPureCloud.xcworkspace
```

The SmartVideo SDK will expose the following functionalities to hosting Swift app:
* place a voice call to VideoEngager standalone or Genesys Cloud queue
* place a video call to to VideoEngager standalone or Genesys Cloud queue
* send chat message to a Genesys Cloud agent over Genesys Cloud chat channel
* receive chat message from a Genesys Cloud agent over Genesys Cloud chat channel

By integrating `SmartVideoDelegate`, iOS developers will get an expose to a few more methods that will be covered in section [Error Handling](#Error-Handling). 

All the remaining functionalities of the SmartVideo SDK remain under the control of the SDK and are not exposed to hosting Swift app.

### Initialize SmartVideo
The initialization step requires to:
* import SmartVideo
* initialize SmartVideo

This would require to add inside your own UIViewController the following code snippets:

```xcode

import SmartVideo


class MyAwesomeVC: UIViewController {

    // ........

    override func viewDidLoad() {
        super.viewDidLoad()

        // .......

        initializeSmartVideo() {


        // .......

    }

    
    // .........


    fileprivate func initializeSmartVideo() {
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                    // .......
            }
        }
        
        if AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
            AVCaptureDevice.requestAccess(for: .audio) { _ in
                // .......    
            }
        }
            
        let environment = setupOrgParamsView.environment
        SmartVideo.environment = environment
        SmartVideo.setLogging(level: .verbose, types: [.rtc, .socket, .rest, .webRTC, .genesys, .callkit])
        SmartVideo.didEstablishCommunicationChannel = didEstablishCommunicationChannel
            
        SmartVideo.delegate = self
            
            
    }

    // ......

}



extension MyAwesomeVC: SmartVideoDelegate {
    
    func didEstablishCommunicationChannel() {

        // .......
        
        let outgoingCallVC = OutgoingCallVC()
        outgoingCallVC.hasVideo = self.hasVideo
        outgoingCallVC.modalPresentationStyle = .fullScreen
        self.present(outgoingCallVC, animated: true, completion: nil)

    }

}


```

### SmartVideoDelegate
From delegate can be handle different SDK events.

```
extension MyAwesomeVC: SmartVideoDelegate {
    func failedEstablishCommunicationChannel(type: SmartVideoCommunicationChannelType) {
        // Failed to established a connection with server
    }
    
    func didEstablishCommunicationChannel(type: SmartVideoCommunicationChannelType) {
        // Successful established a connection with server
        // Can be start the audio or video call
        // Normally Call UI should be called here
        // See the demo above paragraph
    }
    
    func callStatusChanged(status: SmartVideoCallStatus) {
        // Return Call Status 
    }
    
    func errorHandler(error: SmartVideoError) {
        // Return every error occur during SDK work
    }
    
    func onAgentTimeout() -> Bool {
        // Should close the Outgoing View Controller when agent doesn't answer
    }
    
    func genesysEngageChat(message: String, from: String) {
        // Receiving message from GenesysEngage chat
    }
}
```

### Add buttons for Click-to-Video and/or Click-to-Audio
This step requires to create buttons for adding a click to video and/or a click to voice functionality. Below is an example:

```xcode
// ....


let click2VideoButton: UIButton = {
    let lb = UIButton()
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.layer.cornerRadius = 10
    lb.layer.borderColor = UIColor.gray.cgColor
    lb.backgroundColor = UIColor.gray
    lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    lb.setTitleColor(UIColor.white, for: UIControl.State.normal)
    lb.setTitle("Start Video", for: UIControl.State.normal)
    lb.isEnabled = false
    return lb
}()
    
    
    
let click2VoiceButton: UIButton = {
    let lb = UIButton()
    lb.translatesAutoresizingMaskIntoConstraints = false
    lb.layer.cornerRadius = 10
    lb.layer.borderColor = UIColor.gray.cgColor
    lb.backgroundColor = UIColor.gray
    lb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    lb.setTitleColor(UIColor.white, for: UIControl.State.normal)
    lb.setTitle("Start Audio", for: UIControl.State.normal)
    lb.isEnabled = false
    return lb
}()


class MyAwesomeVC: UIViewController {


    // ......
    
    click2VideoButton.addTarget(self, action: #selector(click2VideoButtonDidTap), for: .touchUpInside)
        
    click2VoiceButton.addTarget(self, action: #selector(click2VoiceButtonDidTap), for: .touchUpInside)

    // ......


}



@objc fileprivate func click2VideoButtonDidTap() {
        
    // .....

    SmartVideo.environment = .live
    let engine = GenesysEngine(environment: environment, displayName: "Test Customer")
    let lang = "en_US"
    SmartVideo.connect(engine: engine, isVideo: true, lang: lang)
   
}
    
    
@objc fileprivate func click2VoiceButtonDidTap() {
        
    // .......

    SmartVideo.environment = .live
    let engine = GenesysEngine(environment: environment, displayName: "Test Customer")
    let lang = "en_US"
    SmartVideo.connect(engine: engine, isVideo: false, lang: lang)
    
}

```

### Short URL call 
You can use this method of SDK to make you own implementation for Escalation or Schedule scenarios. If your users receives special invitation Url when a interaction is not started (for example from Calendar app). Below is an example:

```
func callByInvitation(url: String) {
    SmartVideo.environment = .live
    let engine = GenericEngine(environment: .live, invitationURL: url)
    SmartVideo.connect(engine: engine, isVideo: false)
}
```
 
### Short URL call during a interaction
You can use this method of SDK to make you own implementation for Escalation or Schedule scenarios. If your users receives special VeVisitorVideoCall Url **DURING** existing interaction(like chat) you can pass it in veVisitorVideoCall(link:String) and SDK will call associated Agent. Below is an example:
```
func callByInvitation(url: String) {
    SmartVideo.veVisitorVideoCall(link: url)
}
```

### Short URL call 
You can use this method of SDK to make you own implementation for Escalation or Schedule scenarios. If your users receives special invitation Url when a interaction is not started (for example from Calendar app). Below is an example:

```
func callByInvitation(url: String) {
    SmartVideo.environment = .live
    let engine = GenericEngine(environment: .live, invitationURL: url)
    SmartVideo.connect(engine: engine, isVideo: false)
}
```

### Error Handling
This step requires to prepare your app for error handling. SmartVideo SDK considers two type of errors:
* Build time, and 
* Run time errors

Build errors cover misconfiguration in SmartVideo-Info.plist file. Missing parameters or plist will trigger compile errrors.

Run time errors cover the usage of the SDK within the host app. When the host app starts a video or audio call, the SDK will initiate a series of REST calls and socket exchange, between the SDK, Genesys Cloud and SmartVideo data centres. If any error happens before the call is established, the SDK won't provide any UI for error handling and will only return error message through an optional delegate method, named `errorHandler(error: SmartVideoError)`. An error at this stage can be triggered, if wrong parameters are provided in `SmartVideo-Info.plist`. Host app developers shall be responsible for handling errors at this stage. This demo app provides a simplified error handling, which can be reviewed by going to file `SetupOrgParamsGenesysCloudVC.swift` and looking in the SmartVideo delegate method ` func errorHandler(error: SmartVideoError)`


The other type of errors that this SDK handles is during already established call. For instance, if the host app internet gets down for some reason, the SDK will inform the mobile app user and shortly after that the call will be ended. The host app can implement an optional delegate method, if some other action is required to be processed, when this event is triggered. This delegate method is `isConnectedToInternet(isConnected: Bool)`.
Another example of error handling inside the SDK, are when agent's internet connectivity is down. In this case, the SDK will again inform the mobile app user and shortly after that the call will be also ended. The host app can implement an optional delegate method, if some other action is required to be processed, when this event is triggered. This delegate method is `peerConnectionLost()`.



## Minimum Supported Version 

We support iOS 13.0 onwards.


## How to contact us

If you have any questions, please contact our [support team](mailto:support@videoengager.com), and we will be happy to help. 


