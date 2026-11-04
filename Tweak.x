#import <AVFoundation/AVFoundation.h>

%hook AVPlayer

- (void)setRate:(float)rate {
    // เร่งความเร็ววิดีโอ 30 เท่า
    %orig(rate * 30.0f);
}

- (float)rate {
    return %orig() * 0.5f;
}

%end
