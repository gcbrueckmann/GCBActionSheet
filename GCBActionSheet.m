//
//  GCBActionSheet.m
//
//  Copyright (c) 2013 Georg C. Brückmann (http://gcbrueckmann.de/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "GCBActionSheet.h"

@interface GCBActionSheet () {
	NSMutableArray *_buttonHandlers;
}

@end

@implementation GCBActionSheet

- (id)init {
	if ((self = [super init])) {
		_buttonHandlers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate {
	return [self initWithTitle:title delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
}

#if !__has_feature(objc_arc)
- (void)dealloc {
	[_buttonHandlers release], _buttonHandlers = nil;
	[super dealloc];
}
#endif

- (NSInteger)addButtonWithTitle:(NSString *)title {
	return [self addButtonWithTitle:title handler:nil];
}

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(void (^)(void))handler {
	NSInteger buttonIndex = [super addButtonWithTitle:title];
	if (handler) {
#if !__has_feature(objc_arc)
		handler = [[handler copy] autorelease];
#endif
		[_buttonHandlers addObject:handler];
	} else {
		[_buttonHandlers addObject:[NSNull null]];
	}
	return buttonIndex;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))handler {
	self.cancelButtonIndex = [self addButtonWithTitle:title handler:handler];
	return self.cancelButtonIndex;
}

- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))handler {
	self.destructiveButtonIndex = [self addButtonWithTitle:title handler:handler];
	return self.destructiveButtonIndex;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	if (buttonIndex != -1) {
		id handler = [_buttonHandlers objectAtIndex:buttonIndex];
		if (![handler isEqual:[NSNull null]]) {
			((void (^)())handler)();
		}
	}
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

@end
