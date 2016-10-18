//
//  Define.h
//  RelaxApp
//
//  Created by JoJo on 10/1/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#ifndef Define_h
#define Define_h
#define BASE_URL @"https://data.relafapp.com/data-examples/data/"
#define BASE_IMAGE_URL @"https://data.relafapp.com/data-examples/data/img/"

#define COLOR_SLIDER_THUMB 0x50E3C2
#define COLOR_NAVIGATION_HOME 0x0241A8
#define COLOR_PAGE_ACTIVE 0x9013FE
#define COLOR_VOLUME 0x0241A8
#define COLOR_BACKGROUND_FAVORITE 0x14193D
#define COLOR_NAVIGATION_FAVORITE 0x000000
#define COLOR_ADDFAVORITE_TAGS 0x9013FE

#define COLOR_BELING_MODE 0x000000
#define COLOR_PROGRESS 0x3023AE
#define COLOR_PROGRESS_HOZI 0xC86DD7



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromAlpha(rgbValue , a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)(a))]

//
#define FILE_FAVORITE_SAVE @"FAVORITE.save"
#define FILE_TIMER_SAVE @"TIMER.save"
#define FILE_CATEGORY_SAVE @"CATEGORY.save"
#define FILE_BLACKLIST_CATEGORY_SAVE @"BACLIST_CATEGORY.save"
#define FILE_HISTORY_VOLUME_SAVE @"HISTORY_VOLUME.save"

#define NOTIFCATION_TIMER @"NOTIFICATION_TIMER"
#define NOTIFCATION_CATEGORY @"NOTIFCATION_CATEGORY"
#define DEFAULT_VOLUME 0.5

#define NAME_APP @"Relaf"

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

typedef enum
{
    GESTURE_TAP = 1,
    GESTURE_LONG,
    
}GESTURE_TYPE;
typedef enum
{
    TIMER_COUNTDOWN = 1,
    TIMER_CLOCK,
    
}TIMER_TYPE;
typedef enum
{
    MODE_CREATE = 1,
    MODE_EDIT,
    MODE_INFO
    
}MODE_TYPE;
typedef enum
{
    BUTTON_RANDOM = 1,
    BUTTON_PLAYING,
    BUTTON_PAUSE,
    BUTTON_BACK_HOME,
    BUTTON_VOLUME,
    BUTTON_FAVORITE,
    BUTTON_TIMER,
    BUTTON_SETTING
    
}HOME_BUTTON_TYPE;
#endif /* Define_h */
