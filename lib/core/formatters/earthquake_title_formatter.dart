class EarthquakeTitleFormatter {
  static String getSimplifiedTitle(String titleWithoutFormat, String place) {
    String formattedTitle = "";

    if (titleWithoutFormat.contains(" of ")) {
      formattedTitle = titleWithoutFormat.split(" of ").last.trim();
    } else if (titleWithoutFormat.contains(" - ")) {
      var titleParts = titleWithoutFormat.split(" - ");
      formattedTitle = titleParts.isNotEmpty && titleParts.last.isNotEmpty 
        ? titleParts.last.trim()
        : "Unknown";
    } else {
      formattedTitle = place;
    }
  
    return formattedTitle.isNotEmpty ? formattedTitle : "Unknown";
  }
}
