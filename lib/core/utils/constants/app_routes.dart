part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const VERIFYCODE = _Paths.VERIFYCODE;
  static const USERINIT = _Paths.USERINIT;
  static const BOTTOMNAVBAR = _Paths.BOTTOMNAVBAR;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const VERIFYCODE = '/verify-code';
  static const USERINIT = '/user-init';
  static const BOTTOMNAVBAR = '/bottom-navbar';
}
