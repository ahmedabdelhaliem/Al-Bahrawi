import 'package:al_bahrawi/app/app_prefs.dart';
import 'package:al_bahrawi/features/lawyer_attendance/cubit/lawyer_attendance_cubit.dart';
import 'package:al_bahrawi/features/lawyer_dashboard/cubit/lawyer_dashboard_cubit.dart';
import 'package:al_bahrawi/features/on_boarding/cubit/on_boarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Chat Imports
import 'package:al_bahrawi/features/chat/data/data_source/chat_firebase_service.dart';
import 'package:al_bahrawi/features/chat/data/data_source/chat_api_data_source.dart';
import 'package:al_bahrawi/features/chat/domain/repo/chat_repo.dart';
import 'package:al_bahrawi/features/chat/data/repo_impl/chat_repo_impl.dart';
import 'package:al_bahrawi/features/chat/presentation/cubit/chat_inbox_cubit.dart';
import 'package:al_bahrawi/features/chat/presentation/cubit/chat_cubit.dart';


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
  instance.registerFactory<LawyerDashboardCubit>(() => LawyerDashboardCubit());
  instance.registerFactory<LawyerAttendanceCubit>(() => LawyerAttendanceCubit());

  // Chat Registrations
  instance.registerLazySingleton<ChatFirebaseService>(() => ChatFirebaseService());
  instance.registerLazySingleton<ChatApiDataSource>(() => ChatApiDataSourceImpl());
  instance.registerLazySingleton<ChatRepo>(() => ChatRepoImpl(instance<ChatApiDataSource>(), instance<ChatFirebaseService>()));
  instance.registerFactory<ChatInboxCubit>(() => ChatInboxCubit(instance<ChatRepo>()));
  instance.registerFactory<ChatCubit>(() => ChatCubit(instance<ChatRepo>(), instance<AppPreferences>()));
}
