import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_app/shared/components/compontents.dart';
import 'package:first_app/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            backgroundColor: const Color(0xFFB3B7EE),
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: const Color(0xFF5559BA),
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                    titleController.clear();
                    timeController.clear();
                    dateController.clear();

                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(
                                  20.0,
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormfeild(
                                          labeledColor: const Color(0xFF5559BA),
                                          borderColor: const Color(0xFF5559BA),
                                          controller: titleController,
                                          type: TextInputType.text,
                                          validate: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'title must not be empty';
                                            }
                                            return null;
                                          },
                                          label: 'Task Title',
                                         prefix: Icons.title ,),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      defaultFormfeild(
                                          labeledColor: const Color(0xFF5559BA),
                                          borderColor: const Color(0xFF5559BA),
                                          controller: timeController,
                                          type: TextInputType.datetime,
                                          validate: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'time must not be empty';
                                            }
                                            return null;
                                          },
                                          label: 'Task Time',
                                          prefix: Icons.watch_later_outlined,
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((value) {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString();
                                              print(value?.format(context));
                                            });
                                          }),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      defaultFormfeild(
                                          labeledColor: const Color(0xFF5559BA),
                                          borderColor: const Color(0xFF5559BA),
                                          controller: dateController,
                                          type: TextInputType.datetime,
                                          validate: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'date must not be empty';
                                            }
                                            return null;
                                          },
                                          label: 'Task Date',
                                          prefix: Icons.calendar_today,
                                          onTap: () {
                                            showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        '2025-05-03'))
                                                .then((value) {
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value!);
                                              print(DateFormat.yMMMd()
                                                  .format(value!));
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20.0)
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              selectedItemColor: const Color(0xFF5559BA), // Color of the selected item
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived")
              ],
            ),
          );
        },
      ),
    );
  }
}
