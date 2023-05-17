import 'package:todo_app/data/datasource/local_data_source.dart';
import 'package:todo_app/data/db/model/task.dart';
import 'package:todo_app/data/repo/repository.dart';

class RepositoryImpl extends Repository{
  final LocalDataSource localDataSource;

  RepositoryImpl(this.localDataSource);

  @override
  Future<TaskEntity> createOrUpdate(TaskEntity taskEntity) {
    return localDataSource.createOrUpdate(taskEntity);
  }

  @override
  Future<void> delete(TaskEntity task) {
    return localDataSource.delete(task);
  }

  @override
  Future<void> deleteAll() {
    return localDataSource.deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    return localDataSource.deleteById(id);
  }

  @override
  Future<TaskEntity> findById(id) {
   return localDataSource.findById(id);
  }

  @override
  Future<List<TaskEntity>> getAllTask({String searchKeyword = ''}) {
    return localDataSource.getAllTask();
  }


}