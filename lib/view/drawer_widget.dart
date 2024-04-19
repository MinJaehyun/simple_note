import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            title: const Text('Simple note', style: TextStyle(fontSize: 25)),
            onTap: () => Navigator.pop(context),
            trailing: Icon(Icons.close_outlined),
          ),
          SizedBox(height: 50),
          ListTile(
            title: const Text('모든 메모'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('달력'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('메모 임시 보관함 - 추후 구현'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('휴지통'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('즐겨 찾기 - 추후 구현'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('카테고리 설정'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('메모장 디자인 - 추후 구현'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('동기화 및 백업'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
          SizedBox(height: 15),
          ListTile(
            title: const Text('설정 - 추후 구현'),
            onTap: () {},
            leading: Icon(Icons.memory_sharp),
          ),
        ],
      ),
    );
  }
}

// todo: 아이콘 추후 기능에 맞게 설정하기