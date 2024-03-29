import 'package:flutter/material.dart';

class AddTeamMembersPage extends StatefulWidget {
  const AddTeamMembersPage({Key? key}) : super(key: key);

  @override
  State<AddTeamMembersPage> createState() => _AddTeamMembersPageState();
}

class _AddTeamMembersPageState extends State<AddTeamMembersPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _emailAddresses = [];

  final TextEditingController _emailController = TextEditingController();
  late String _teamName;

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context)!.settings.arguments as String;
    _teamName = args;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team Members'),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.grey[600],
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: validateEmailAddressList,
        child: const Icon(Icons.arrow_forward),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _emailAddresses.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_emailAddresses[index], animation);
        },
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Email Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _addEmailAddress(_emailController.text);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addEmailAddress(String emailAddress) {
    if (emailAddress.isNotEmpty) {
      _emailAddresses.insert(0, emailAddress);
      _listKey.currentState
          ?.insertItem(0, duration: const Duration(milliseconds: 300));
      _emailController.clear();
    }
  }

  void _removeEmailAddress(int index, bool isSlideDismissed) {
    final removedItem = _emailAddresses[index];

    _emailAddresses.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
      duration: Duration(milliseconds: isSlideDismissed ? 0 : 300),
    );
  }

  Widget _buildItem(String emailAddress, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          _removeEmailAddress(_emailAddresses.indexOf(emailAddress), true);
        },
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              Spacer(),
              Icon(Icons.delete, color: Colors.white)
            ],
          ),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
              title: Text(emailAddress),
              trailing: IconButton(
                onPressed: () {
                  _removeEmailAddress(
                      _emailAddresses.indexOf(emailAddress), false);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[600],
                ),
              )),
        ),
      ),
    );
  }

  void validateEmailAddressList() {
    if (_emailAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one email address'),
        ),
      );
    } else {
      Navigator.pushNamed(context, '/admin_payment',
          arguments: {'emailAddresses': _emailAddresses, 'teamName': _teamName});
    }
  }
}
