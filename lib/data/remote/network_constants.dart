// ignore_for_file: constant_identifier_names

class NetworkConstants {
  static const BASE_URL = "https://earthquake.usgs.gov/fdsnws/event/1/query";
  
  static const EARTHQUAKE_LIST_PATH = BASE_URL;

  static const EARTHQUAKE_DETAIL_PATH = "$BASE_URL/.../"; //TODO: Implement detail

  static String getEarthquakeDetailPath(String earthquakeId) {
    return "${NetworkConstants.EARTHQUAKE_DETAIL_PATH}$earthquakeId.json";
  }
}

// https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startTime)&endtime=\(endTime)&limit=\(selectedPageSize)&offset=\(actualOffset)