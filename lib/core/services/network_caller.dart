import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../models/response_data.dart';
import '../utils/logging/logger.dart';

class NetworkCaller {
  final int timeoutDuration = 10;

  Future<ResponseData> getRequest(
    String url, {
    String? token,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    Uri uri = Uri.parse(url);
    if (queryParams != null) {
      uri = uri.replace(
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await get(
        uri,
        headers: requestHeaders,
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(body ?? {}),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await put(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(body ?? {}),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(
    String url, {
    String? token,
    Map<String, String>? headers,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await delete(
        Uri.parse(url),
        headers: requestHeaders,
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> multipartRequest(
    String url, {
    Map<String, String>? fields,
    Map<String, String>? headers,
    List<http.MultipartFile>? files,
    String? token,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> requestHeaders = {
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(requestHeaders);
      if (fields != null) request.fields.addAll(fields);
      if (files != null) request.files.addAll(files);

      final streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutDuration),
      );
      final response = await Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  ResponseData _handleResponse(Response response) {
    AppLoggerHelper.debug('Status: ${response.statusCode}');
    AppLoggerHelper.debug('Body: ${response.body}');
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      bool success = decoded is Map && decoded['success'] == true;
      return ResponseData(
        isSuccess: success,
        statusCode: response.statusCode,
        responseData: decoded,
        errorMessage: success
            ? ''
            : decoded['message'] ?? 'Unknown error occurred',
      );
    } else if (response.statusCode == 400) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decoded,
        errorMessage: _extractErrorMessages(decoded['errorSources']),
      );
    } else if (response.statusCode == 401) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        responseData: decoded,
        errorMessage: 'Unauthorized request',
      );
    } else if (response.statusCode == 403) {
      return ResponseData(
        isSuccess: false,
        statusCode: 403,
        responseData: decoded,
        errorMessage: 'Forbidden request',
      );
    } else if (response.statusCode == 500) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: decoded['message'] ?? 'Server error occurred',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decoded,
        errorMessage: decoded['message'] ?? 'Unknown error occurred',
      );
    }
  }

  String _extractErrorMessages(dynamic errorSources) {
    if (errorSources is List)
      return errorSources
          .map((e) => e['message'] ?? 'Unknown error')
          .join(', ');
    return 'Validation error';
  }

  ResponseData _handleError(dynamic error) {
    AppLoggerHelper.error('Request error', error);
    if (error is TimeoutException)
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: '',
        errorMessage: 'Request timeout',
      );
    return ResponseData(
      isSuccess: false,
      statusCode: 500,
      responseData: '',
      errorMessage: error.toString(),
    );
  }
}
