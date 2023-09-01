import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimenstions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({super.key,required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder:(context, constraints){
          //webscreen
          if(constraints.maxWidth > webScreenSize){
            return webScreenLayout;
          }
          //mobile screen
          return mobileScreenLayout;
        },
    );
  }
}
