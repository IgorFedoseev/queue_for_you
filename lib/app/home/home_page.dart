import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/contacts/contacts_page.dart';
import 'package:new_time_tracker_course/app/home/cupertino_home_scaffold.dart';
import 'package:new_time_tracker_course/app/home/entries/entries_page.dart';
import 'package:new_time_tracker_course/app/home/jobs/jobs_page.dart';
import 'package:new_time_tracker_course/app/home/profile/profile_page.dart';
import 'package:new_time_tracker_course/app/home/schedule/schedule_page.dart';
import 'package:new_time_tracker_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  Map<TabItem, WidgetBuilder> get widgetBuilder {
    return {
      TabItem.profile: (_) => const ProfilePage(),
      TabItem.jobs: (_) => const JobsPage(),
      TabItem.schedule: (_) => const SchedulePage(),
      TabItem.entries: (_) => const EntriesPage(),
      TabItem.contacts: (_) => const ContactsPage(),
    };
  }

  void _select(TabItem tabItem){
    setState(() {
      if(_currentTab == tabItem) return;
      _currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilder: widgetBuilder,
    );
  }
}
