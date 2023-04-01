import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {


    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String dat=response.data['accessToken'].toString();
    super.onResponse(response, handler);
  }
}
