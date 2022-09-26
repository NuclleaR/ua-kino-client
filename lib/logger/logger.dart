import 'package:logger/logger.dart';

class AppLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level]!;
    final emoji = PrettyPrinter.levelEmojis[event.level]!;

    var messages = [color("[${event.level}] $emoji ${event.message}")];

    if (event.error != null) {
      messages.add(color("Error ${event.error}"));
    }

    return messages;
  }
}

final logger = Logger(printer: AppLogPrinter());
final loggerRaw = Logger();
