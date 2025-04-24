# Project 3 - *BeReal Clone Pt. 2*

Submitted by: **Courtney Mahugu**

**BeReal Clone Pt. 2** is an app that allows users to take and view daily photos similar to the BeReal app. 

Time spent: **2** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] User can launch camera to take photo instead of photo library
  - [x] Users without iPhones to demo this feature can manually add unique photos to their simulator's Photos app
- [ ] Users are not able to see other users’ photos until they upload their own.
- [x] Users can intereact with posts via comments, comments will have user data such as username and name
- [x] Posts have a time and location attached to them
- [ ] Users are not able to see other photos until they post their own (within 24 hours)	
 
The following **optional** features are implemented:

- [x] User receive notifcation when it is time to post

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough

Here is a reminder on how to embed Loom videos on GitHub. Feel free to remove this reminder once you upload your README. 

[Guide]](https://www.youtube.com/watch?v=GA92eKlYio4) .

## Notes

Describe any challenges encountered while building the app.
- `ParseObject` relationship queries with `.pointer(to:)` syntax took time to debug
- App crashed initially because of missing Info.plist keys
- Getting location metadata to sync with the post required wrapping `post.save` inside the geocoder completion handler

## License

    Copyright [2025] [Courtney Mahugu]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
