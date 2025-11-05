
import 'package:intl/intl.dart';
import 'package:get/get.dart';
class DatetimeFormat {


  static String formatDateTimeWithDifference(dynamic dateTime) {
    if (dateTime == null) return 'Invalid date'.tr;

    DateTime? parsedDate;
    if (dateTime is DateTime) {
      parsedDate = dateTime;
    } else {

      parsedDate = DateTime.tryParse(dateTime.toString());
    }


    if (parsedDate == null) return 'Invalid date'.tr;

    final Duration difference = DateTime.now().difference(parsedDate);


    if (difference.isNegative) {

      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(parsedDate);
    }


    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${'second'.tr}${difference.inSeconds != 1 ? 's' : ''} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${'minute'.tr}${difference.inMinutes != 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${'hour'.tr}${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${'day'.tr}${difference.inDays != 1 ? 's' : ''} ago';
    } else {
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      return formatter.format(parsedDate);
    }
  }
}
