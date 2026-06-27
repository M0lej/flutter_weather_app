extension IntExtension on int {
  String toTwoDigitString() {
    return '${this < 10 ? '0' : ''}$this';
  }
}
