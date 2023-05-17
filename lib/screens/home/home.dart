import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/db/model/task.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/edit/edit.dart';
import 'package:todo_app/widgets.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<void> _showAlert(void Function() onYesPressed) async {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: const Text("Delete All Tasks"),
          content: const Text("Are you sure you want to delete all tasks?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                MaterialButton(
                  onPressed: () {
                    onYesPressed();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes!"),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');
  bool _isFocused = false;


  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);

    return GestureDetector(
      onTap: (){
        if(_isFocused){
          FocusScope.of(context).unfocus();
          setState(() {
            _isFocused = false;
          });
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                  taskEntity: TaskEntity(),
                ),
              ),
            );
          },
          icon: const Icon(
            CupertinoIcons.add_circled_solid,
          ),
          label: const Text('Add New Task'),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: SafeArea(
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
                        height: 42.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19.0),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(1),
                            )
                          ],
                        ),
                        child: TextField(
                          onTap: (){
                            setState(() {
                              _isFocused = true;
                            });
                          },
                          onChanged: (value) {
                            searchKeywordNotifier.value = _controller.text;
                          },
                          controller: _controller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.search),
                            label: Text(
                              'Search tasks...',
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                          ],
                        ),
                        MaterialButton(
                          color: const Color(0xffEAEFF5),
                          elevation: 0,
                          textColor: secondaryTextColor,
                          onPressed: () {
                            if (box.values.isNotEmpty) {
                              _showAlert(() {
                                box.clear();
                              });
                            }
                          },
                          child: Row(
                            children: const [
                              Text(
                                'Delete All',
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                CupertinoIcons.delete,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ValueListenableBuilder<String>(
                        valueListenable: searchKeywordNotifier,
                        builder: (context, value, child){
                          return ValueListenableBuilder<Box<TaskEntity>>(
                            valueListenable: box.listenable(),
                            builder: (context, values, child) {
                              final List<TaskEntity> items;
                              if (_controller.text.isEmpty) {
                                items = box.values.toList();
                              } else {
                                items = box.values
                                    .where((element) =>
                                    element.name.contains(_controller.text))
                                    .toList();
                              }
                              return Center(
                                child: items.isNotEmpty
                                    ? ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final TaskEntity taskEntity = items[index];
                                    return TaskItem(task: taskEntity);
                                  },
                                )
                                    : const Text(
                                  "You don't have any task...",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            },
                          );
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
    final Color priorityColor;

    switch (widget.task.priority) {
      case Priority.high:
        priorityColor = highPriority;
        break;

      case Priority.low:
        priorityColor = lowPriority;
        break;
      case Priority.normal:
        priorityColor = normalPriority;
        break;
    }
    return InkWell(
      onTap: () {
        setState(
              () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(taskEntity: widget.task),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12.0),
        margin: const EdgeInsets.only(top: 8.0),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: themeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            TodoCheckBox(
              isChecked: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
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
                      : null,
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              width: 6.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
                color: priorityColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}