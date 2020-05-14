# Gentle Admin Dashboard

This is the [create-react-app](https://reactjs.org/docs/create-a-new-react-app.html)-based admin dashboard for Gentle. This was used to monitor some metrics and handle moderation.

> ⚠️ This is frankly the least cared-for part of the Gentle codebase. It was made as quickly as possible and isn't very powerful.

## Folder structure

```
.
├── public               # Static assets (unchanged from create-react-app's base)
└── src                  # React components and related code
```

## To run

```
yarn
yarn start
```

I ran this locally on my machine only.

## Removed code

Some code was removed, including:

- Admin login email/password (horrible security practice!)
- Various links
