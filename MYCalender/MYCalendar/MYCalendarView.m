//
//  MYCalendarView.m
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

#import "MYCalendarView.h"

#import <QuartzCore/QuartzCore.h>

#import "MYCalendarCell.h"
#import "UIColor+MYCalendar.h"
#import "UILabel+MYCalendar.h"
#import "UIButton+MYCalendar.h"


static const CGFloat kGridMargin = 4;
static const CGFloat kDefaultMonthBarButtonWidth = 60;

@interface MYCalendarView()
@property(nonatomic,assign) id<MYCalendarViewDelegate> delegate;
@property(nonatomic,retain) NSDate			*displayedDate;
@property(nonatomic,retain) NSCalendar		*calendar;
@property(nonatomic,readonly) NSUInteger	displayedYear;
@property(nonatomic,readonly) NSUInteger	displayedMonth;

// UI
@property(nonatomic,retain) UIView			*monthBar;
@property(nonatomic,retain) UILabel			*monthLabel;
@property(nonatomic,retain) UIButton		*monthBackButton;
@property(nonatomic,retain) UIButton		*monthForwardButton;
@property(nonatomic,retain) UIView			*weekdayBar;
@property(nonatomic,retain) NSArray			*weekdayNameLabels;
@property(nonatomic,retain) UIView			*gridView;
@property(nonatomic,retain) NSArray			*dayCells;
@property(nonatomic,retain) NSDateFormatter *dateFormatter;

@end

@implementation MYCalendarView

@synthesize selectedDate;
@synthesize disabledDates;
@synthesize monthBarHeight;
@synthesize weekBarHeight;
@synthesize dayCellHeight;

@synthesize monthBarBgColorRef;
@synthesize monthLabelTextAttributes;
@synthesize weekLabelTextAttributes;
@synthesize dayLabelNormalTextAttributes;
@synthesize dayLabelSelectedTextAttributes;
@synthesize dayLabelDisabledTextAttributes;

@synthesize delegate;
@synthesize displayedDate;
@synthesize calendar			= _calendar;
@synthesize monthBar			= _monthBar;
@synthesize monthLabel			= _monthLabel;
@synthesize monthBackButton		= _monthBackButton;
@synthesize monthForwardButton	= _monthForwardButton;
@synthesize weekdayBar			= _weekdayBar;
@synthesize weekdayNameLabels	= _weekdayNameLabels;
@synthesize gridView			= _gridView;
@synthesize dayCells			= _dayCells;
@synthesize dateFormatter		= _dateFormatter;


#pragma mark - Lazy instantiation.

-(UIView *)monthBar {
    if (!_monthBar) {
        _monthBar = [[UIView alloc] init];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: _monthBar];
    }
    return _monthBar;
}

-(UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _monthLabel.backgroundColor = monthLabelTextAttributes[NSForegroundColorAttributeName];
        [_monthLabel mySetTextAttributes:monthLabelTextAttributes];
        [self.monthBar addSubview: _monthLabel];
    }
    return _monthLabel;
}

-(UIButton *)monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[UIButton alloc] init];
        [_monthBackButton setTitle: @"<" forState:UIControlStateNormal];
        [_monthBackButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
       	[_monthBackButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_monthBackButton addTarget: self action: @selector(monthBack) forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthBackButton];
    }
    return _monthBackButton;
}

-(UIButton *)monthForwardButton {
    if (!_monthForwardButton) {
        _monthForwardButton = [[UIButton alloc] init];
        [_monthForwardButton setTitle: @">" forState:UIControlStateNormal];
        [_monthForwardButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
       	[_monthForwardButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_monthForwardButton addTarget: self action: @selector(monthForward) forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthForwardButton];
    }
    return _monthForwardButton;
}

-(UIView *)weekdayBar {
    if (!_weekdayBar) {
        _weekdayBar = [[UIView alloc] init];
        _weekdayBar.backgroundColor = weekLabelTextAttributes[NSBackgroundColorAttributeName];
    }
    return _weekdayBar;
}

-(NSArray *)weekdayNameLabels {
    if (!_weekdayNameLabels) {
        NSMutableArray *labels = [NSMutableArray array];
        
        for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);
            
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
            label.tag = i;
            [label mySetTextAttributes:self.weekLabelTextAttributes];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [[self.dateFormatter shortWeekdaySymbols] objectAtIndex: index];
            
            [labels addObject:label];
            [_weekdayBar addSubview: label];
        }
        
        [self addSubview:_weekdayBar];
        _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
    }
    return _weekdayNameLabels;
}

-(UIView *)gridView {
    if (!_gridView) {
        _gridView = [[UIView alloc] init];
        _gridView.backgroundColor = dayLabelNormalTextAttributes[NSBackgroundColorAttributeName];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: _gridView];
    }
    return _gridView;
}

