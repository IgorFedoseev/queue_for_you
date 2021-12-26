import 'package:flutter/material.dart';
import 'package:new_time_tracker_course/app/home/jobs/empty_content.dart';

typedef JobsItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class JobsListItemsBuilder<T> extends StatelessWidget {
  const JobsListItemsBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final JobsItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items != null && items.isNotEmpty) {
        return _buildList(items);
      } else {
        return const EmptyContent();
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        title: 'Что-то пошло не так',
        message: 'Не удалось загрузить данные',
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 0.3,
        thickness: 1,
      ),
      itemCount: items.length + 2,
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
