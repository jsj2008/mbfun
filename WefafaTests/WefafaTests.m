//
//  WefafaTests.m
//  WefafaTests
//
//  Created by fafa  on 13-6-21.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "WefafaTests.h"
//#import "RichTextParserMsg.h" 
//#import "HTMLParser.h" 
//#import "XMPPSI.h"
//#import "XmppExXMLNS.h"
//#import "XMPPIQ+SI.h"
//#import "JSONKit.h"
//#import "FAFAUdpClient.h"

@implementation WefafaTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in WefafaTests");
}
/*
- (void)testRichTextParser
{
    RichTextParser *rtp = [[RichTextParserMsg alloc] init];
    NSArray *re = nil;
    
    re = [rtp parse:@"我/byede,gw/by哈 http://sss.www.com/ 123"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 7, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"{[0A9DBA6502B1E475149B304192C1B121.png]}"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 1 && [(RichTextItem*)re[0] type] == 4, @"RichTextParser parse 不正确");
    
    
    re = [rtp parse:@"{#0A9DBA6502B1E475149B304192C1B121.mp4#}"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 1 && [(RichTextItem*)re[0] type] == 6, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"{#0A9DBA6502BFE475149B304192C1B121.#p4#}"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 1 && [(RichTextItem*)re[0] type] == 0, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"{[{[0A9DBA6502B1E475149B304192C1B121.png]}"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 2 && [(RichTextItem*)re[1] type] == 4, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"{[{[0A9DBA6502B1E475149B304192C1B121.png"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 1 && [(RichTextItem*)re[0] type] == 0, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"<SPAN contentEditable=false>{[27CAFE5E011EBA91B969BDEDC0FAAC53.png]}</SPAN>"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 3 && [(RichTextItem*)re[1] type] == 4, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"{[{[0A9DBA6502B1E475149B304192C1B121.pngsdfsf]}"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 1 && [(RichTextItem*)re[0] type] == 0, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"<SPAN contentEditable=false>{[27CAFE5E011EBA91B969BDEDC0FAAC53.png]}</SPAN>"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 3, @"RichTextParser parse 不正确");
    
    
    re = [rtp parse:@"{(0A9DBA6502B1E475149B304192C1B121.amr)}"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 1 && [(RichTextItem*)re[0] type] == 5, @"RichTextParser parse 不正确");
    
    re = [rtp parse:@"1. 创建一个外部协作圈子；\r\n\
          2. 邀请您的同事或合作伙伴加入圈子；\r\n\
          3. 下载客户端，与圈子成员进行沟通、会议和分享等协作；\r\n\
          4. 在圈子内发布动态、文档、投票、活动或提出问题。"];
    NSLog(@"%@", re);
    STAssertTrue(re.count == 7 && [(RichTextItem*)re[0] type] == 0, @"RichTextParser parse 不正确");

    
    
}

- (void)testRichTextParserHtml
{
    NSError *error = nil;
    NSString *html = @"<img alt='' style='height: 24px; width: 24px;' src='/bundles/fafatimewebase/images/face/tx.gif'>asdf 人在 @<a href=\"#\" class=\"employee_name\">朱军{北京发发时代}</a> 人 <a href=\"http://www.chinanews.com/gj/2013/08-07/5136256.shtml\" title=\"http://www.chinanews.com/gj/2013/08-07/5136256.shtml\" target=\"_blank\" style=\"padding: 2px; font-weight: normal;\"><img src=\"/bundles/fafatimewebase/images/face/../link16.png\"> 链接地址</a> 哈哈，真的哇<img alt='' style='height: 24px; width: 24px;' src='/bundles/fafatimewebase/images/face/tx.gif'> <img alt='' style='height: 24px; width: 24px;' src='/bundles/fafatimewebase/images/face/no.gif'>";
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    HTMLNode *bodyNode = [parser body];
    
    for (HTMLNode *n in [[bodyNode firstChild] children]) {
        
        NSLog(@"%d %@ %@", [n nodetype], [n rawContents], [n getAttributeNamed:@"href"]);
    }
     
    
     html = @"<span type='employee' id='10030-100082@fafacn.com'>程宇冰</span>邀请您加入圈子【<span type='circle' id='10010'>发发设计讨论</span>】";
    parser = [[HTMLParser alloc] initWithString:html error:&error];
    bodyNode = [parser body];
    NSLog(@"%@",bodyNode.allContents);
    for (HTMLNode *n in [bodyNode children]) {
        
        NSLog(@"%d %@ %@", [n nodetype], [n contents], [n getAttributeNamed:@"href"]);
    }
}

- (void)testSIXML
{
    NSString *s = @"<iq id=\"jcl_18\" to=\"xxx\" type=\"result\" from=\"yyy\">    <si xmlns=\"http://jabber.org/protocol/si\">    <feature xmlns=\"http://jabber.org/protocol/feature-neg\">    <x xmlns=\"jabber:x:data\" type=\"submit\">    <field var=\"stream-method\">    <value>http://jabber.org/protocol/bytestreams</value>    </field>    </x>    </feature>    </si>    </iq>";
    XMPPIQ *siiq = [XMPPIQ iqFromElement:[[NSXMLElement alloc] initWithXMLString:s error:nil]];
    XMPPSI *si = siiq.si;
    NSLog(@"%@", si);
    NSLog(@"%@", si.featureNeg);
    NSLog(@"%@", si.featureNeg.data);
    NSLog(@"%@", si.featureNeg.data.getFields);
    NSXMLElement *e = [si.featureNeg.data elementForName:@"field" xmlns:XMLNS_X_DATA];
    NSLog(@"%@", e);
    STAssertTrue(e != nil, @"XMPPXDField not ok");
    e = [si.featureNeg.data elementForName:@"field"];
    NSLog(@"%@", e);
    STAssertTrue(e != nil, @"XMPPXDField not ok");
    NSLog(@"%@", [XMPPXDData xmppxdData]);
    NSLog(@"%@", [XMPPXDField xmppxdField]);
    STAssertTrue([XMPPXDField xmppxdField] != nil, @"XMPPXDField not ok");
}

- (void)testJSON
{
    id ss = [@"{\"send_status\":\"\\u0000\",\"send_datetime\":null}" objectFromJSONString];
    NSLog(@"%@", ss);
}

- (void)testUDP
{
    [g_fafaUdpClient RefreshExternalIPAndPort:@"im.fafacn.com" Port:14478];
    NSLog(@"%@   %d", g_fafaUdpClient.ExternalIP, g_fafaUdpClient.ExternalPort);
}
*/
@end
