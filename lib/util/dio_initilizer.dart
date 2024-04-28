import 'package:dio/dio.dart';
import 'package:spordee_messaging_app/util/dotenv.dart';

class DioInit {
  DioInit._internal();
  static final DioInit _instance = DioInit._internal();
  factory DioInit() => _instance;
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
    ),
  );

  Dio get dioInit => _dio;
}