-(NSArray *)dayCells {
    if (!_dayCells) {
        NSMutableArray *cells = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 31; ++i) {
            MYCalendarCell *cell = [MYCalendarCell new];
            cell.tag = i;
            cell.day = i;
            cell.borderHighlightColor = dayLabelSelectedTextAttributes[NSBackgroundColorDocumentAttribute];
            [cell mySetTitleTextAttributes:dayLabelNormalTextAttributes forState:UIControlStateNormal];
            [cell mySetTitleTextAttributes:dayLabelSelectedTextAttributes forState:UIControlStateSelected];
            [cell mySetTitleTextAttributes:dayLabelDisabledTextAttributes forState:UIControlStateDisabled];
            [cell addTarget: self action: @selector(touchedCellView:) forControlEvents: UIControlEventTouchUpInside];
            
            
            [cells addObject:cell];
            [self.gridView addSubview: cell];
        }
        _dayCells = [[NSArray alloc] initWithArray:cells];
    }
    return _dayCells;
}

-(NSDateFormatter *)dateFormatter {
    if(!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
		_dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    }
    return _dateFormatter;
}

-(NSCalendar *)calendar {
    if(!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        self.dateFormatter.calendar = _calendar;
    }
    return _calendar;
}

#pragma mark - Public APIs

-(id)initWithFrame:(CGRect)frame delegate:(id)dlg {
    if ((self = [super initWithFrame: frame])) {
        self.delegate = dlg;
        [self setDefaults];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setDefaults];
}


#pragma mark - Private APIs

-(void)setDefaults {

    // TODO: Merge default text attributes when given custom ones!
    disabledDates = nil;
    
    monthBarBgColorRef = CGGradientCreateWithColors(NULL,
        (CFArrayRef)@[
            (id)[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor,
            (id)[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor], NULL);

    monthLabelTextAttributes = @{
        NSForegroundColorAttributeName	: [UIColor darkGrayColor],
        NSBackgroundColorAttributeName	: [UIColor clearColor],
        NSFontAttributeName				: [UIFont fontWithName:@"Helvetica-Bold" size:20],
        NSShadowAttributeName			: [UIColor whiteColor],
        NSBaselineOffsetAttributeName	: [NSValue valueWithCGSize:CGSizeMake(0, 1)]
    };
    weekLabelTextAttributes = @{
        NSForegroundColorAttributeName 	: [UIColor whiteColor],
        NSBackgroundColorAttributeName	: THEME_COLOR,
        NSFontAttributeName 			: [UIFont fontWithName:@"Helvetica-Bold" size:16],
        NSBaselineOffsetAttributeName	: [NSValue valueWithCGSize:CGSizeMake(0, 1)]
    };
    dayLabelNormalTextAttributes = @{
        NSForegroundColorAttributeName	: [UIColor whiteColor],
        NSFontAttributeName 			: [UIFont fontWithName:@"Helvetica-Bold" size:20],
        NSBackgroundColorAttributeName	: THEME_COLOR
    };
    dayLabelSelectedTextAttributes = @{
        NSForegroundColorAttributeName	: [UIColor whiteColor],
        NSBackgroundColorAttributeName	: THEME_COLOR,
        NSBackgroundColorDocumentAttribute : [UIColor whiteColor],
    };
    dayLabelDisabledTextAttributes = @{
       NSForegroundColorAttributeName	: [UIColor grayColor],
       NSBackgroundColorAttributeName	: THEME_COLOR
    };

    self.selectedDate	= nil;
    self.displayedDate	= [NSDate date];
    self.monthBarHeight	= 48;
    self.weekBarHeight	= 40;
    self.dayCellHeight	= 0; // 0 means auto
}

-(void)updateSelectedDate {
    for (MYCalendarCell *cellView in self.dayCells) {
        cellView.selected = NO;
    }
    [self cellForDate: selectedDate].selected = YES;
}


-(void)setSelectedDate:(NSDate *)selDate {
    if (![selDate isEqual:selectedDate]) {
        selectedDate = selDate;
        [self updateSelectedDate];
        if((self.delegate) && ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)])) {
            [self.delegate calendarView: self didSelectDate: selectedDate];
        }
    }
}

-(void)setDisplayedDate:(NSDate *)dspDate {
    if (displayedDate != dspDate) {
        displayedDate = dspDate;
        NSString *monthName = [[self.dateFormatter standaloneMonthSymbols] objectAtIndex: self.displayedMonth - 1];
        self.monthLabel.text = [NSString stringWithFormat: @"%@ %d", monthName, self.displayedYear];
        [self updateSelectedDate];
        [self setNeedsLayout];
    }
}

