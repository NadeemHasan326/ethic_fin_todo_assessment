import 'package:ethic_fin_todo_assessment/exports.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _collection =>
      firestore.collection(AppConstants.firestoreTasksCollection);

  @override
  Future<List<TaskModel>> getTasks() async {
    final snapshot =
        await _collection.get().timeout(AppDurations.firestoreTimeout);
    return snapshot.docs
        .map((doc) =>
            TaskModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  @override
  Future<void> createTask(TaskModel task) async {
    await _collection.doc(task.id).set(task.toFirestore()).timeout(AppDurations.firestoreTimeout);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _collection.doc(task.id).set(task.toFirestore()).timeout(AppDurations.firestoreTimeout);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _collection.doc(id).delete().timeout(AppDurations.firestoreTimeout);
  }
}
