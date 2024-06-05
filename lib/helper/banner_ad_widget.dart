// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class BannerAdWidget extends StatefulWidget {
//   const BannerAdWidget({super.key});
//
//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }
//
// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   late final BannerAd banner;
//
//   @override
//   void initState() {
//     super.initState();
//     // 사용할 광고 ID 설정
//     final adUnitId = Platform.isIOS ? 'ca-app-pub-3940256099942544/5354046379' : 'ca-app-pub-3940256099942544/6978759866';
//
//     // 광고 생성
//     banner = BannerAd(
//       size: AdSize.banner,
//       adUnitId: adUnitId,
//       listener: BannerAdListener(
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//         },
//       ),
//       request: AdRequest(),
//     );
//
//     // 광고를 로딩
//     banner.load();
//   }
//
//   @override
//   void dispose() {
//     banner.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // 광고 높이 지정
//       height: 75,
//       // 광고 위젯에 banner 변수를 입력한다
//       child: AdWidget(ad: banner),
//     );
//   }
// }
//
// // 사용 예시: view 에서 광고를 나타낼 위젯에 반환하거나 가져온다. (return BannerAdWidget)