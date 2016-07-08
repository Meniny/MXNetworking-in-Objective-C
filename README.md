# MXNetworking-in-Objective-C

`MXNetworing` is a delightful networking framework for iOS platform.

## Installation with CocoaPods

Coming soon...

## Usage

* Base URL

```
#pragma mark BASR URL
[MXNetworking setBaseURLString:@"http://exp.yourdomain.com"];
```

* Request Headers

```
#pragma mark REQUEST HEADERS
NSMutableDictionary *headers = [[NSMutableURLRequest standardHeaders] mutableCopy];
[headers setValue:@"MXNetworkingDemo/1.0 CFNetwork/758.1.6 Darwin/15.0.0" forKey:@"User-Agent"];
[headers setValue:@"*/*" forKey:@"Accept"];
[NSMutableURLRequest setStandardHeaders:headers];
```

* Sample Request

```
NSString *version = @"1.0";
NSString *device = @"iphone6";
NSString *url = [MXNetworking urlByAppendingParameters:@{
                                             @"device": device,
                                             @"version": version
                                             } toURL:@"/exp_name.php"];

[MXNetworking getRequestByAppending:url forType:RequestTypeURL data:nil callback:^(ResponseStatus status, id responseObject) {
  // Main Thread:
  if (status == ResponseStatus200) {
    // code here...
  } else {
    // code here...
  }
}];
```
