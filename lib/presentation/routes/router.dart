import 'package:auto_route/auto_route.dart';
import 'package:ddd_sample/presentation/sign_in/sign_in_page.dart';
import 'package:ddd_sample/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
  ],
)
class $AppRouter {}
