import 'package:todo_app/data/datasource/data_source.dart';
import 'package:todo_app/data/db/model/task.dart';

abstract class Repository{
  Future<List<TaskEntity>> getAllTask({String searchKeyword});

  Future<TaskEntity> findById(dynamic id);

  Future<void> deleteAll();

  Future<void> delete(TaskEntity task);

  Future<void> deleteById(dynamic id);

  Future<TaskEntity> createOrUpdate(TaskEntity taskEntity);
}