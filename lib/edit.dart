import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/db/model/task.dart';
import 'package:todo_app/main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity taskEntity;

  const EditTaskScreen({super.key, required this.taskEntity});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.taskEntity.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);


    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0.0,
        title: const Text(
          'Edit task',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.taskEntity.name = _controller.text;
          widget.taskEntity.priority = widget.taskEntity.priority;
          if (widget.taskEntity.isInBox) {
            widget.taskEntity.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(widget.taskEntity);
          }
          Navigator.of(context).pop();
        },
        icon: const Icon(CupertinoIcons.check_mark),
        label: const Text(
          'Save Changes',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 1,
                    child: PriorityRadioButton(
                      onTap: () {
                        setState(() {
                          widget.taskEntity.priority = Priority.high;
                        });
                      },
                      color: highPriority,
                      label: 'High',
                      isChecked: widget.taskEntity.priority == Priority.high,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    flex: 1,
                    child: PriorityRadioButton(
                      onTap: () {
                        setState(() {
                          widget.taskEntity.priority = Priority.normal;
                        });
                      },
                      color: normalPriority,
                      label: 'Medium',
                      isChecked: widget.taskEntity.priority == Priority.normal,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Flexible(
                    flex: 1,
                    child: PriorityRadioButton(
                      onTap: () {
                        setState(() {
                          widget.taskEntity.priority = Priority.low;
                        });
                      },
                      color: lowPriority,
                      label: 'Low',
                      isChecked: widget.taskEntity.priority == Priority.low,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                label: Text('Add a task for today...'),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityRadioButton extends StatelessWidget {
  final Color color;
  final String label;
  final bool isChecked;
  final GestureTapCallback onTap;

  const PriorityRadioButton({super.key,
    required this.color,
    required this.label,
    required this.isChecked,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 0,
              child: TodoRadioButton(
                isChecked: isChecked,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoRadioButton extends StatelessWidget {
  final bool isChecked;
  final Color color;

  const TodoRadioButton(
      {super.key, required this.isChecked, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: 16.0,
      height: 16.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: color,
      ),
      child: isChecked
          ? Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: themeData.colorScheme.surface),
        ),
      )
          : null,
    );
  }
}
