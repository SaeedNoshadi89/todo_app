import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/datasource/data_source.dart';
import 'package:todo_app/data/db/model/task.dart';

class LocalDataSource extends DataSource {
  final Box<TaskEntity> box;

  LocalDataSource(this.box);

  @override
  Future<TaskEntity> createOrUpdate(TaskEntity taskEntity) async {
    if (taskEntity.isInBox) {
      taskEntity.save();
    } else {
      taskEntity.id = await box.add(taskEntity);
    }
    return taskEntity;
  }

  @override
  Future<void> delete(TaskEntity task) {
   return box.delete(task.id);
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element == id);
  }

  @override
  Future<List<TaskEntity>> getAllTask({String searchKeyword = ''}) async {
    return box.values.toList();
  }
}
