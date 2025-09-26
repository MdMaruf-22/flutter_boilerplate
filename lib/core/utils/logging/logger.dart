import 'package:logger/logger.dart';

class AppLoggerHelper{
  AppLoggerHelper._();
  static final Logger _logger = Logger(
    printer: PrettyPrinter(), // Customize the log levels based on your needs
    level: Level.debug, // Set the default log level
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error]) {
    _logger.e(message, error: error, stackTrace: StackTrace.current);
  }
}