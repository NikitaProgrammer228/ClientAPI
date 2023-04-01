import 'package:conduitflutter/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'app_enviroment.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton(() => AuthCubit(sl()));
  sl.registerLazySingleton(() => Dio(BaseOptions(
        sendTimeout: 3000,
        connectTimeout: 3000,
        baseUrl: '${AppEnv.protocol}${AppEnv.ip}',
        
      )));
}
