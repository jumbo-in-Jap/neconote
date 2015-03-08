//
//  NeconoteBLE.m
//  NeconoteSDK
//
//  Created by 古川信行 on 2015/03/07.
//  Copyright (c) 2015年 古川信行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Blocks.h"
#import "NeconoteBLE.h"
#import "Konashi.h"

@interface NeconoteBLE(){
    //ネコの一覧
    NSDictionary* _nekoList;
    
    //トグルステータス
    BOOL _toggle_status;
    
    //読み込み完了時のコールバック
    NeconoteCallback _readyCallback;
    
    //PWMタイムアウト タイマー
    NSTimer* pwmTimeOutTimer;
}
@end

@implementation NeconoteBLE

//PWMタイムアウト
static NSTimeInterval PWM_TIMEOUT = 1.0;

//初期位置 ニュ－トラル位置
static int NECONOTE_BLE_DUTY_DEFAULT  = 1520;

//2350 反時計回り方向に-90°回転,630 時計回り方向に更に90度
//ON時 位置
static int NECONOTE_BLE_DUTY_ON = 1100;

//OFF時 位置
static int NECONOTE_BLE_DUTY_OFF = 1800;

//炊飯器 ON
static int NECONOTE_BLE_DUTY_COOKER_ON = 870;

//ドア オープン
static int NECONOTE_BLE_DUTY_DOOR_OPEN = 630;

//サーボ用のペイロード
static int NECONOTE_BLE_PERIOD = 20000;

//インスタンス取得
+ (NeconoteBLE *) shared
{
    static NeconoteBLE *_neconoteBLE = nil;
    
    @synchronized (self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            _neconoteBLE = [[[NeconoteBLE alloc] init] initialize];
        });
    }
    
    return _neconoteBLE;
}

//初期化
- (id) initialize {
    //ネコ,ドアのリスト
    _nekoList = @{/* @"1":@"konashi2-f01268", */
                  @"lighting":@"konashi2-f0126f",
                  @"cooker":@"konashi2-f0125b",
                  @"door":@"konashi2-f010aa"};
    
    _toggle_status = NO;
    
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(connected) name:KonashiEventConnectedNotification];
    [Konashi addObserver:self selector:@selector(ready) name:KonashiEventReadyToUseNotification];
    
    return self;
}

//切断
- (void) disconnect{
    NSLog(@"disconnect");
    [Konashi disconnect];
}

//名前指定無しで検索
- (void) find:(NeconoteCallback)readyCallback{
    [self findWithName:nil ready:readyCallback];
}

//指定した名前の neconote を検索して接続する
- (void) findWithName:(NSString*)name ready:(NeconoteCallback)readyCallback{
    NSLog(@"findWithName name:%@",name);
    _readyCallback = readyCallback;
    
    if(name == nil){
        //名前指定無し
        [Konashi find];
    }
    else{
        //名前指定アリで接続
        NSString* konashiName = [_nekoList objectForKey:name];
        NSLog(@"name:%@ konashiName:%@",name,konashiName);
        [Konashi findWithName:konashiName];
    }
}

//ON 操作
- (void) on:(NeconoteCallback)callback{
    //二重押し防止
    if(_toggle_status == NO) return;
    if(pwmTimeOutTimer != nil) return;
    
    NSLog(@"ON");
    _toggle_status = NO;
    [Konashi pwmDuty:KonashiDigitalIO0 duty:NECONOTE_BLE_DUTY_ON];
    //タイマーでPWM停止
    pwmTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:PWM_TIMEOUT block:^{
        pwmTimeOutTimer = nil;
        //[Konashi pwmDuty:KonashiDigitalIO0 duty:0];
        //callback();
        //初期位置へ
        [self def:callback];
    } repeats:NO];
}

//OFF 操作
- (void) off:(NeconoteCallback)callback{
    ////二重押し防止
    if(_toggle_status == YES) return;
    if(pwmTimeOutTimer != nil) return;
    
    NSLog(@"OFF");
    _toggle_status = YES;
    [Konashi pwmDuty:KonashiDigitalIO0 duty:NECONOTE_BLE_DUTY_OFF];
    //タイマーでPWM停止
    pwmTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:PWM_TIMEOUT block:^{
        pwmTimeOutTimer = nil;
        //[Konashi pwmDuty:KonashiDigitalIO0 duty:0];
        //callback();
        //初期位置へ
        [self def:callback];
    } repeats:NO];
}

