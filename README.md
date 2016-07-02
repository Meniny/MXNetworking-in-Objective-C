# MXNetworking-in-Objective-C

`MXNetworing` is a delightful networking framework for iOS platform.

## Installation with CocoaPods

Coming soon...

## Usage

```
[MXNetworking getRequestByAppending:@"http://www.example.com/v1/exp?par=val" forType:RequestTypeURL data:nil callback:^(ResponseStatus status, id responseObject) {
  if (status == ResponseStatus200) {
    // code here...
  } else {
    // code here...
  }
}];
```
