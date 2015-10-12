# Demo-Auth-iOS

## Overview

The project teaches you how to use MaxLeap user authentication and integrate with third platforms authentication.

## Screenshots

![](../images/1.png)
![](../images/2.png)
![](../images/3.png)
![](../images/4.png)

## How to Run

Temporarily, only Facebook authentication was integrated into this project. More authentications will be integrated soon!

### Integrating Facebook

1. Clone the repository and open the Xcode project at `Demo-Auth-iOS/Auth.xcodeproj`.
2. Add your MaxLeap application id and client key in `AppDelegate.m`.
3. Set your Facebook application id in the FacebookAppID property in Auth-info.plist.
4. Set your Facebook application id as a URLType Project > Info > URL Types > Untitled > URL Schemes using the format fbYour_App_id (eg. for 12345, enter fb12345).

