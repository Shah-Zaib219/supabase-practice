import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_practice/app/app.bottomsheets.dart';
import 'package:supabase_practice/app/app.dialogs.dart';
import 'package:supabase_practice/app/app.locator.dart';
import 'package:supabase_practice/app/app.router.dart';
import 'package:supabase_practice/ui/common/app_theme.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mrhltrijftbmbbauzosv.supabase.co',
    publishableKey: 'sb_publishable_8OvRxUMgcGfA7TaeM81YUQ_zXDdLuiB',
  );
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Practice',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
    );
  }
}
