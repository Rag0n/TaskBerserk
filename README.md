# TaskBerserk

TaskBerserk is a [TaskWarrior][tw] client for iOS. App uses [Inthe.am][intheam] RESTful API for syncing with TaskWarrior.

Feel free to create issues, especially enhancement.

# Current state
Currently app is in early development stage. Current [development][develop-branch] version v0.1.0 contains next improvements:

- Basic functionality
    - [x] Add tasks
    - [x] Remove tasks
    - [ ] Edit tasks
        - [x] Change task's names
        - [ ] Change task's project
        - [ ] Change task's tags
        - [ ] Change task's priority
- [ ] Basic gestures
    - [ ] Done taskg
    - [ ] Delete task
- [x] Fetching task via Intheam
- [x] Local storage(CoreData)
- [ ] Additional functionality
    - [x] View all projects
    - [ ] View all tags
    - [ ] View project's tasks
    - [ ] View tag's tasks


# Roadmap

* v0.1.0 Basic functionality + fetching via Intheam
* v0.2.0 Syncing via Intheam
* v0.3.0 Better compatibility support(depends on tasks, sub projects) + gestures
* v0.4.0 Filters + searching
* v0.5.0 UI
* v0.6.0 Calendar + notifications
* v0.7.0 Reports/charts

# Installation
For now the only way to install app is to download and build it from a [release page][releases] or clone from current [development branch][develop-branch]. You should also add an AppKey.plist file to project with your Inthe.am API key:

```xml
<dict>
	<key>Intheam</key>
	<string>Your API Key</string>
</dict>
```

# Changes
###### v0.0.5:
Prototype with support of syncing task via [Inthe.am][intheam] API. App parses JSON into tasks and projects.

# Licence
TaskBerserk is released under MIT license. For details, see [LICENSE][license].


[intheam]: https://inthe.am/about
[tw]: http://taskwarrior.org/
[releases]: https://github.com/Rag0n/TaskBerserk/releases
[license]: LICENSE.md
[version-0.0.5]: https://github.com/Rag0n/TaskBerserk/releases/tag/v0.0.5
[develop-branch]: https://github.com/Rag0n/TaskBerserk/tree/develop
