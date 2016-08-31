//
//  Debug.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/29.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#ifndef Debug_h
#define Debug_h

#define M_DEBUG

#ifdef M_DEBUG
# define DLog(fmt, ...) NSLog(@"[%@ %@][Line %d] %@",[self class] ,NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:fmt,##__VA_ARGS__]);
#else
# define DLog(...)
#endif

#endif /* Debug_h */
