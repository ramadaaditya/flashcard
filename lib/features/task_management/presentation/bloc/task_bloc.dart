import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/features/task_management/domain/entities/task.dart';
import 'package:flashcard/features/task_management/domain/usecases/create_task.dart';
import 'package:flashcard/features/task_management/domain/usecases/delete_task.dart';
import 'package:flashcard/features/task_management/domain/usecases/get_tasks.dart';
import 'package:flashcard/features/task_management/domain/usecases/update_task.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_event.dart';
import 'package:flashcard/features/task_management/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTask _createTask;
  final GetTasks _getTasks;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;

  TaskBloc({
    required CreateTask createTask,
    required GetTasks getTasks,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
  })  : _createTask = createTask,
        _getTasks = getTasks,
        _updateTask = updateTask,
        _deleteTask = deleteTask,
        super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<EditTask>(_onEditTask);
    on<RemoveTask>(_onRemoveTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final result =
        await _getTasks(GetTasksParams(filterByStatus: event.filterByStatus));
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(List<Task>.from(tasks))),
    );
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final result = await _createTask(event.task);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) {
        emit(const TaskOperationSuccess('Task created'));
        add(const LoadTasks());
      },
    );
  }

  Future<void> _onEditTask(EditTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final result = await _updateTask(event.task);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) {
        emit(const TaskOperationSuccess('Task updated'));
        add(const LoadTasks());
      },
    );
  }

  Future<void> _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final result = await _deleteTask(event.taskId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) {
        emit(const TaskOperationSuccess('Task deleted'));
        add(const LoadTasks());
      },
    );
  }
}
