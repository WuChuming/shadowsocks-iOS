//
//  main.m
//  OpenSSL-for-iOS
//
//  Created by Felix Schulze on 04.12.2010.
//  Updated by Schulze Felix on 01.04.12.
//  Copyright (c) 2012 Felix Schulze . All rights reserved.
//  Web: http://www.felixschulze.de
//

#import <UIKit/UIKit.h>
#import <openssl/evp.h>
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    SSLeay_add_all_ciphers();
    const EVP_CIPHER *cipher = EVP_get_cipherbyname("AES-256-CFB");
    cipher = EVP_aes_256_cfb();
    cipher = EVP_get_cipherbyname("AES-256-CFB");
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
