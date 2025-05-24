// // import 'package:admob_flutter/admob_flutter.dart';
// // import 'package:flutter/widgets.dart';

// // class AdmobBannerCustom extends StatelessWidget {
// //   const AdmobBannerCustom({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return AdmobBanner(
// //       adUnitId: AdmobBanner.testAdUnitId,
// //       adSize: AdmobBannerSize.BANNER,
// //       listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
// //         switch (event) {
// //           case AdmobAdEvent.loaded:
// //             log('Admob banner loaded!');
// //             break;

// //           case AdmobAdEvent.opened:
// //             log('Admob banner opened!');
// //             break;

// //           case AdmobAdEvent.closed:
// //             log('Admob banner closed!');
// //             break;

// //           case AdmobAdEvent.failedToLoad:
// //             log(
// //                 'Admob banner failed to load. Error code: ${args!['errorCode']}');
// //             break;
// //           case AdmobAdEvent.clicked:
// //           // TODO: Handle this case.
// //           // break;
// //           case AdmobAdEvent.impression:
// //           // TODO: Handle this case.
// //           // break;
// //           case AdmobAdEvent.leftApplication:
// //           // TODO: Handle this case.
// //           // break;
// //           case AdmobAdEvent.completed:
// //           // TODO: Handle this case.
// //           // break;
// //           case AdmobAdEvent.rewarded:
// //           // TODO: Handle this case.
// //           // break;
// //           case AdmobAdEvent.started:
// //           // TODO: Handle this case.
// //           // break;
// //           // default:
// //         }
// //       },
// //     );
// //   }
// // }
// // Copyright 2021 Google LLC
// //
// // Licensed under the Apache License, Version 2.0 (the "License");
// // you may not use this file except in compliance with the License.
// // You may obtain a copy of the License at
// //
// // https://www.apache.org/licenses/LICENSE-2.0
// //
// // Unless required by applicable law or agreed to in writing, software
// // distributed under the License is distributed on an "AS IS" BASIS,
// // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// // See the License for the specific language governing permissions and
// // limitations under the License.

// // ignore_for_file: public_member_api_docs

// import 'dart:io' show Platform;

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'dart:developer';

// import 'anchored_adaptive_example.dart';
// import 'fluid_example.dart';
// import 'inline_adaptive_example.dart';
// import 'native_template_example.dart';
// import 'reusable_inline_example.dart';
// // import 'webview_example.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   MobileAds.instance.initialize();
// //   runApp(MyApp());
// // }

// // You can also test with your own ad unit IDs by registering your device as a
// // test device. Check the logs for your device's ID value.
// const String testDevice = '9c073310-20bf-4aeb-9fc6-acefcf9f1300';
// const int maxFailedLoadAttempts = 3;

// class MyAppAds extends StatefulWidget {
//   const MyAppAds({super.key});

//   @override
//   _MyAppAdsState createState() => _MyAppAdsState();
// }

// class _MyAppAdsState extends State<MyAppAds> {
//   static const AdRequest request = AdRequest(
//     keywords: <String>['foo', 'bar'],
//     contentUrl: 'http://foo.com/bar.html',
//     nonPersonalizedAds: true,
//   );

//   static const interstitialButtonText = 'InterstitialAd';
//   static const rewardedButtonText = 'RewardedAd';
//   static const rewardedInterstitialButtonText = 'RewardedInterstitialAd';
//   static const fluidButtonText = 'Fluid';
//   static const inlineAdaptiveButtonText = 'Inline adaptive';
//   static const anchoredAdaptiveButtonText = 'Anchored adaptive';
//   static const nativeTemplateButtonText = 'Native template';
//   // static const webviewExampleButtonText = 'Register WebView';
//   static const adInspectorButtonText = 'Ad Inspector';

//   InterstitialAd? _interstitialAd;
//   int _numInterstitialLoadAttempts = 0;

//   RewardedAd? _rewardedAd;
//   int _numRewardedLoadAttempts = 0;

//   RewardedInterstitialAd? _rewardedInterstitialAd;
//   int _numRewardedInterstitialLoadAttempts = 0;

//   @override
//   void initState() {
//     super.initState();
//     MobileAds.instance.updateRequestConfiguration(
//         RequestConfiguration(testDeviceIds: [testDevice]));
//     _createInterstitialAd();
//     _createRewardedAd();
//     _createRewardedInterstitialAd();
//   }

//   void _createInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-5161431306432459/5068576966'
//             : 'ca-app-pub-5161431306432459/5068576966',
//         request: request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             log('$ad loaded');
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             _interstitialAd!.setImmersiveMode(true);
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             log('InterstitialAd failed to load: $error.');
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;
//             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               _createInterstitialAd();
//             }
//           },
//         ));
//   }

