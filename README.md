# Project 4 - *Mockagram*

**Mockagram** is a photo sharing app using Parse as its backend.

Time spent: **26** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
- [x] Allow the logged in user to add a profile photo
- [x] Display the profile photo with each post
- [x] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How can I implement a comment section at the bottom of the phone screen that will push up and stay above the keyboard when I click on it? I worked around this by putting my caption section at the top of the phone so it won't be covered, but most apps have their comment section below a post and still allow a user to see what they're typing.
2. What changes would have to be made in order to make a User subclass of PFUser the same way we did with Post and PFObject? 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/XwkUgMIcGf.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Recordit](http://recordit.co).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Describe any challenges encountered while building the app.

The biggest challenge was keeping track of all the view controllers and segues and making sure that they didn't get tangled up in each other. For example, a table view cell like a post in the feed view controllers had multiple segues to different controllers (detail view vs other user profile), and it was important to load the navigation controller rather than a view controller directly in order to have the bar at the bottom. 

## License

Copyright 2019 Julia Park

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
