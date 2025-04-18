import 'package:flutter/material.dart';
import 'navigate_form.dart'; // Ensure this file has FormScreen, SimpleScreen, DataPassScreen

void main() {
  runApp(SocialProfileApp());
}

class SocialProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Profile Page',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => ProfilePage(),
        '/form': (_) => const FormScreen(),
        '/simple': (_) => const SimpleScreen(),
        '/settings': (_) => SettingsPage(),
        '/about': (_) => AboutPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/data') {
          final arg = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (_) => DataPassScreen(initialText: arg ?? ''),
          );
        } else if (settings.name == '/editProfile') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (_) => EditProfileScreen(
              fullName: args?['fullName'] ?? '',
              bio: args?['bio'] ?? '',
              onSave: args?['onSave'],
            ),
          );
        }
        return null;
      },
    );
  }
}

/* ──────────────────────── PROFILE SCREEN ─────────────────────── */
class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _fullName = "Arnob Rizwan";
  String _bio = "Flutter Dev | Coffee Lover ☕️";
  Map<String, String> _additionalInfo = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _openEditProfile() {
    Navigator.pushNamed(
      context,
      '/editProfile',
      arguments: {
        'fullName': _fullName,
        'bio': _bio,
        'onSave': (Map<String, String> result) {
          setState(() {
            _fullName = result['fullName'] ?? _fullName;
            _bio = result['bio'] ?? _bio;
            _additionalInfo = result;
          });
        },
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') {
                Navigator.pushNamed(context, '/about');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'about', child: Text('About')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _openEditProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.blueAccent,
                  child: Center(
                    child: Icon(Icons.person_pin, size: 100, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                )
              ],
            ),
            SizedBox(height: 50),
            Text(_fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(_bio, style: TextStyle(color: Colors.grey[700])),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statColumn('120', 'Followers'),
                  _statColumn('180', 'Following'),
                  _statColumn('12', 'Posts'),
                ],
              ),
            ),
            if (_additionalInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _additionalInfo.entries
                          .where((e) => e.key != 'fullName' && e.key != 'bio')
                          .map((e) => Text('${e.key}: ${e.value}'))
                          .toList(),
                    ),
                  ),
                ),
              ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: 'Posts'),
                Tab(text: 'Followers'),
                Tab(text: 'About'),
              ],
            ),
            Container(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostsTab(),
                  _buildFollowersTab(),
                  _buildAboutTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(count, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => Container(
        color: Colors.grey[300],
        child: Center(child: Icon(Icons.image)),
      ),
    );
  }

  Widget _buildFollowersTab() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 10,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text('Follower ${index + 1}'),
      ),
    );
  }

  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('This is the about section. You can write about the user here.'),
        ],
      ),
    );
  }
}

/* ───────────── Placeholder: Edit Profile ───────────── */
class EditProfileScreen extends StatelessWidget {
  final String fullName;
  final String bio;
  final Function(Map<String, String>) onSave;

  const EditProfileScreen({
    Key? key,
    required this.fullName,
    required this.bio,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController(text: fullName);
    final bioCtrl = TextEditingController(text: bio);
    final ageCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    double rating = 3;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _input(nameCtrl, 'Full Name'),
            _input(bioCtrl, 'Bio'),
            _input(ageCtrl, 'Age', TextInputType.number),
            _input(cityCtrl, 'City'),
            _input(emailCtrl, 'Email'),
            SizedBox(height: 10),
            Text('Rating: ${rating.toInt()}'),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.toInt().toString(),
              onChanged: (value) => rating = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final Map<String, String> result = {
                  'fullName': nameCtrl.text,
                  'bio': bioCtrl.text,
                  'age': ageCtrl.text,
                  'city': cityCtrl.text,
                  'email': emailCtrl.text,
                  'rating': rating.toInt().toString(),
                };
                onSave(result);
                Navigator.pop(context);
              },
              child: Text('Save & Return'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label, [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(border: OutlineInputBorder(), labelText: label),
      ),
    );
  }
}

/* ───────────── Settings & About Screens ───────────── */
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkMode = false;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListTile(
        title: Text('Dark Mode'),
        trailing: Switch(
          value: darkMode,
          onChanged: (value) {},
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is a simple about page.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('← Back'),
            ),
          ],
        ),
      ),
    );
  }
}