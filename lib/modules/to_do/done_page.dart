import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazaaf/components/components.dart';
import 'package:wazaaf/modules/to_do/cubit/cubit.dart';
import 'package:wazaaf/modules/to_do/cubit/states.dart';

class Done extends StatefulWidget {
  const Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          var tasks = AppCubit.get(context).doneTasks;
          return ListView.separated(
            itemBuilder: (context,index)=> buildTaskItem(tasks[index],context),
            separatorBuilder: (context,index)=>Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
            itemCount: tasks.length,
          );
        });
  }
}
