import 'dart:async';
import 'dart:io';

class CliHandler {
  late Timer timer;
  int frameIndex = 0;
  final animationFrames = ['-', '\\', '|', '/'];
  void clearScreen() {
    print('\x1B[2J\x1B[0;0H');
  }

  void printWithLoadingAmimation(String message) {
    stdout.write('$message ');

    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      stdout.write(animationFrames[frameIndex]);
      stdout.write('\b'); // Move the cursor back one position

      frameIndex = (frameIndex + 1) % animationFrames.length;
    });
  }

  void stopLoadingAnimation() {
    timer.cancel();
    stdout.write('\r'); // Move the cursor to the beginning of the line
    stdout.write(
        ' ' * (animationFrames[frameIndex].length + 1)); // Clear the line
    stdout.write('\r'); // Move the cursor back to the beginning of the line
    print(''); // Move to the next line
  }

  void eraseLastLine() {
    stdout.write('\x1B[1A'); // Move the cursor up one line
    stdout.write('\x1B[K'); // Clear the line
  }

  void eraseSecondLastLine() {
    stdout.write('\x1B[2A'); // Move the cursor up two lines
    stdout.write('\x1B[K'); // Clear the line
  }

  void printErrorText(String message) {
    print('\x1B[1;31m$message\x1B[0m ');
  }

  void printBoldGreenText(String message) {
    print('\x1B[1;32m$message\x1B[0m ');
  }

  void printBoltCyanText(String message) {
    print('\x1B[1;36m$message\x1B[0m ');
  }
}
