import 'package:flutter/material.dart';
import 'task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task_data.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTile(
              longPressCallback: () {
                taskData.deleteTask(taskData.getTask[index]);
              },
              taskTitle: taskData.getTask[index].name,
              isChecked: taskData.getTask[index].isDone,
              checkboxCallback: (checkbox) {
                taskData.updateTask(taskData.getTask[index]);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
