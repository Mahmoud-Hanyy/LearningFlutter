import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wazaaf/modules/counter/cubit/cubit.dart';
import 'package:wazaaf/modules/counter/cubit/states.dart';

class CounterScreen extends StatelessWidget {
  @override
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
        child: BlocConsumer<CounterCubit,CounterStates>(
          listener: (context, state) {},
          builder:  (context,state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Center(child: Text('Counter')),
                backgroundColor: Colors.blue,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            CounterCubit.get(context).minus();
                          },
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 30.0),
                        Text(
                          '${CounterCubit.get(context).counter}',
                          style: const TextStyle(
                            fontSize: 48.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 30.0),
                        FloatingActionButton(
                          onPressed: () {
                            CounterCubit.get(context).plus();
                          },
                          backgroundColor: Colors.purple,
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}
