import 'package:flutter/material.dart';

enum TabItem {
  profile,
  jobs,
  schedule,
  entries,
  contacts
}

class TabItemData {
  const TabItemData({required this.label, required this.icon});
  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.profile: TabItemData(label: 'ПРОФИЛЬ', icon: Icons.person),
    TabItem.jobs: TabItemData(label: 'УСЛУГИ', icon: Icons.business_center),
    TabItem.schedule: TabItemData(label: 'ГРАФИК', icon: Icons.more_time),
    TabItem.entries: TabItemData(label: 'ЗАПИСИ', icon: Icons.view_headline),
    TabItem.contacts: TabItemData(label: 'КОНТАКТЫ', icon: Icons.people_sharp),
  };
}