import 'dart:io';

import 'package:logger/logger.dart';

class FileOutput extends LogOutput {
  File f = File("log.txt");
  @override
  void output(OutputEvent event) {
    StringBuffer b = StringBuffer();
    b.writeln();
    b.writeAll(event.lines, "\n");
    b.writeln();

    f.writeAsString(b.toString());
    print(b.toString());
  }
}

FileOutput _output = FileOutput();

class Log {
  static Logger _logger = Logger(
    level: Level.all,
    output: _output,
  );

  static set level(Level newLevel) => Logger.level = newLevel;

  static void trace(Object? message) => _logger.t(message);
  static void debug(Object? message) => _logger.d(message);
  static void info(Object? message) => _logger.i(message);
  static void warning(Object? message) => _logger.w(message);
  static void error(Object? message) => _logger.e(message);
  static void fatal(Object? message) => _logger.f(message);
}
