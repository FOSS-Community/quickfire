import 'dart:io';

import 'package:quickfire/commands/tools/cli_handler.dart';

class ChoiceSelector {
  List<String> options;
  int selectedIndex;

  ChoiceSelector(this.options) : selectedIndex = 0;

  int get selectedIndexForOptions => selectedIndex; // Getter method

  void printOptions() {
    for (int i = 0; i < options.length; i++) {
      if (i == selectedIndex) {
        print('* ${options[i]}');
      } else {
        print('  ${options[i]}');
      }
    }
  }

  void handleArrowKeys() {
    final cliHandler = CliHandler();
    stdin.lineMode = false;
    stdin.echoMode = false;

    while (true) {
      if (stdin.hasTerminal) {
        var key = stdin.readByteSync();
        if (key == 27) {
          // Arrow key sequence
          var arrowKey = stdin.readByteSync();
          if (arrowKey == 91) {
            var direction = stdin.readByteSync();
            if (direction == 65 && selectedIndex > 0) {
              // Up arrow
              selectedIndex--;
            } else if (direction == 66 && selectedIndex < options.length - 1) {
              // Down arrow
              selectedIndex++;
            }
            cliHandler.clearScreen();
            printOptions();
          }
        } else if (key == 10) {
          // Enter key
          break;
        }
      }
    }
    cliHandler.clearScreen();
    // print('\nSelected Option: ${options[selectedIndex]}');
    stdin.echoMode = true;
    stdin.lineMode = true;
  }
}
