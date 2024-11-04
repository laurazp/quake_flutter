class TsunamiValueFormatter {
  static String getTsunamiValue(int tsunami) {
        switch (tsunami) {
        case 0:
            return "No";
        case 1:
            return "Yes";
        default:
            return "Unknown";
        }
    }
}