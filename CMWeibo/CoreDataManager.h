//
//  CoreDataManager.h
//  CMWeibo
//
//  Created by jiachen on 16/5/16.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void(^ _Nonnull CompleteBlock)( NSArray * _Nullable array);

@interface CoreDataManager : NSObject

+ (instancetype)shareInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;


/**
 *  由类名返回该类的一个对象
 *
 *  @param className 类名
 *
 *  @return 该类的一个对象
 */
+ (id)modelWithClassName:(NSString *)className;


/**
 *  //查询特定类的所有对象，返回一个数组
 *
 *  @param obj 查询目的对象的一个实例
 *
 *  @return 返回目的类的所有对象(可能为空)
 */
- (void)arrayWithObjectClass:(Class)class CompltetBlock:(CompleteBlock)compltetBlock;

@end