// ON,OFF くり返し
- (void) toggle:(NeconoteToggleCallback)callback{
    if(pwmTimeOutTimer != nil) return;
    NSLog(@"TOGGLE");
    if(_toggle_status){
        [self on:^{
            //コールバック
            callback(YES);
        }];
    }
    else{
        [self off:^{
            //コールバック
            callback(NO);
        }];
    }
}

//DEFAULT 操作
- (void) def:(NeconoteCallback)callback{
    ////二重押し防止
    if(pwmTimeOutTimer != nil) return;
    
    NSLog(@"NECONOTE_BLE_DUTY_DEFAULT");
    [Konashi pwmDuty:KonashiDigitalIO0 duty:NECONOTE_BLE_DUTY_DEFAULT];
    //タイマーでPWM停止
    pwmTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:PWM_TIMEOUT block:^{
        pwmTimeOutTimer = nil;
        [Konashi pwmDuty:KonashiDigitalIO0 duty:0];
        callback();
    } repeats:NO];
}

//炊飯器用 ON
- (void) cooker_on:(NeconoteCallback)callback{
    //二重押し防止
    if(pwmTimeOutTimer != nil) return;
    
    NSLog(@"COOKER_ON");
    [Konashi pwmDuty:KonashiDigitalIO0 duty:NECONOTE_BLE_DUTY_COOKER_ON];
    
    //タイマーでDEFAULTのの位置に戻す
    pwmTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:PWM_TIMEOUT block:^{
        pwmTimeOutTimer = nil;
        //初期位置へ
        [self def:callback];
    } repeats:NO];
}


//ドアを開く
- (void) door_open:(NeconoteCallback)callback{
    NSLog(@"NECONOTE_BLE_DUTY_DOOR_OPEN");
    [Konashi pwmDuty:KonashiDigitalIO1 duty:NECONOTE_BLE_DUTY_DOOR_OPEN];
    //タイマーでPWM停止
    pwmTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:PWM_TIMEOUT block:^{
        pwmTimeOutTimer = nil;
        [Konashi pwmDuty:KonashiDigitalIO1 duty:0];
        callback();
    } repeats:NO];
}

//ドアを閉じる
- (void) door_close:(NeconoteCallback)callback{
    NSLog(@"NECONOTE_BLE_DUTY_DOOR_CLOSE");
    [Konashi pwmDuty:KonashiDigitalIO1 duty:NECONOTE_BLE_DUTY_DEFAULT];
    //タイマーでPWM停止
    pwmTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:PWM_TIMEOUT block:^{
        pwmTimeOutTimer = nil;
        [Konashi pwmDuty:KonashiDigitalIO1 duty:0];
        callback();
    } repeats:NO];
}

// Konashi デリゲート -------------

//Konashiと接続
-(void) connected {
    NSLog(@"CONNECTED");
}

//操作できるようになった
-(void) ready{
    NSLog(@"READY");
    NSLog(@"peripheralName:%@",[Konashi peripheralName]);
    
    //IOピンの初期化
    [Konashi pwmMode:KonashiDigitalIO0 mode:KonashiPWMModeEnable];
    [Konashi pwmPeriod:KonashiDigitalIO0 period:NECONOTE_BLE_PERIOD];
    
    //IOピンの初期化
    [Konashi pwmMode:KonashiDigitalIO1 mode:KonashiPWMModeEnable];
    [Konashi pwmPeriod:KonashiDigitalIO1 period:NECONOTE_BLE_PERIOD];
    
    //初期位置に設定
    //[Konashi pwmDuty:KonashiDigitalIO0 duty:NECONOTE_BLE_DUTY_DEFAULT];
    
    //設定が終わったのでコールバックする
    if(_readyCallback != nil){
        _readyCallback();
    }
}

@end
