//
//  IGMainViewController.m
//  IGT002
//
//  Created by Ming Liu on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGMainViewController.h"

#define kNumberOfPages 4

@implementation IGMainViewController

@synthesize scrollView, pageControl, viewControllers;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbak.png"]];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-8, SCREEN_WIDTH, 10)];
        pageControl.hidden = NO;
        
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < kNumberOfPages; i++)
        {
            [controllers addObject:[NSNull null]];
        }
        self.viewControllers = controllers;
        
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH,0);
        
        pageControl.numberOfPages = kNumberOfPages;
        pageControl.currentPage = 1;
        pageControl.backgroundColor = [UIColor clearColor];
        
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
        [self loadScrollViewWithPage:1];
        [NSThread detachNewThreadSelector:@selector(loadOhterView) toTarget:self withObject:nil];
        
        [self.view addSubview:scrollView];
        [self.view addSubview:pageControl];
    }
    return self;
}

-(void)loadOhterView
{
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:2];
    [self loadScrollViewWithPage:3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    UIViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        switch (page) {
            case 0:
                controller = [[IGA02ViewController alloc] init];
                break;
            case 1:
                controller = [[IGA01ViewController alloc] init];
                break;
            case 2:
                controller = [[IGA03ViewController alloc] init];
                break;
            case 3:
                controller = [[IGA04ViewController alloc] init];
            default:
                break;
        }
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed)
    {
        return;
    }
	
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}
@end
