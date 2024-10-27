import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_app/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.purple,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () => function(),
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormfeild( {
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function()? suffixPressed,
  bool isClickable = true,
  Color borderColor = Colors.blue, // Default border color
  Color labeledColor = Colors.blue, // Default label color
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      onTap: onTap,
      enabled: isClickable,
      obscureText: isPassword,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labeledColor),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor), // Color when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor), // Color when enabled
        ),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        prefixIcon: Icon(prefix ,color: const Color(0xFF5559BA),),
      ),
    );


Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
        padding: EdgeInsets.only(top: 20.0 ,left: 10, right: 10 ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: EdgeInsets.all(10.0),

          child: Row(
            children: [
              CircleAvatar(
                radius: 26.0,
                child: Text(
                  '${model['time']}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style: const TextStyle(
                        color: Color(0xFF5559BA),
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${model['date']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              IconButton(
                  onPressed: (){
                    AppCubit.get(context).updateData(status: 'done', id: model['id']);
                  },
                  icon: const Icon(Icons.check_circle_outline , color: Color(0xFF5559BA),)
              ),
              IconButton(
                  onPressed: (){
                    AppCubit.get(context).updateData(status: 'archive', id: model['id']);
                  },
                  icon: const Icon(Icons.archive_outlined , color: Color(0xFF5559BA),)
              ),

            ],
          ),
        ),
      ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);

  },
);


Widget taskBuilder({
  required List<Map> tasks ,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (BuildContext context) => ListView.builder(
    itemBuilder: (context, index) =>
        buildTaskItem(tasks[index], context),
    itemCount: tasks.length,
  ),
  fallback: (BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          color: Colors.grey[50],
          size: 50,
        ),
        SizedBox(height: 20.0,),
        Text(
          'No Tasks Yet',
          style: TextStyle(
              color: Colors.grey[50],
              fontWeight: FontWeight.bold,
              fontSize: 20),
        )
      ],
    ),
  ),
);