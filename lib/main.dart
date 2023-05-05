import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/db/model/task.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);

  runApp(const MyApp());
}

const primaryColor = Color(0xff794CFF);
const primaryContainerColor = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold))),
        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: secondaryTextColor),
            iconColor: secondaryTextColor),
        colorScheme: const ColorScheme.light(
            primary: primaryColor,
            primaryContainer: primaryContainerColor,
            background: Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            onPrimary: Colors.white,
            onBackground: secondaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white),
      ),
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditTaskScreen()));
          },
          label: Row(
            children: const [
              Text('Add New Task'),
              SizedBox(
                width: 4.0,
              ),
              Icon(CupertinoIcons.add_circled_solid)
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 122,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do list',
                          style: themeData.textTheme.titleLarge
                              ?.apply(color: themeData.colorScheme.onPrimary),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onPrimary,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 45.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19.0),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(1))
                          ]),
                      child: const TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.search),
                            label: Text('Search tasks...'),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 100.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: themeData.textTheme.titleLarge
                                  ?.apply(fontSizeFactor: 0.8),
                            ),
                            Container(
                              width: 70,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(1.5)),
                            )
                          ],
                        ),
                        MaterialButton(
                          color: const Color(0xffEAEFF5),
                          elevation: 0,
                          textColor: secondaryTextColor,
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Text('Delete All'),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(CupertinoIcons.delete)
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: ValueListenableBuilder<Box<TaskEntity>>(
                        valueListenable: box.listenable(),
                        builder: (context, values, child) {
                          return ListView.builder(
                              itemCount: values.values.length,
                              itemBuilder: (context, index) {
                                final TaskEntity taskEntity =
                                    box.values.toList()[index];
                                return TaskItem(task: taskEntity);
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        margin: const EdgeInsets.only(top: 8.0),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: themeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            TodoCheckBox(isChecked: widget.task.isCompleted),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 20.0,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = TaskEntity();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
              box.add(task);
            }
            Navigator.of(context).pop();
          },
          label: const Text('Save Changes')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration:
                const InputDecoration(label: Text('Add a task for today...')),
          )
        ],
      ),
    );
  }
}

class TodoCheckBox extends StatelessWidget {
  final bool isChecked;

  const TodoCheckBox({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: !isChecked
            ? Border.all(
                color: secondaryTextColor,
              )
            : null,
        color: isChecked ? primaryColor : null,
      ),
      child: isChecked
          ? Icon(
              CupertinoIcons.check_mark,
              size: 18.0,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
