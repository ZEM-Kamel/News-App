// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_this, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news/layout/news_app/cubit/cubit.dart';
import 'package:news/shared/bloc_observer.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/network/local/cache_helper.dart';
import 'package:news/shared/network/remote/dio_helper.dart';
import 'package:news/shared/styles/themes.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'layout/news_app/news_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = false;
  try{
    isDark = CacheHelper.getData();
  } catch (_){
    await CacheHelper.putData(isDark: isDark);
  }

  runApp(News(isDark));
}

class News extends StatelessWidget {
  final bool isDark;

  News(this.isDark);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..switchMood(cached: this.isDark),
        ),
        BlocProvider(
          create: (BuildContext context) => NewsCubit()..getApi('business'),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme:darkTheme,
            themeMode: CacheHelper.getData() ? ThemeMode.dark : ThemeMode.light,
            home: SplashScreenView(
              navigateRoute: NewsLayout(),
              duration: 3000,
              imageSize: 400,
              imageSrc: "assets/images/news_splash.png",
            )
          );
        },
      ),
    );
  }
}
