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
    TabItem.profile: TabItemData(label: 'Профиль', icon: Icons.person),
    TabItem.jobs: TabItemData(label: 'Услуги', icon: Icons.business_center),
    TabItem.schedule: TabItemData(label: 'График', icon: Icons.more_time),
    TabItem.entries: TabItemData(label: 'Записи', icon: Icons.view_headline),
    TabItem.contacts: TabItemData(label: 'Контакты', icon: Icons.people_sharp),
  };
}