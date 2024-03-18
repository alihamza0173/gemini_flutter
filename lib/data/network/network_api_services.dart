import 'package:dio/dio.dart';
import 'package:elders_ai_app/data/network/network_base_services.dart';

class NetworkApiService extends NetworkBaseService {
  final Dio _dio = Dio();
  @override
  Future getGetApiResponse(String url) {
    throw UnimplementedError();
  }

  @override
  Future getPostApiResponse(String url) {
    throw UnimplementedError();
  }
}
