//
//  NeconoteBLE.h
//  NeconoteSDK
//
//  Created by 古川信行 on 2015/03/07.
//  Copyright (c) 2015年 古川信行. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NeconoteCallback)();
typedef void(^NeconoteToggleCallback)(BOOL flg);

@interface NeconoteBLE : NSObject

//インスタンス取得
+ (NeconoteBLE *) shared;

//切断
- (void) disconnect;

//名前してい無しで検索して接続
- (void) find:(NeconoteCallback)readyCallback;

//指定した名前の neconote を検索して接続する
- (void) findWithName:(NSString*)name ready:(NeconoteCallback)readyCallback;

//ON 操作
- (void) on:(NeconoteCallback)callback;

//OFF 操作
- (void) off:(NeconoteCallback)callback;

// ON,OFF くり返し
- (void) toggle:(NeconoteToggleCallback)callback;

@end
