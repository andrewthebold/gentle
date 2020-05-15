# Gentle

![Gentle Work in Progress Banner](https://user-images.githubusercontent.com/10323195/81870666-30052f80-952b-11ea-83fd-e00abde068a7.png)

👋 Heyo! [**Gentle**](https://gentle.app/) is a mobile app where you write requests for kindness and reply to others. It's cute, anonymous, and moderated. It was my ([Andrew Lee](https://andrewlee.design/)'s) solo project for three months in early 2020.

The app [shutdown in May 2020](https://gentle.app/shutdown), and I decided to release _everything_. All code is available under an MIT license. You are welcome to fork it, remix it, take its parts, etc.

## Links

- 📃 [Read about the app's shutdown](https://gentle.app/shutdown)
- 💬 [Read my retro article](https://andrewlee.design/blog/designing-gentle) (includes metrics, motivation, design principles, and more stuff that would be useful to know)
- 🎨 [View the master Figma file for Gentle](https://www.figma.com/community/file/842929427415891293/)
- 🛣 [View the Trello board roadmap for Gentle](https://trello.com/b/65BxuxBa/gentle-roadmap) (you can get a sense for where Gentle was going and which features I wanted for the official launch)

## Folder Structure

```
.
├── admin-dashboard            # Basic moderation dashboard
├── firebase                   # All "server" code for Gentle — Firestore rules, indexes, and cloud functions
├── flutter-app                # The mobile app code (created in Flutter)
└── landing-page               # The Next.js site hosted on gentle.app
```

Each folder has its own `README` with relevant information.

## About _Gentle_'s Brand

While Gentle's design and code are now publicly available, I am unlikely to transfer the [gentle.app](https://gentle.app/) domain name or endorse any product based on this work.

You are welcome to reuse any of this code (please follow the LICENSE), but I recommend you choose a different product name to differentiate yourself. Not a requirement by any means, but it's probably a good move to set expectations of new ownership.

## Need help?

I am no longer actively supporting Gentle. Helping people interested in using this work is not my priority.

You are welcome to reach me at [hi@andrewlee.design](mailto:hi@andrewlee.design), but I may be slow to respond and/or decline your request.

---

_Wishing you good times ✨_
