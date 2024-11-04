class EarthquakeCoordsFormatter {
  static String getFormattedCoords(List<double>? actualCoords) {
        double longitude = actualCoords?[0] ?? 0;
        double latitude = actualCoords?[1] ?? 0;
        String longitudeString;
        String latitudeString;
        
        if (longitude < 0) {
            longitudeString = "${longitude.abs().toString()}W";
        } else {
            longitudeString = "${longitude.toString()}E";
        }
        
        if (latitude < 0) {
            latitudeString = "${latitude.abs().toString()}S";
        } else {
            latitudeString = "${latitude.toString()}N";
        }
        
        return "$longitudeString, $latitudeString";
    }
}