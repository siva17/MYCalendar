//
//  MYCalendarView.h
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

@class MYCalendarView;
@protocol MYCalendarViewDelegate <NSObject>
@optional
-(void)calendarView:(MYCalendarView *)calendarView didSelectDate:(NSDate *)selectedDate;
@end

@interface MYCalendarView : UIView

@property(nonatomic,retain) NSDate			*selectedDate;
@property(nonatomic,retain) NSDictionary	*disabledDates;
@property(nonatomic,assign) CGFloat			monthBarHeight;
@property(nonatomic,assign) CGFloat			weekBarHeight;
@property(nonatomic,assign) CGFloat			dayCellHeight;
@property(nonatomic,assign) BOOL			disablePastDates;

@property(nonatomic,assign) CGGradientRef 	monthBarBgColorRef;
@property(nonatomic,retain) NSDictionary	*monthLabelTextAttributes;
@property(nonatomic,retain) NSDictionary	*weekLabelTextAttributes;
@property(nonatomic,retain) NSDictionary	*dayLabelNormalTextAttributes;
@property(nonatomic,retain) NSDictionary	*dayLabelSelectedTextAttributes;
@property(nonatomic,retain) NSDictionary	*dayLabelDisabledTextAttributes;

-(id)initWithFrame:(CGRect)frame delegate:(id)dlg;
-(CGSize)getCalendarViewSize;
@end
