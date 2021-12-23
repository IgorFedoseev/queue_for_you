class APIPath {
  static String job(String uid, String? jobID) => 'users/$uid/jobs/$jobID';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String schedule(String uid, String? scheduleID) =>
      'users/$uid/schedules/$scheduleID';
  static String schedules(String uid) => 'users/$uid/schedules/';
}
