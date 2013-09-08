#Klout API Client for iOS

In Progress.

##Usage

###1. Add KloutAPIClient to your project

Add followings to your project.

- KloutAPIClient.h, KloutAPIClient.m
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)


###2. Set API Key

You can create your API Key from [http://developer.klout.com/member/register](http://developer.klout.com/member/register).

````
#import "KloutAPIClient.h"
````

````
[KloutAPIClient setAPIKey:@"YOUR API KEY"];
````

##Examples

- Retrieve a user's Klout Score and deltas for a Twitter screen_name. 

````
[KloutAPIClient scoreWithTwitterScreenName:@"shu223"
                                   handler:
 ^(NSDictionary *result, NSError *error) {
     
     // Do something
 }];
````


##License

MIT License