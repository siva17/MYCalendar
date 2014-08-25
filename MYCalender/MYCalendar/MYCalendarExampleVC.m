//
//  MYCalendarExampleVC.m
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

#import "MYCalendarExampleVC.h"

@interface MYCalendarExampleVC ()

@property(nonatomic,retain) MYCalendarView *calendarView;

@end

@implementation MYCalendarExampleVC

@synthesize calendarView;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    calendarView = [[MYCalendarView alloc]initWithFrame:self.view.frame delegate:self];
    NSDictionary *augDisableDates = [[NSDictionary alloc]initWithObjectsAndKeys:
                                     @"1",@"10",
                                     @"1",@"12",
                                     @"1",@"18",
                                     @"1",@"21",
                                     @"1",@"26",
                                     nil];
    NSDictionary *sepDisableDates = [[NSDictionary alloc]initWithObjectsAndKeys:
                                     @"1",@"12",
                                     @"1",@"14",
                                     @"1",@"20",
                                     @"1",@"23",
                                     @"1",@"28",
                                     nil];
    NSDictionary *months2014 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                augDisableDates, @"8",
                                sepDisableDates, @"9",
                                nil];
    NSDictionary *disabledDates = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   months2014, @"2014",
                                   nil];
    [calendarView setDisabledDates:disabledDates];
    [self.view addSubview: self.calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calendarView:(MYCalendarView *)calendarView didSelectDate:(NSDate *)selectedDate {
    NSLog(@"Selected date: %@", selectedDate);
}

@end
