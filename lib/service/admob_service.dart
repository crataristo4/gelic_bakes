import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  //todo - change
  static String get bannerUnitId => Platform.isAndroid
      ? 'ca-app-pub-3804995784214108/8188278644'
      : "ca-app-pub-3804995784214108/7691361299";

  static String get interstitialId => Platform.isAndroid
      ? 'ca-app-pub-3804995784214108/1683715514'
      : 'ca-app-pub-3804995784214108/1847367042';

  InterstitialAd? _interstitialAd;
  int numOfAttempts = 0;

  static initialMobileAds() {
    MobileAds.instance.initialize();
  }

  static BannerAd createBannerMedium() {
    BannerAd bannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: bannerUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => print('Ad loaded'),
            onAdOpened: (Ad ad) => print('Ad opened'),
            onAdClosed: (Ad ad) {
              ad.dispose();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            }),
        request: AdRequest());

    return bannerAd;
  }

  static BannerAd createBannerSmall() {
    BannerAd bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => print('Ad loaded'),
            onAdOpened: (Ad ad) => print('Ad opened'),
            onAdClosed: (Ad ad) {
              ad.dispose();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            }),
        request: AdRequest());

    return bannerAd;
  }

  static BannerAd createBannerFull() {
    BannerAd bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => print('Ad loaded'),
            onAdOpened: (Ad ad) => print('Ad opened'),
            onAdClosed: (Ad ad) {
              ad.dispose();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            }),
        request: AdRequest());

    return bannerAd;
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
            numOfAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            numOfAttempts++;
            _interstitialAd = null;

            if (numOfAttempts <= 2) createInterstitialAd();
          },
        )).onError((error, stackTrace) {
      print('Error: $error Stacktrace: $stackTrace');
    });
  }

  void showInterstitialAd() {
    if (interstitialId == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        // createInterstitialAd();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );

    _interstitialAd?.show();
  }
}
