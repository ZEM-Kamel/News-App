import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isDark = false;

  void switchMood({bool? cached}) {
    if (cached != null) {
      isDark = cached;
      emit(SwitchMoodState());
      return;
    }
    isDark = !isDark;
    CacheHelper.putData(isDark: isDark).then((value) {
      emit(SwitchMoodState());
    });
  }
}
