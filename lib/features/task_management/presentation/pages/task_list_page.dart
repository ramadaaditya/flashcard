import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_bloc.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_state.dart';
import 'package:go_router/go_router.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(
                child: Text('No tasks yet. Create one!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return _TaskCard(task: task);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildPriorityIndicator(),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.status == TaskStatus.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description != null
            ? Text(task.description!, maxLines: 2, overflow: TextOverflow.ellipsis)
            : null,
        trailing: _buildStatusChip(context),
        onTap: () => context.push('/tasks/${task.id}'),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    final color = switch (task.priority) {
      TaskPriority.urgent => Colors.red,
      TaskPriority.high => Colors.orange,
      TaskPriority.medium => Colors.blue,
      TaskPriority.low => Colors.grey,
    };
    return CircleAvatar(
      radius: 6,
      backgroundColor: color,
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final label = switch (task.status) {
      TaskStatus.todo => 'To Do',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.done => 'Done',
    };
    return Chip(label: Text(label, style: const TextStyle(fontSize: 12)));
  }
}
