// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/layout/news_app/cubit/states.dart';
import 'package:news/modules/business/business_screen.dart';
import 'package:news/modules/science/science_screen.dart';
import 'package:news/modules/sports/sports_screen.dart';
import 'package:news/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports_basketball),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
  ];

  List<Widget> screenWidgets = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    getApi(listCategory[index]);
    emit(NewsBottomNavBarState());
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];

  Map<int, String> listCategory = {
    0: 'business',
    1: 'sports',
    2: 'science',
  };

  bool refresh = true;

  void getApi(category) {
    emit(NewsLoadingState());
    DioHelper.getData(url: '/v2/top-headlines', query: {
      'country': 'eg',
      'category': category,
      'apiKey': '94b33031c31c4722a0b1c911e65a9d09',
    }).then((value) {
      if (category == 'business' && business.isEmpty) {
        business = value.data['articles'];
        refresh = true;
      } else if (category == 'sports' && sports.isEmpty) {
        sports = value.data['articles'];
        refresh = true;
      } else if (category == 'science' && science.isEmpty) {
        science = value.data['articles'];
        refresh = true;
      }
      if (refresh) {
        emit(NewsSuccessState());
        refresh = false;
      }
    }).catchError((err) {
      print(err.toString());
      emit(NewsErrorState(err.toString()));
    });
  }

  void searchApi(value) {
    emit(NewsSearchLoadingState());
    DioHelper.getData(url: '/v2/everything', query: {
      'q': '$value',
      'apiKey': '94b33031c31c4722a0b1c911e65a9d09',
    }).then((value) {
      search = value.data['articles'];
      emit(NewsSearchSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(NewsSearchErrorState(err.toString()));
    });
  }
}
