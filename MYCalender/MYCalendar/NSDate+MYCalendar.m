//
//  NSDate+MYCalendar.m
//  Extensions
//
//  Created by Siva RamaKrishna Ravuri
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//

#import "NSDate+MYCalendar.h"

@implementation NSDate (MY)
-(int)diffBetween:(NSDate *)toDate unit:(NSInteger)unit {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unit fromDate:self toDate:toDate options:0];
    if(unit == NSDayCalendarUnit) {
        if([self isEqualToDate:toDate]) return 0;
        int days = [components day];
        if(days < 0) return days;
        else return (days + 1);
    } else if(unit == NSMonthCalendarUnit) {
        NSDateComponents *fromComponents = [calendar components:unit|NSYearCalendarUnit fromDate:self];
        NSDateComponents *toComponents = [calendar components:unit|NSYearCalendarUnit fromDate:toDate];
        [fromComponents setDay:1];
        [toComponents setDay:1];
        if([[calendar dateFromComponents:fromComponents] isEqualToDate:[calendar dateFromComponents:toComponents]]) {
            return 0;
        }
        int months = [components month];
        if(months <= 0) return (months - 1);
        else return months;
    }
    return 0;
}
-(NSDate *)getDateWithDay:(int)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:self];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}
@end
