//
//  MYCalendarCell.m
//  MYCalender
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
//  Orginal version is from below author
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "MYCalendarCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MYCalendarCell

-(void)setDay:(NSUInteger)day {
    if (_day != day) {
        _day = day;
        [self setTitle: [NSString stringWithFormat: @"%d", _day] forState: UIControlStateNormal];
    }
}

-(NSDate *)dateWithBaseDate:(NSDate *)baseDate withCalendar:(NSCalendar *)calendar {
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:baseDate];
    components.day = self.day;
    return [calendar dateFromComponents:components];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected) {
    	[[self layer] setBorderColor:self.borderHighlightColor.CGColor];
    	[[self layer] setBorderWidth:2.0];
    } else {
    	[[self layer] setBorderColor:[UIColor clearColor].CGColor];
    	[[self layer] setBorderWidth:0.0];
    }
}

@end
