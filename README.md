# LAS-Demo-Auth-iOS

## Setup

The project teaches you how to use LAS user authentication and integrate with third platforms authentication.

## How to Run

Temporarily, only Facebook authentication was integrated into this project. More authentications will be integrated soon!

### Integrating Facebook

1. Clone the repository and open the Xcode project at `LAS-Demo-Auth-iOS/Auth.xcodeproj`.
2. Add your LAS application id and client key in `AppDelegate.m`.
3. Set your Facebook application id in the FacebookAppID property in Auth-info.plist.
4. Set your Facebook application id as a URLType Project > Info > URL Types > Untitled > URL Schemes using the format fbYour_App_id (eg. for 12345, enter fb12345).

