import 'package:dio/dio.dart';
import 'package:payme_frontend/models/user.dart';
import 'package:payme_frontend/services/client.dart';

class AuthServices {
  Future<Map<String, String>> signup({required User user}) async {
    try {
      Response response = await Client.dio.post('/signup', data: user.toJson());
      return {'token': response.data["token"]};
    } on DioException catch (error) {
      print(error.response!.data["error"]["message"]);
      return {'error': error.response!.data["error"]["message"]};
    }
  }

  Future<Map<String, String>> signin({required User user}) async {
    try {
      // print(user.toJson());
      Response response = await Client.dio.post('/signin', data: user.toJson());
      return {'token': response.data["token"]};
      // print(token);
    } on DioException catch (error) {
      print(error.response!);
      return {'error': error.response!.data["error"]["message"]};
    }
  }
}
