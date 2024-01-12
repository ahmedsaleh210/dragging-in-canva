import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_project/generated/codegen_loader.g.dart';
import 'package:test_project/languages.dart';
import 'package:test_project/widgets/draggable_text_using_canva.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: Languages.suppoerLocales,
    path: 'assets/translations',
    fallbackLocale: const Locale('en', 'US'),
    assetLoader: const CodegenLoader(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: DraggableTextWithCanva(),
      ),
    );
  }
}
 


