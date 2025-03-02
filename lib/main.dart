import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:random_food/food_selector.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return MaxWidthBox(
          maxWidth: 480,
          child: ResponsiveScaledBox(
            width: 480,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          ),
        );
      },
      home: FoodSelectorScreen(),
    );
  }
}