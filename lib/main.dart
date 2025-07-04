// import 'package:carwash_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'carWashDetails.dart';
import 'paymentInProgress.dart';
import 'MainSplashScreen.dart';
import 'ManageVehicle.dart';
import 'verify_account_screen.dart';
import 'products_page.dart';
import 'transaction_history.dart';
import 'MainSplashScreen.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // home: OnboardingScreen(),
      // home: SplashScreen(),
      // home: ManageVehicle(),
      home: SplashScreen(),
      //home: ProductsPage(),
      // PaymentInProgress(
      //   amount: 0.0,
      //   paymentMethod: 'Default',
      // ),
      //home: TransactionHistoryScreen()
    );
  }
}
