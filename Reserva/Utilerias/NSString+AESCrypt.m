//
//  NSString+AESCrypt.m
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import "NSString+AESCrypt.h"

@implementation NSString (AESCrypt)

- (NSString *)AES128EncryptWithKey:(NSString *)key
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES128EncryptWithKey:key];
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

- (NSString *)AES128DecryptWithKey:(NSString *)key
{
    NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [encryptedData AES128DecryptWithKey:key];
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
	
    return plainString;
}
- (NSString *)AES128EncryptWithKeyVectorCBC:(NSString *)key
{
    NSString *encryptedString;
    encryptedString = nil;
    @try
    {
        NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [plainData AES128EncryptWithKeyVectorCBC:key];
        
        encryptedString = [encryptedData base64Encoding];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        return encryptedString;
    }
}
@end