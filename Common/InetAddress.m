//
//  InetAddress.m
//  selector
//
//  Created by mac on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InetAddress.h"
#import "GCDAsyncUdpSocket.h"

@implementation InetAddress



#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <unistd.h> 
#include <sys/ioctl.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <netdb.h> 
#include <arpa/inet.h> 
#include <sys/sockio.h> 
#include <net/if.h> 
#include <errno.h> 
#include <net/if_dl.h> 
#include <net/ethernet.h>

//#include "GetAddresses.h" 

#define min(a,b) ((a) < (b) ? (a) : (b)) 
#define max(a,b) ((a) > (b) ? (a) : (b)) 

#define BUFFERSIZE 4000 
#define MAXADDRS 16

char *if_names[MAXADDRS]; 
char *ip_names[MAXADDRS]; 
char *hw_addrs[MAXADDRS]; 
unsigned long ip_addrs[MAXADDRS]; 

static int addrCount = 0; 

-(id)init
{
    self=[super init];
    if ( !self )
		return nil;
    InitAddresses();
    return self;
}

- (void)dealloc
{
    FreeAddresses();
    [super dealloc];
}

void InitAddresses() 
{ 
    int i; 
    for (i=0; i<MAXADDRS; ++i) 
    { 
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL; 
        ip_addrs[i] = 0; 
    } 
} 

void FreeAddresses() 
{ 
    int i; 
    for (i=0; i<MAXADDRS; ++i) 
    { 
        if (if_names[i] != 0) free(if_names[i]); 
        if (ip_names[i] != 0) free(ip_names[i]); 
        if (hw_addrs[i] != 0) free(hw_addrs[i]); 
        ip_addrs[i] = 0; 
    } 
    InitAddresses(); 
} 

void GetIPAddresses() 
{ 
    int i, len, flags; 
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr; 
    struct ifconf ifc; 
    struct ifreq *ifr, ifrcopy; 
    struct sockaddr_in *sin; 
    
    char temp[80]; 
    
    int sockfd; 
    
    for (i=0; i<MAXADDRS; ++i) 
    { 
        if_names[i] = ip_names[i] = NULL; 
        ip_addrs[i] = 0; 
    } 
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0); 
    if (sockfd < 0) 
    { 
        perror("socket failed"); 
        return; 
    } 
    
    ifc.ifc_len = BUFFERSIZE; 
    ifc.ifc_buf = buffer; 
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0) 
    { 
        perror("ioctl error"); 
        return; 
    } 
    
    lastname[0] = 0; 
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; ) 
    { 
        ifr = (struct ifreq *)ptr; 
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len); 
        ptr += sizeof(ifr->ifr_name) + len; // for next one in buffer 
        
        if (ifr->ifr_addr.sa_family != AF_INET) 
        { 
            continue; // ignore if not desired address family 
        } 
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) 
        { 
            *cptr = 0; // replace colon will null 
        } 
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) 
        { 
            continue; /* already processed this interface */ 
        } 
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ); 
        
        ifrcopy = *ifr; 
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy); 
        flags = ifrcopy.ifr_flags; 
        if ((flags & IFF_UP) == 0) 
        { 
            continue; // ignore if interface not up 
        } 
        
        if_names[addrCount] = (char *)malloc(strlen(ifr->ifr_name)+1); 
        if (if_names[addrCount] == NULL) 
        { 
            return; 
        } 
        strcpy(if_names[addrCount], ifr->ifr_name); 
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr; 
        strcpy(temp, inet_ntoa(sin->sin_addr)); 
        
        ip_names[addrCount] = (char *)malloc(strlen(temp)+1); 
        if (ip_names[addrCount] == NULL) 
        { 
            return; 
        } 
        strcpy(ip_names[addrCount], temp); 
        
        ip_addrs[addrCount] = sin->sin_addr.s_addr;
        
        ++addrCount; 
    } 
    
    close(sockfd); 
} 

void GetHWAddresses() 
{ 
    struct ifconf ifc; 
    struct ifreq *ifr; 
    int i, sockfd; 
    char buffer[BUFFERSIZE], *cp, *cplim; 
    char temp[80]; 
    
    for (i=0; i<MAXADDRS; ++i) 
    { 
        hw_addrs[i] = NULL; 
    } 
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0); 
    if (sockfd < 0) 
    { 
        perror("socket failed"); 
        return; 
    } 
    
    ifc.ifc_len = BUFFERSIZE; 
    ifc.ifc_buf = buffer; 
    
    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0) 
    { 
        perror("ioctl error"); 
        close(sockfd); 
        return; 
    } 
    
//    ifr = ifc.ifc_req; 
    
    cplim = buffer + ifc.ifc_len; 
    
    for (cp=buffer; cp < cplim; ) 
    { 
        ifr = (struct ifreq *)cp; 
        if (ifr->ifr_addr.sa_family == AF_LINK) 
        { 
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr; 
            int a,b,c,d,e,f; 
            int i; 
            
//            strcpy(temp, (char *)ether_ntoa(LLADDR(sdl))); 
            strcpy(temp, (char *)ether_ntoa((struct ether_addr*)LLADDR(sdl)));
            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f); 
            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f); 
