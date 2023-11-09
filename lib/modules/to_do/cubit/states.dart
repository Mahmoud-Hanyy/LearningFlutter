
abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {
  final int index;
  AppChangeBottomNavBarState(this.index);
}

class AppCreateDataBaseState extends AppStates {}

class AppInsertDataBaseState extends AppStates {}

class AppGetDataBaseState extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}

class AppUpdateDataBaseState extends AppStates {}

class AppDeleteDataBaseState extends AppStates {}

class AppChangeModeState extends AppStates {}