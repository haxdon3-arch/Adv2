#import <UIKit/UIKit.h>

// ---------------------------------------------------------
// 1. Google AdMob (GADRewardedAd)
// โค้ดนี้จะดักตอนมันเรียกโฆษณา แล้วสั่งรัน Block แจ้งว่าเราดูจบแล้วทันที
// ---------------------------------------------------------
%hook GADRewardedAd
- (void)presentFromRootViewController:(UIViewController *)rootViewController userDidEarnRewardHandler:(void (^)(void))rewardHandler {
    // ถ้ามีฟังก์ชั่นแจกรางวัล ส่งคำสั่งแจกเลยโดยไม่ต้องแสดงโฆษณา
    if (rewardHandler) {
        rewardHandler();
    }
}
%end

// ---------------------------------------------------------
// 2. Unity Ads
// ดักตอนโชว์โฆษณา แล้วสะกิดบอก Delegate ว่าสถานะ = 1 (Completed)
// ---------------------------------------------------------
%hook UnityAds
+ (void)show:(UIViewController *)viewController placementId:(NSString *)placementId showDelegate:(id)showDelegate {
    // ตรวจสอบว่าระบบมีตัวรับสัญญาณไหม ถ้ามี สั่งยิงสถานะดูจบ (State 1) ทันที
    if ([showDelegate respondsToSelector:@selector(unityAdsShowComplete:withShowFinishState:)]) {
        [showDelegate unityAdsShowComplete:placementId withShowFinishState:1];
    }
}
%end

// ---------------------------------------------------------
// 3. AppLovin MAX (MARewardedAd)
// ---------------------------------------------------------
%hook MARewardedAd
- (void)showAd {
    // ดึงตัวจัดการรางวัลมา แล้วหลอกว่าดูจบแล้ว
    id delegate = [self performSelector:@selector(delegate)];
    if ([delegate respondsToSelector:@selector(didRewardUserForAd:withReward:)]) {
        [delegate didRewardUserForAd:self withReward:nil];
    }
    // สั่งปิดหน้าต่างโฆษณาทิพย์
    if ([delegate respondsToSelector:@selector(didHideAd:)]) {
        [delegate didHideAd:self];
    }
}
%end
