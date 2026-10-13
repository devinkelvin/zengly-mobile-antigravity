import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';

class _MockFriend {
  final String name;
  final String accountNumber;
  final String? photo;
  final Color avatarColor;

  const _MockFriend({
    required this.name,
    required this.accountNumber,
    this.photo,
    this.avatarColor = Colors.blue,
  });
}

class SelectSplitFriendsSheet extends StatefulWidget {
  const SelectSplitFriendsSheet({super.key});

  @override
  State<SelectSplitFriendsSheet> createState() =>
      _SelectSplitFriendsSheetState();
}

class _SelectSplitFriendsSheetState extends State<SelectSplitFriendsSheet> {
  final _searchController = TextEditingController();
  String _query = "";

  static const _you = _MockFriend(
    name: "You",
    accountNumber: "028764637",
    avatarColor: Colors.blue,
  );

  static final _friends = [
    _MockFriend(
      name: "Amara Williams",
      accountNumber: "028764637",
      photo: AppImages.splitImage,
    ),
    const _MockFriend(
      name: "Alice Ferguson",
      accountNumber: "028764637",
      avatarColor: Colors.red,
    ),
    const _MockFriend(
      name: "Alia Sandra",
      accountNumber: "028764637",
      avatarColor: Colors.green,
    ),
    _MockFriend(
      name: "Sandra Kristella",
      accountNumber: "028764637",
      photo: AppImages.splitImage,
    ),
  ];

  final Set<String> _selected = {_you.name};

  List<_MockFriend> get _filteredFriends {
    if (_query.isEmpty) return _friends;
    final query = _query.toLowerCase();
    return _friends.where((f) => f.name.toLowerCase().contains(query)).toList();
  }

  void _toggle(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
      } else {
        _selected.add(name);
      }
    });
  }

  Widget _avatar(_MockFriend friend, {double size = 40}) {
    if (friend.photo != null) {
      return ClipOval(
        child: Image.asset(
          friend.photo!,
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: friend.avatarColor,
      ),
      child: Text(
        friend.name[0],
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFriends = [
      _you,
      ..._friends.where((f) => _selected.contains(f.name)),
    ];

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(_selected.length),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value),
                  style: GoogleFonts.inter(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Split with",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedFriends.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, i) {
                final friend = selectedFriends[i];
                final isYou = friend.name == _you.name;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _avatar(friend, size: 28),
                      SizedBox(width: 8),
                      Text(
                        isYou ? "${friend.name} (You)" : friend.name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _toggle(friend.name),
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.25),
                          ),
                          child: Icon(Icons.close, size: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filteredFriends.length + 1,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, i) {
                final friend = i == 0 ? _you : _filteredFriends[i - 1];
                final isAdded = _selected.contains(friend.name);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _avatar(friend),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.name == _you.name ? "You" : friend.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              friend.accountNumber,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.scrim,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (friend.name != _you.name)
                        GestureDetector(
                          onTap: () => _toggle(friend.name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isAdded ? "Added" : "Add",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () => context.pop(_selected.length),
              actionText: "Add friends",
            ),
          ),
        ],
      ),
    );
  }
}
