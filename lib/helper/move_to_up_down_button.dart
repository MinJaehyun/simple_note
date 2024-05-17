// todo: 추후 add_memo 에서 분리하기

// import 'package:flutter/material.dart';
//
// class MoveToUpDownButton extends StatefulWidget {
//   const MoveToUpDownButton({super.key});
//
//   @override
//   State<MoveToUpDownButton> createState() => _MoveToUpDownButtonState();
// }
//
// class _MoveToUpDownButtonState extends State<MoveToUpDownButton> {
//   // _showScrollToTopButton
//   bool _showScrollToTopButton = false;
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() {
//     if (scrollController.offset >= 200 && !_showScrollToTopButton) {
//       setState(() {
//         _showScrollToTopButton = true;
//       });
//     } else if (scrollController.offset < 200 && _showScrollToTopButton) {
//       setState(() {
//         _showScrollToTopButton = false;
//       });
//     }
//   }
//
//   void _scrollToTop() {
//     scrollController.animateTo(
//       0.0,
//       duration: Duration(seconds: 1),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _scrollToDown() {
//     scrollController.animateTo(
//       479.0,
//       duration: Duration(seconds: 1),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text('test move btn');
//   }
// }
