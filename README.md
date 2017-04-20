<center>
<img src="https://ooo.0o0.ooo/2017/04/21/58f9127a0d66e.jpg" alt="MXNetworking">
</center>

# MXNetworking-in-Objective-C

`MXNetworing` is a delightful networking framework for iOS platform.

## Installation with CocoaPods

```
pod 'MXNetworking'
```

## Usage

```objective-c
#import "MXNetworking.h"
```

* Base URL

```objective-c
#pragma mark BASR URL
[MXNetworking setBaseURLString:@"http://exp.yourdomain.com"];
```

* Request Headers

```objective-c
#pragma mark REQUEST HEADERS
NSMutableDictionary *headers = [[NSMutableURLRequest standardHeaders] mutableCopy];
[headers setValue:@"MXNetworkingDemo/1.0 CFNetwork/758.1.6 Darwin/15.0.0" forKey:@"User-Agent"];
[headers setValue:@"*/*" forKey:@"Accept"];
[NSMutableURLRequest setStandardHeaders:headers];
```

* Sample Request

```objective-c
NSString *version = @"1.0";
NSString *device = @"iphone6";
NSString *url = [MXNetworking urlByAppendingParameters:@{
                                             @"device": device,
                                             @"version": version
                                             } toURL:@"/exp_name.php"];

[MXNetworking getRequestByAppending:url forType:RequestTypeURL data:nil callback:^(ResponseStatus status, id responseObject, NSError *error) {
  // Main Thread:
  if (status == ResponseStatus200) {
    // code here...
  } else {
    // code here...
  }
}];
```

## Trouble Shooting

* ATS

Add this to your `Info.plist` file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
</plist>
```
