 import 'package:flutter/material.dart';

void main() => runApp(const NavFormDemoApp());

class NavFormDemoApp extends StatelessWidget {
  const NavFormDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation & Forms Demo',
      // ----- NAMED ROUTES -----
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/form': (_) => const FormScreen(),
        '/simple': (_) => const SimpleScreen(),
        // '/data' is handled in onGenerateRoute so we can read arguments
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/data') {
          final arg = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (_) => DataPassScreen(initialText: arg ?? ''),
          );
        }
        return null; // unknown route ⇒ fall back to error
      },
    );
  }
}

/* ──────────────────────────── HOME ──────────────────────────── */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _returnedData; // will show value popped back from /data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('1️⃣ Open 5‑Field Form (no data back)'),
              onPressed: () => Navigator.pushNamed(context, '/form'),
            ),
            ElevatedButton(
              child: const Text('2️⃣ Push simple page (no data both ways)'),
              onPressed: () => Navigator.pushNamed(context, '/simple'),
            ),
            ElevatedButton(
              child: const Text('3️⃣ Push page & get TWO values back'),
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(
                          context,
                          '/data',
                          arguments: 'Hello from Home 👋',
                        )
                        as Map<String, dynamic>?; // <-- cast to Map
                if (result != null) {
                  setState(() {
                    _returnedData =
                        'text = "${result['text']}", rating = ${result['rating']}';
                  });
                }
              },
            ),

            const SizedBox(height: 32),
            Text(
              _returnedData == null
                  ? 'Returned data will appear here.'
                  : '🔄  Got back: $_returnedData',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/* ──────────────────────── SIMPLE SCREEN ─────────────────────── */
class SimpleScreen extends StatelessWidget {
  const SimpleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Page')),
      body: Center(
        child: ElevatedButton(
          child: const Text('←  Pop back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

/* ────────────────────────── FORM SCREEN ─────────────────────── */
class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _key = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _addrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5‑Field Form')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              _input(_nameCtrl, 'Name', (v) => v!.isEmpty ? 'Required' : null),
              _input(
                _emailCtrl,
                'Email',
                (v) => v!.contains('@') ? null : 'Invalid email',
              ),
              _input(
                _phoneCtrl,
                'Phone',
                (v) => v!.length < 8 ? 'Too short' : null,
                keyboard: TextInputType.phone,
              ),
              _input(
                _ageCtrl,
                'Age',
                (v) => int.tryParse(v!) == null ? 'Number only' : null,
                keyboard: TextInputType.number,
              ),
              _input(
                _addrCtrl,
                'Address',
                (v) => v!.isEmpty ? 'Required' : null,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Submit & Pop'),
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form valid!')),
                    );
                    Navigator.pop(context); // no data returned
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String label,
    FormFieldValidator<String?> val, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        validator: val,
      ),
    );
  }
}

/* ───────────────────── DATA‑PASSING SCREEN ───────────────────── */
class DataPassScreen extends StatefulWidget {
  final String initialText;
  const DataPassScreen({super.key, required this.initialText});

  @override
  State<DataPassScreen> createState() => _DataPassScreenState();
}

class _DataPassScreenState extends State<DataPassScreen> {
  late final TextEditingController _ctrl = TextEditingController(
    text: widget.initialText,
  );

  double _rating = 3; // 1‒5 star slider

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit & Return TWO values')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              decoration: const InputDecoration(labelText: 'Edit the text'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Rating'),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: _rating,
                    label: _rating.toStringAsFixed(1),
                    onChanged: (v) => setState(() => _rating = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('←  Pop & send back BOTH'),
              onPressed: () {
                Navigator.pop(context, {'text': _ctrl.text, 'rating': _rating});
              },
            ),
          ],
        ),
      ),
    );
  }
}