-(NSUInteger)displayedYear {
    NSDateComponents *components = [self.calendar components: NSYearCalendarUnit fromDate: self.displayedDate];
    return components.year;
}

-(NSUInteger)displayedMonth {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit fromDate: self.displayedDate];
    return components.month;
}

-(void)setMonthBarHeight:(CGFloat)height {
    if (monthBarHeight != height) {
		monthBarHeight = height;
		[self setNeedsLayout];
    }
}
-(void)setWeekBarHeight:(CGFloat)height {
    if (weekBarHeight != height) {
        weekBarHeight = height;
        [self setNeedsLayout];
    }
}
-(void)setDayCellHeight:(CGFloat)height {
    if(height != dayCellHeight) {
        dayCellHeight = height;
        [self setNeedsDisplay];
    }
}

-(void)touchedCellView:(MYCalendarCell *)cellView {
    [self setSelectedDate:[cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar]];
}

-(void)monthForward {
    NSDateComponents *monthStep = [NSDateComponents new];
    monthStep.month = 1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
}

-(void)monthBack {
    NSDateComponents *monthStep = [NSDateComponents new];
    monthStep.month = -1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
}

-(NSDate *)displayedMonthStartDate {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit|NSYearCalendarUnit fromDate: self.displayedDate];
    components.day = 1;
    return [self.calendar dateFromComponents: components];
}

-(MYCalendarCell *)cellForDate:(NSDate *)date {
    if (!date) return nil;

    NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate: date];
    if((components.month == self.displayedMonth) &&
       (components.year == self.displayedYear) &&
       ([self.dayCells count] >= components.day)) {
        return [self.dayCells objectAtIndex: components.day - 1];
    }
    return nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.backgroundColor = dayLabelNormalTextAttributes[NSBackgroundColorAttributeName];
    self.monthBar.backgroundColor = [UIColor myColorWithGradient:monthBarBgColorRef size:CGSizeMake(1, monthBarHeight)];
    [self.monthLabel mySetTextAttributes:self.monthLabelTextAttributes];

    CGFloat top = 0;

    if(self.monthBarHeight) {
        self.monthBar.frame = CGRectMake(0, top, self.bounds.size.width, self.monthBarHeight);
        self.monthLabel.frame = CGRectMake(0, top, self.bounds.size.width, self.monthBar.bounds.size.height);
        self.monthForwardButton.frame = CGRectMake(self.monthBar.bounds.size.width - kDefaultMonthBarButtonWidth, top, kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        self.monthBackButton.frame = CGRectMake(0, top, kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        top = self.monthBar.frame.origin.y + self.monthBar.frame.size.height;
    } else {
        self.monthBar.frame = CGRectZero;
    }

    if(self.weekBarHeight) {
        self.weekdayBar.frame = CGRectMake(0, top, self.bounds.size.width, self.weekBarHeight);
        CGRect contentRect = CGRectInset(self.weekdayBar.bounds, kGridMargin, 0);
        for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
            UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
            label.frame = CGRectMake((contentRect.size.width / 7) * (i % 7), 0, contentRect.size.width / 7, contentRect.size.height);
        }
        top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
    } else {
        self.weekdayBar.frame = CGRectZero;
    }

    // Calculate shift
    NSDateComponents *components = [self.calendar components: NSWeekdayCalendarUnit fromDate: [self displayedMonthStartDate]];
    NSInteger shift = components.weekday - self.calendar.firstWeekday;
    if (shift < 0) shift = 7 + shift;

    BOOL enabledDays[31];
    memset(enabledDays, true, sizeof(BOOL)*31);
    if(disabledDates) {
        NSDictionary *disabledYear = [disabledDates objectForKey:[NSString stringWithFormat:@"%d",self.displayedYear]];
        if(disabledYear) {
            NSDictionary *disabledMonth = [disabledYear objectForKey:[NSString stringWithFormat:@"%d",self.displayedMonth]];
            if(disabledMonth) {
                for (int i=0; i < 31; i++) {
                    enabledDays[i] = (([disabledMonth objectForKey:[NSString stringWithFormat:@"%d",i+1]])?(false):(true));
                }
            }
        }
    }
    
    // Calculate range
    NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.displayedDate];

    self.gridView.frame = CGRectMake(kGridMargin, top, self.bounds.size.width - kGridMargin * 2, self.bounds.size.height - top);
    CGFloat cellWidth = (self.bounds.size.width - kGridMargin * 2) / 7.0;
    CGFloat cellHeight = ((dayCellHeight <= 0)?(cellWidth):(dayCellHeight));
    for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
        MYCalendarCell *cellView = [self.dayCells objectAtIndex:i];
        cellView.enabled = enabledDays[i];
        cellView.frame = CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7), cellWidth, cellHeight);
        cellView.hidden = i >= range.length;
    }
}

@end
