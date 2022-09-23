import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/models/sidebar/menu_item.dart';
import 'package:uakino/utils/keyboard.dart';
import 'package:uakino/views/sidebar_view/sidebar_subitem_view.dart';

const Duration _kExpand = Duration(milliseconds: 400);

class SidebarItemView extends StatefulWidget {
  final MenuItem menuItem;
  final bool autofocus;
  final KeyEventResult Function(RawKeyEvent event, bool isExpanded)? onKey;

  const SidebarItemView({Key? key, required this.menuItem, this.autofocus = false, this.onKey})
      : super(key: key);

  @override
  State<SidebarItemView> createState() => _SidebarItemViewState();
}

class _SidebarItemViewState extends State<SidebarItemView> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  var _isFocused = false;
  var _isExpanded = false;

  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    final Widget submenu = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.menuItem.submenus.map((element) {
              return SidebarSubItemView(submenuItem: element);
            }).toList(growable: false),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : submenu,
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Focus(
          autofocus: widget.autofocus,
          onFocusChange: _setFocused,
          onKey: _onKey,
          child: Container(
            width: K.sidebarWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(widget.menuItem.localeTitle?.tr ?? widget.menuItem.title,
                style: TextStyle(
                  color: _isFocused ? Colors.orange.shade800 : Colors.white,
                  fontSize: _isFocused ? 20.0 : 18.0,
                )),
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    if (isSelect(event)) {
      _handleTap();
    }
    if (widget.onKey != null) {
      return widget.onKey!(event, _isExpanded);
    }
    return KeyEventResult.ignored;
  }

  void _setFocused(bool value) {
    setState(() {
      _isFocused = value;
    });
  }

  void _handleTap() {
    if (widget.menuItem.submenus.isEmpty) {
      logger.w("Open ${widget.menuItem.path}");
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          // Rebuild without widget.children.
          setState(() {});
        });
      }
    });
  }
}
