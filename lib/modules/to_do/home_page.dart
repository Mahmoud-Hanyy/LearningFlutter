import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wazaaf/modules/to_do/cubit/cubit.dart';
import 'package:wazaaf/modules/to_do/cubit/states.dart';

class ToDoHome extends StatefulWidget {

  @override
  State<ToDoHome> createState() => _HomeState();
}

class _HomeState extends State<ToDoHome> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context , AppStates state){
          if(state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context , AppStates state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),),
            body: cubit.newTasks.isEmpty? const Center(child: CircularProgressIndicator()):cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                  }
                }else{
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0)
                        ,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Task Title',
                                  prefixIcon: Icon(Icons.title),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  labelText: 'Task Time',
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text = value!.format(context).toString();
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  labelText: 'Task Date',
                                  prefixIcon: Icon(Icons.calendar_month_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2023-12-22'),
                                  ).then((value) {
                                    dateController.text = DateFormat.yMMMd().format(value!);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    Navigator.pop(context);
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

