//
//  BSModalSelectorViewTransitioningDelegate.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSModalSelectorViewTransitioningDelegate.h"
#import "BSVisualEffects.h"

@interface BSModalSelectorViewTransitioningDelegate ()
@property (nonatomic) BOOL isSetupAnimation;
@end

@implementation BSModalSelectorViewTransitioningDelegate


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isSetupAnimation = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isSetupAnimation = NO;
    return self;
}




- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView *shadowImageView = (UIImageView*)[toViewController.view viewWithTag:200];
    shadowImageView.image =  [[UIImage imageNamed:@"shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];    
    
    if (self.isSetupAnimation)
    {
        toViewController.view.frame = CGRectMake(0, 64, fromViewController.view.frame.size.width, 215);
        UIView *contentView = [toViewController.view viewWithTag:100];
        CGRect contentStartFrame = contentView.frame;
        contentStartFrame.origin.y -= contentStartFrame.size.height;
        CGRect contentEndFrame = contentView.frame;
        
        
        UIImageView *imageView = (UIImageView *)[contentView viewWithTag:400];
        imageView.image = [BSVisualEffects blurredViewImageFromView:fromViewController.view];
        
        UIView *blurrContainer = [contentView viewWithTag:777];
        CGRect  rect = blurrContainer.bounds;
        rect.origin.x += 0;
        rect.origin.y += 0;
        blurrContainer.bounds = rect;
        
        
        
        fromViewController.view.alpha = 0.9;
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        
        contentView.frame = contentStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:0 animations:^{
                                  fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                                  contentView.frame = contentEndFrame;
                                  
                                  CGRect  rect = blurrContainer.bounds;
                                  rect.origin.x += 50;
                                  rect.origin.y += 50;
                                  blurrContainer.bounds = rect;
                                  
                                  
                                  
                                  
                              } completion:^(BOOL finished) {
                                  [transitionContext completeTransition:YES];
                              }];
    }
    else
    {
        
        UIView *contentView = [fromViewController.view viewWithTag:100];
        CGRect contentEndFrame = contentView.frame;
        contentEndFrame.origin.y -= contentEndFrame.size.height;
        toViewController.view.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            contentView.frame = contentEndFrame;
            UIView *blurrContainer = [contentView viewWithTag:777];
            CGRect  rect = blurrContainer.bounds;
            rect.origin.x -= 50;
            rect.origin.y -= 50;
            blurrContainer.bounds = rect;
            
        } completion:^(BOOL finished) {
            toViewController.view.alpha = 1.0;
            [transitionContext completeTransition:YES];
        }];
    }
}


- (void)animationEnded:(BOOL) transitionCompleted
{
    
}

@end
