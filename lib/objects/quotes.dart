import 'dart:math';

class QuoteGenerator {
  final List<String> morningQuotes = [
    'Chúc bạn có một buổi sáng tốt lành!',
    'Sáng nay may mắn sẽ đến với bạn!',
    'Hãy bắt đầu ngày mới với năng lượng tích cực!'
  ];

  final List<String> afternoonQuotes = [
    'Chúc bạn có một buổi chiều tràn đầy năng lượng!',
    'Hãy tiếp tục giữ vững tinh thần vào buổi chiều này!',
    'Chiều nay, mọi điều tốt lành sẽ đến với bạn!'
  ];

  final List<String> nightQuotes = [
    'Chúc bạn có một đêm tràn đầy hạnh phúc và bình yên!',
    'Đêm nay sẽ là một đêm đặc biệt cho bạn!',
    'Hãy tận hưởng những giây phút yên bình của đêm!'
  ];

  String getQuoteByTime() {
    var now = DateTime.now();
    var hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return morningQuotes[Random().nextInt(morningQuotes.length)];
    } else if (hour >= 12 && hour < 18) {
      return afternoonQuotes[Random().nextInt(afternoonQuotes.length)];
    } else {
      return nightQuotes[Random().nextInt(nightQuotes.length)];
    }
  }
}
