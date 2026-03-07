import 'package:equatable/equatable.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final TaskStatus? filterByStatus;

  const LoadTasks({this.filterByStatus});

  @override
  List<Object?> get props => [filterByStatus];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class EditTask extends TaskEvent {
  final Task task;

  const EditTask(this.task);

  @override
  List<Object?> get props => [task];
}

class RemoveTask extends TaskEvent {
  final String taskId;

  const RemoveTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class SearchTasksEvent extends TaskEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}
