//
//  Define.h
//  RelaxApp
//
//  Created by JoJo on 10/1/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#ifndef Define_h
#define Define_h
#define COLOR_SLIDER_THUMB 0x50E3C2
#define COLOR_NAVIGATION_HOME 0x0241A8
#define COLOR_PAGE_ACTIVE 0x9013FE
#define COLOR_VOLUME 0x0241A8
#define COLOR_BACKGROUND_FAVORITE 0x14193D
#define COLOR_NAVIGATION_FAVORITE 0x0064FF
#define COLOR_ADDFAVORITE_TAGS 0x9013FE



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//
#define FILE_FAVORITE_SAVE @"FAVORITE.save"

typedef enum
{
    GESTURE_TAP = 1,
    GESTURE_LONG,
    
}GESTURE_TYPE;
#endif /* Define_h */
