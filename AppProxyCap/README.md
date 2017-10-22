AppProxyCap 
===========
Application-wide proxy setting

## Usage
Add the following line to your application before any network call:

	[AppProxyCap activate];
	[AppProxyCap setProxy:AppProxy_HTTP Host:@"127.0.0.1" Port:8086];

HTTP traffic in current app via CFNetwork (e.g. NSURLConnection) will go through 127.0.0.1:8086 HTTP proxy afterwards, traffic in other application is not affected.


## Supported OS
Tested in Mac OS X 10.7.2, 10.8.1; iOS 5.0, 6.0 device and simulator


## LICENSE
Released in [MIT License](http://opensource.org/licenses/mit-license.php)