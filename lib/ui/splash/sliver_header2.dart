import 'package:flutter/material.dart';

class SliverHeader2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            title: Text('Title'),
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network('https://i.imgur.com/2pQ5qum.jpg', fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: List.generate(50, (index) {
                return Container(
                  height: 72,
                  color: Colors.blue[200],
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(8),
                  child: Text('Item $index'),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