//   void _showInterstitialAd() {
//     if (_interstitialAd == null) {
//       log('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) =>
//           log('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         log('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         log('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//     );
//     _interstitialAd!.show();
//     _interstitialAd = null;
//   }

//   void _createRewardedAd() {
//     RewardedAd.load(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-5161431306432459/6264316554'
//             : 'ca-app-pub-5161431306432459/5068576966',
//         request: request,
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (RewardedAd ad) {
//             log('$ad loaded.');
//             _rewardedAd = ad;
//             _numRewardedLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             log('RewardedAd failed to load: $error');
//             _rewardedAd = null;
//             _numRewardedLoadAttempts += 1;
//             if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
//               _createRewardedAd();
//             }
//           },
//         ));
//   }

//   void _showRewardedAd() {
//     if (_rewardedAd == null) {
//       log('Warning: attempt to show rewarded before loaded.');
//       return;
//     }
//     _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) =>
//           log('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         log('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createRewardedAd();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         log('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createRewardedAd();
//       },
//     );

//     _rewardedAd!.setImmersiveMode(true);
//     _rewardedAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     _rewardedAd = null;
//   }

//   void _createRewardedInterstitialAd() {
//     RewardedInterstitialAd.load(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-5161431306432459/4951234887'
//             : 'ca-app-pub-5161431306432459/4951234887',
//         request: request,
//         rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//           onAdLoaded: (RewardedInterstitialAd ad) {
//             log('$ad loaded.');
//             _rewardedInterstitialAd = ad;
//             _numRewardedInterstitialLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             log('RewardedInterstitialAd failed to load: $error');
//             _rewardedInterstitialAd = null;
//             _numRewardedInterstitialLoadAttempts += 1;
//             if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               _createRewardedInterstitialAd();
//             }
//           },
//         ));
//   }

//   void _showRewardedInterstitialAd() {
//     if (_rewardedInterstitialAd == null) {
//       log('Warning: attempt to show rewarded interstitial before loaded.');
//       return;
//     }
//     _rewardedInterstitialAd!.fullScreenContentCallback =
//         FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
//           log('$ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
//         log('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createRewardedInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent:
//           (RewardedInterstitialAd ad, AdError error) {
//         log('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createRewardedInterstitialAd();
//       },
//     );

//     _rewardedInterstitialAd!.setImmersiveMode(true);
//     _rewardedInterstitialAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     _rewardedInterstitialAd = null;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _interstitialAd?.dispose();
//     _rewardedAd?.dispose();
//     _rewardedInterstitialAd?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Builder(builder: (BuildContext context) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('AdMob Plugin example app'),
//             actions: <Widget>[
//               PopupMenuButton<String>(
//                 onSelected: (String result) {
//                   switch (result) {
//                     case interstitialButtonText:
//                       _showInterstitialAd();
//                       break;
//                     case rewardedButtonText:
//                       _showRewardedAd();
//                       break;
//                     case rewardedInterstitialButtonText:
//                       _showRewardedInterstitialAd();
//                       break;
//                     case fluidButtonText:
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FluidExample()),
//                       );
//                       break;
//                     case inlineAdaptiveButtonText:
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => InlineAdaptiveExample()),
//                       );
//                       break;
//                     case anchoredAdaptiveButtonText:
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AnchoredAdaptiveExample()),
//                       );
//                       break;
//                     case nativeTemplateButtonText:
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => NativeTemplateExample()),
//                       );
//                       break;
//                     // case webviewExampleButtonText:
//                     //   Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => WebViewExample()),
//                     //   );
//                     //   break;
//                     case adInspectorButtonText:
//                       MobileAds.instance.openAdInspector((error) => log(
//                           'Ad Inspector ${error == null ? 'opened.' : 'error: ${error.message ?? ''}'}'));
//                       break;
//                     default:
//                       throw AssertionError('unexpected button: $result');
//                   }
//                 },
//                 itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                   const PopupMenuItem<String>(
//                     value: interstitialButtonText,
//                     child: Text(interstitialButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: rewardedButtonText,
//                     child: Text(rewardedButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: rewardedInterstitialButtonText,
//                     child: Text(rewardedInterstitialButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: fluidButtonText,
//                     child: Text(fluidButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: inlineAdaptiveButtonText,
//                     child: Text(inlineAdaptiveButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: anchoredAdaptiveButtonText,
//                     child: Text(anchoredAdaptiveButtonText),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: nativeTemplateButtonText,
//                     child: Text(nativeTemplateButtonText),
//                   ),
//                   // PopupMenuItem<String>(
//                   //   value: webviewExampleButtonText,
//                   //   child: Text(webviewExampleButtonText),
//                   // ),
//                   const PopupMenuItem<String>(
//                     value: adInspectorButtonText,
//                     child: Text(adInspectorButtonText),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           body: SafeArea(child: ReusableInlineExample()),
//         );
//       }),
//     );
//   }
// }
