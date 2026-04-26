import 'package:base_project/app/app_prefs.dart';
import 'package:base_project/featuers/map_tracking/data/services/location_service.dart';
import 'package:base_project/featuers/map_tracking/presentation/cubit/map_tracking_cubit.dart';
import 'package:base_project/featuers/on_boarding/cubit/on_boarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


final instance = GetIt.instance;

Future<void> initAppModule() async {
  instance.allowReassignment = true;

  // shared prefs
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // internet connection checker
  instance.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance());

  // app preferences
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance<SharedPreferences>()));

  // Singleton Cubits
  instance.registerLazySingleton<OnBoardingCubit>(() => OnBoardingCubit());

  // Location Service
  instance.registerLazySingleton<LocationService>(() => LocationService());

  // Map Tracking Cubit
  instance.registerFactory<MapTrackingCubit>(() => MapTrackingCubit(instance<LocationService>()));
}
