//
//  UIDevice+CQDevice.h
//  CarServiceLeague
//
//  Created by runo on 16/8/3.
//  Copyright © 2016年 com.runo. All rights reserved.
//

#import <UIKit/UIKit.h>

_Pragma("clang assume_nonnull begin")

@interface UIDevice (CQDevice)

+(double)cqSystemVersion;//!<系统版本
@property(nonatomic,readonly) BOOL isPad;//!<是否是ipad
@property(nonatomic,readonly) BOOL isSimulator;//!<是否是模拟器
@property (nonatomic, readonly) BOOL isJailbroken;//!<是否越狱
@property (nonatomic, readonly) NSDate *systemUptime;//!<系统启动时间

#pragma mark - Disk Space
@property (nonatomic, readonly) int64_t diskSpace;//!<磁盘总空间
@property (nonatomic, readonly) int64_t diskSpaceFree;//!<磁盘剩余空间
@property (nonatomic, readonly) int64_t diskSpaceUsed;//!<自盘已用空间

#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryTotal;//内存空间

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryUsed;//内存已用空间

@property (nonatomic, readonly) int64_t programUsedMemory;//!<当前应用

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryFree;//内存剩余空间

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger cpuCount;//!<cpu总数

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float cpuUsage;//!<cpu剩余

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;

@end
_Pragma("clang assume_nonnull end")
