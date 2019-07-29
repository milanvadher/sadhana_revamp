// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum TabsStyle { iconsAndText, iconsOnly, textOnly }

class TabPage {
  const TabPage({this.content, this.icon, this.text});

  final IconData icon;
  final String text;
  final Widget content;
}

class ScrollableTabsDemo extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';
  final List<TabPage> pages;
  final TabsStyle tabsDemoStyle;
  final String title;
  final List<Widget> actions;
  const ScrollableTabsDemo({Key key, this.pages, this.tabsDemoStyle = TabsStyle.textOnly, this.title, this.actions}) : super(key: key);

  @override
  ScrollableTabsDemoState createState() => ScrollableTabsDemoState();
}

class ScrollableTabsDemoState extends State<ScrollableTabsDemo> with SingleTickerProviderStateMixin {
  TabController _controller;
  bool _customIndicator = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: widget.pages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Decoration getIndicator() {
    if (!_customIndicator) return const UnderlineTabIndicator();

    switch (widget.tabsDemoStyle) {
      case TabsStyle.iconsAndText:
        return ShapeDecoration(
          shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                side: BorderSide(
                  color: Colors.white24,
                  width: 2.0,
                ),
              ) +
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 4.0,
                ),
              ),
        );

      case TabsStyle.iconsOnly:
        return ShapeDecoration(
          shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.white24,
                  width: 2.0,
                ),
              ) +
              const CircleBorder(
                side: BorderSide(
                  color: Colors.transparent,
                  width: 4.0,
                ),
              ),
        );

      case TabsStyle.textOnly:
        return ShapeDecoration(
          shape: const StadiumBorder(
                side: BorderSide(
                  color: Colors.white24,
                  width: 2.0,
                ),
              ) +
              const StadiumBorder(
                side: BorderSide(
                  color: Colors.transparent,
                  width: 4.0,
                ),
              ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
        bottom: getTabBar(),
        //elevation: 0,
      ),
      body: TabBarView(
        controller: _controller,
        children: widget.pages.map<Widget>((TabPage page) {
          return page.content;
        }).toList(),
      ),
    );
  }

  Widget getTabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      indicator: UnderlineTabIndicator(),
      tabs: widget.pages.map<Tab>((TabPage page) {
        assert(widget.tabsDemoStyle != null);
        switch (widget.tabsDemoStyle) {
          case TabsStyle.iconsAndText:
            return Tab(text: page.text, icon: Icon(page.icon));
          case TabsStyle.iconsOnly:
            return Tab(icon: Icon(page.icon));
          case TabsStyle.textOnly:
            return Tab(
              text: page.text,
            );
        }
        return null;
      }).toList(),
    );
  }
}
