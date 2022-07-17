abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsBottomNavBarState extends NewsStates {}

class NewsLoadingState extends NewsStates {}

class NewsSuccessState extends NewsStates {}

class NewsErrorState extends NewsStates
{
  final String error;

  NewsErrorState(this.error);
}

class NewsSearchLoadingState extends NewsStates {}

class NewsSearchSuccessState extends NewsStates {}

class NewsSearchErrorState extends NewsStates
{
  final String error;

  NewsSearchErrorState(this.error);
}

class SwitchMoodState extends NewsStates {}
