import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BIM493 WEEK09_PART3')),
      body: Column(
        children: [
          Progress(),
          TaskList()
        ],
      ),
    );
  }
}

final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref){
  return TaskNotifier(tasks:[
    Task(id:1, label:"Load rocket with supplies"),
    Task(id:2, label:"Launch rocket"),
    Task(id:3, label:"Circle the home planet"),
    Task(id:4, label:"Head out to the first moon"),
    Task(id:5, label:"Launch moon lander #1"),
  ]);
});

class Task{
  final int id;
  final String label;
  final bool completed;

  Task({required this.id, required this.label, this.completed = false});

  Task copyWith({int? id, String? label, bool? completed}){
    return Task(
        id: id ?? this.id,
        label: label ?? this.label,
        completed: completed ?? this.completed
    );
  }

}

class TaskNotifier extends StateNotifier<List<Task>>{
  TaskNotifier({tasks}) : super(tasks);

  void add(Task task){
    state = [...state, task];
  }

  void toggle(int taskId){
    state = [
      for(final item in state)
        if(taskId == item.id)
          item.copyWith(completed: !item.completed)
        else
          item
    ];
  }

}


class TaskList extends ConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);

    return Column(
      children: tasks.map(
              (task) =>
              TaskItem(task: task)
      ).toList(),
    );

  }

}



class TaskItem extends ConsumerWidget {
  final Task task;
  const TaskItem({Key? key, required this.task}): super(key:key);


  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Row(
      children: [
        Checkbox(
          onChanged: (newValue) =>
              ref.read(tasksProvider.notifier).toggle(task.id),
          value: task.completed,
        ),
        Text(task.label),
      ],
    );
  }
}

class Progress extends ConsumerWidget{
  const Progress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);
    var numCompletedTasks = tasks.where((task){
      return task.completed == true;
    }).length;
    print("Percentage of tasks completed: "+ (numCompletedTasks/tasks.length*100).toString()+"%");
    return Column(
      children: [
        const Text("You are this far away from exploring the whole universe:"),
        LinearProgressIndicator(value: numCompletedTasks/tasks.length)
      ],
    );
  }
}