//            printf("GetHWAddresses MAC:%s\n",temp);
            for (i=0; i<MAXADDRS; ++i) 
            { 
                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name, if_names[i]) == 0)) 
                { 
                    if (hw_addrs[i] == NULL) 
                    { 
                        hw_addrs[i] = (char *)malloc(strlen(temp)+1); 
                        strcpy(hw_addrs[i], temp); 
                        
//                        printf("GetHWAddresses if_names[%d]=%s\n",i,if_names[i]);
//                        printf("GetHWAddresses ip_names[%d]=%s\n",i,ip_names[i]);
//                        printf("GetHWAddresses hw_addrs[%d]=%s\n",i,hw_addrs[i]);
                        break;
                    } 
                } 
            } 
        } 
        cp += sizeof(ifr->ifr_name) + max(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len); 
    } 
    
    close(sockfd); 
}

+ (NSString *)getByName:(NSString *)name
{
    NSString *rst=[NSString stringWithFormat:@""];
    char   *ptr, **pptr;
    struct hostent *hptr;
    char   str[32];
    ptr=(char *)[name UTF8String];
    
    if((hptr = gethostbyname(ptr)) == NULL)
    {
        printf(" gethostbyname error for host:%s\n", ptr);
        return 0; 
    }
        
    switch(hptr->h_addrtype)
    {
        case AF_INET:
        case AF_INET6:
            pptr=hptr->h_addr_list;
            
            rst=[NSString stringWithFormat:@"%s",inet_ntop(hptr->h_addrtype, hptr->h_addr, str, sizeof(str))];
            break;
        default:
            printf("unknown address type\n");
            break;
    }
    return rst;
}

+ (NSString *)getLocalHost { 
    if (addrCount==0)
    {
        GetIPAddresses(); 
        GetHWAddresses(); 
    }
//    printf("ip_names[1]=%s\n",ip_names[1]);
    return [[[NSString alloc ]initWithFormat:@"%s", ip_names[1]] autorelease];
}

+(struct sockaddr_in)ipstr2sockaddr_in:(const char*)ipstr port:(int)port
{
    struct sockaddr_in ipaddr;
    
    memset(&ipaddr,0,sizeof(ipaddr));
    ipaddr.sin_family=AF_INET;
    ipaddr.sin_addr.s_addr=inet_addr(ipstr);
    ipaddr.sin_port = htons(port);
    
    return ipaddr;
}

+ (NSError *)gaiError:(int)gai_error
{
	NSString *errMsg = [NSString stringWithCString:gai_strerror(gai_error) encoding:NSASCIIStringEncoding];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:@"kCFStreamErrorDomainNetDB" code:gai_error userInfo:userInfo];
}

+(NSArray*)resolveHost:(NSString*)hostorip port:(uint16_t)port
{
    NSMutableArray *addresses = [NSMutableArray arrayWithCapacity:2];
    NSError *error = nil;
    
    if ([hostorip isEqualToString:@"localhost"] || [hostorip isEqualToString:@"loopback"])
    {
        // Use LOOPBACK address
        struct sockaddr_in sockaddr4;
        memset(&sockaddr4, 0, sizeof(sockaddr4));
        
        sockaddr4.sin_len         = sizeof(struct sockaddr_in);
        sockaddr4.sin_family      = AF_INET;
        sockaddr4.sin_port        = htons(port);
        sockaddr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        
        struct sockaddr_in6 sockaddr6;
        memset(&sockaddr6, 0, sizeof(sockaddr6));
        
        sockaddr6.sin6_len       = sizeof(struct sockaddr_in6);
        sockaddr6.sin6_family    = AF_INET6;
        sockaddr6.sin6_port      = htons(port);
        sockaddr6.sin6_addr      = in6addr_loopback;
        
        // Wrap the native address structures and add to list
        [addresses addObject:[NSData dataWithBytes:&sockaddr4 length:sizeof(sockaddr4)]];
        [addresses addObject:[NSData dataWithBytes:&sockaddr6 length:sizeof(sockaddr6)]];
    }
    else
    {
        NSString *portStr = [NSString stringWithFormat:@"%hu", port];
        
        struct addrinfo hints, *res, *res0;
        
        memset(&hints, 0, sizeof(hints));
        hints.ai_family   = PF_UNSPEC;
        hints.ai_socktype = SOCK_DGRAM;
        hints.ai_protocol = IPPROTO_UDP;
        
        int gai_error = getaddrinfo([hostorip UTF8String], [portStr UTF8String], &hints, &res0);
        
        if (gai_error)
        {
            error = [self gaiError:gai_error];
        }
        else
        {
            for(res = res0; res; res = res->ai_next)
            {
                if (res->ai_family == AF_INET)
                {
                    // Found IPv4 address
                    // Wrap the native address structure and add to list
                    
                    [addresses addObject:[NSData dataWithBytes:res->ai_addr length:res->ai_addrlen]];
                }
                else if (res->ai_family == AF_INET6)
                {
                    // Found IPv6 address
                    // Wrap the native address structure and add to list
                    
                    [addresses addObject:[NSData dataWithBytes:res->ai_addr length:res->ai_addrlen]];
                }
            }
            freeaddrinfo(res0);
            
            if ([addresses count] == 0)
            {
                error = [self gaiError:EAI_FAIL];
            }
        }
    }
    return addresses;
}

+(NSData*)getIPv4Address:(NSString*)hostorip port:(uint16_t)port
{
    NSArray *arrX = [self resolveHost:hostorip port:port];
    for (NSData *d in arrX) {
        if (AF_INET == [GCDAsyncUdpSocket familyFromAddress:d])
            return d;
    }
    return nil;
}

@end
