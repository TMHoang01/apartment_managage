import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// format số tiền
class TextFormat {
  final formatter = NumberFormat("#,###");

  static String formatMoney(num number) {
    return NumberFormat("#,###").format(number);
  }

  static num parseMoney(String money) {
    return NumberFormat("#,###.##").parse(money);
  }

  static String formatMoneyWithSymbol(double number) {
    return '${NumberFormat("#,###", "vi_VN").format(number)}đ';
  }

  static String formatDate(DateTime? date, {String formatType = 'dd/MM/yyyy'}) {
    if (date == null) return '';
    return DateFormat(formatType).format(date);
  }

  static DateTime? parseJsonFormat(String? date,
      {String formatType = 'dd/MM/yyyy'}) {
    if (date == null || date.isEmpty) return null;
    return DateFormat(formatType).parse(date);
  }

  static DateTime? parseJson(dynamic json) {
    if (json == null || json.toString().isEmpty) {
      return null;
    }
    try {
      if (json is Timestamp) {
        return json.toDate();
      }

      return DateTime.parse(json.toString());
    } catch (e) {
      return null;
    }
  }
}
