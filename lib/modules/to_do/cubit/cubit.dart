import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wazaaf/modules/to_do/archived_page.dart';
import 'package:wazaaf/modules/to_do/cubit/states.dart';
import 'package:wazaaf/modules/to_do/done_page.dart';
import 'package:wazaaf/modules/to_do/tasks_page.dart';
import 'package:wazaaf/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    Tasks(),
    Done(),
    Archived(),
  ];
  List<String>titles= [
    'Tasks',
    'Done',
    'Archived',
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  late Database database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState(index));
  }


  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate:(database,version) async{
        print('Database created');
        await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        );
        print('Table created');
      },
      onOpen: (database) {
        getFromDataBase(database);
      },).then((value){
        database = value;
        emit(AppCreateDataBaseState());
      });
    }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn)=> txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time","new")')
        .then((value){
      print('$value insertion successfully');
      emit(AppInsertDataBaseState());
      getFromDataBase(database);
    }).catchError((error){
      print('error when inserting new record ${error.toString()}');
    }));
  }

  void getFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element) {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
      isBottomSheetShown = isShow;
      fabIcon = icon;
      emit(AppChangeBottomSheetState());
    }

  void updateData({
    required String status,
    required int id,
}) async {
      database.rawUpdate(
          'UPDATE tasks SET status = ? WHERE id = ?',
          ['$status',id],
      ).then((value){
        getFromDataBase(database);
        emit((AppUpdateDataBaseState()));
      });
  }


  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value){
      getFromDataBase(database);
      emit(AppDeleteDataBaseState());
    });
  }

  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark ;

  void changeAppMode(){
    isDark = !isDark;
    CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value){
      emit(AppChangeModeState());
    });
  }
}