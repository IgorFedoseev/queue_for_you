import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold(
      {Key? key,
      required this.currentTab,
      required this.onSelectTab,
      required this.widgetBuilder})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilder;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        iconSize: 35.0,
        currentIndex: 1,
        inactiveColor: Colors.white,
        activeColor: Colors.tealAccent,
        backgroundColor: const Color.fromRGBO(3, 37, 65, 1),
        items: [
          _buildItem(TabItem.profile),
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.schedule),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.contacts)
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        final builder = widgetBuilder[item] ?? () => const Center(
          child: CircularProgressIndicator(),
        );
        return CupertinoTabView(
          builder: (context) => builder(context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    //final colorBottomTab =
    // currentTab == tabItem ? Colors.tealAccent : Colors.blueGrey[50];
    return BottomNavigationBarItem(
      icon: Icon(
        itemData?.icon,
        //color: colorBottomTab,
      ),
      label: itemData?.label,
    );
  }
}
