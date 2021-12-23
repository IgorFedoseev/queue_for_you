import 'package:new_time_tracker_course/app/home/models/schedule.dart';
import 'package:new_time_tracker_course/app/home/models/job.dart';
import 'package:new_time_tracker_course/services/api_path.dart';
import 'package:new_time_tracker_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> setSchedule(Schedule schedule);
  Stream<List<Schedule>> scheduleStream();
  Future<void> deleteSchedule(Schedule schedule);
  // Stream<Job> jobStream({required String jobId});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  // : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) => _service.deleteData(
        path: APIPath.job(uid, job.id),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream<Job>(
        path: APIPath.jobs(uid),
        builder: (data, documentID) => Job.fromMap(data, documentID),
      );

  @override
  Future<void> setSchedule(Schedule schedule) => _service.setData(
        path: APIPath.schedule(uid, schedule.id),
        data: schedule.toMap(),
      );

  @override
  Stream<List<Schedule>> scheduleStream() =>
      _service.collectionStream<Schedule>(
        path: APIPath.schedules(uid),
        builder: (data, documentID) => Schedule.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.start.compareTo(rhs.start),
      );

  @override
  Future<void> deleteSchedule(Schedule schedule) => _service.deleteData(
        path: APIPath.schedule(uid, schedule.id),
      );
}

// @override
// Stream<Job> jobStream({required String jobId}) => _service.documentStream(
//   path: APIPath.job(uid, jobId),
//   builder: (data, documentId) => Job.fromMap(data, documentId),
// );

// @override
// Future<void> deleteJob(Job job) async {
//   // delete where entry.jobId == job.jobId
//   final allEntries = await entriesStream(job: job).first;
//   for (Entry entry in allEntries) {
//     if (entry.jobId == job.id) {
//       await deleteEntry(entry);
//     }
//   }
//   // delete job
//   await _service.deleteData(path: APIPath.job(uid, job.id));
// }
