# optune-messaging

In app messaging front- and backend.

Users can send each other messages inside of the app, independent of the booking negotiation system. This component is use case independent and is a candidate to open source.

Furthermore, this component enables delegated messaging. I.e. a booker can write to an artist (which is a managed object and not a user) and every agent of this particular artist can see the message, clearly indicated as delegated message (not to be mixed up with private messages) and respond.

Receiving of an in app message triggers an email to all recipients. This email notifications can be turned off.

# Frontend
* Each user profile has a message button
* There is a central messaging component
* Unread messages are indicated
* Direct Messages and threads about managed objects (Artists) are clearly distinguishable.

# Backend
* A messaging data model which supports the requirements (direct messages, threads about managed objects)
* Sending emails if mail notifications are enabled
* _Bonus_: Direct reply via email

# Requirements
* see package.json for required packages
* User model with '_id' and 'name'
