import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazaaf/components/components.dart';
import 'package:wazaaf/modules/to_do/cubit/cubit.dart';
import 'package:wazaaf/modules/to_do/cubit/states.dart';

class Archived extends StatefulWidget {
  const Archived({super.key});

  @override
  State<Archived> createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          var tasks = AppCubit.get(context).archivedTasks;
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
