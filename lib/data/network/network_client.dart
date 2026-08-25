import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feature.dart';
import 'network_client_error.dart';

/// Mirrors Quake/NetworkClient/NetworkClient.swift (protocol) and
/// Quake/NetworkClient/URLSessionNetworkClient.swift (implementation).
abstract class NetworkClient {
  Future<ApiResponse> get(String url);
}

class HttpNetworkClient implements NetworkClient {
  final http.Client _client;

  HttpNetworkClient({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<ApiResponse> get(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      throw const BadUrlError();
    }

    final http.Response response;
    try {
      response = await _client.get(uri);
    } on Exception catch (e) {
      throw DecodingError(e);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw InvalidResponseError(statusCode: response.statusCode);
    }

    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse.fromJson(decoded);
    } catch (e) {
      throw DecodingError(e);
    }
  }
}
