# Reprogram Your Mind: 30-day goal tree website

A public website with the 3D goal tree. Anyone can create a free account with their name and email. Each person's power goal, six fruits and daily check-ins are saved privately to their own account.

**How it works for visitors:** a welcome pop-up explains the 3 setup steps. After signing up, people write their goal and fruits, then each day press "Start today's visualization" for a 2-minute guided session (timer, music, one fruit at a time). The first session each day grows their tree a day and turns a red root green. They can repeat the session as often as they like, and the site shows how many times they did it today. Missed days dim the tree until they check in again.

## What's in this folder

| File | What it does |
|---|---|
| `index.html` | The whole website: 3D tree, 30-day timeline, sign-in, saving |
| `config.js` | Where you paste your Supabase keys (the only file you need to edit) |
| `supabase/setup.sql` | Creates the database table and privacy rules (run once on a new project) |
| `supabase/update-checkins.sql` | Adds daily check-ins to a project set up before check-ins existed (run once) |
| `netlify.toml` | Hosting settings for Netlify |
| `vendor/` | The 3D and sign-in libraries, bundled so the site doesn't depend on outside servers |
| `music/` | The visualization track (trimmed to 2.5 minutes, 128 kbps) |

Until `config.js` has real keys, the site runs in **demo mode**: the tree works, but there's no sign-in and changes only save on that device.

---

## Step 1. Create the database (Supabase, free plan)

1. Go to supabase.com, sign up, and click **New project**. Pick a region near your users and save the database password somewhere safe.
2. Open **SQL Editor**, then **New query**. Paste everything from `supabase/setup.sql` and press **Run**. You should see "Success".
3. Open **Project Settings > API Keys**. Copy the **Project URL** and the **publishable key** (older projects call it the **anon** key).
4. Paste both into `config.js`.

The publishable key is safe on a public website because Row Level Security only lets each signed-in person read and change their own row. **Never** put the secret or `service_role` key in `config.js`.

## Step 2. Put the site online (Netlify, free plan)

**Recommended: connect GitHub so changes publish automatically**
1. Put this folder in a GitHub repository (Claude can do this for you once GitHub is connected to Claude).
2. In Netlify: **Add new project > Import an existing project > GitHub**, then pick the repository.
3. Leave the build command empty and press **Deploy**. `netlify.toml` already tells Netlify what to publish.
4. From then on, every change pushed to the repository goes live automatically in about a minute.

**Quick test instead:** go to app.netlify.com/drop and drag this whole folder onto the page. Create a Netlify account right away to keep the site, because unclaimed drops get deleted.

## Step 3. Tell Supabase your website address

In Supabase: **Authentication > URL Configuration**
- **Site URL:** your live address, for example `https://your-site.netlify.app` (or your own domain later)
- **Redirect URLs:** add the same address

This makes confirmation and password-reset emails link back to your site.

## Step 4. Turn on real emails before you go public (important)

Supabase's built-in email sender is for testing only. It only sends to members of your Supabase team and only a couple of emails an hour. So new sign-ups from the public won't get their confirmation email until you connect your own email sender.

1. Create a free account with an email service such as Resend or Brevo and verify your sending domain.
2. In Supabase: **Authentication > Emails > SMTP Settings**, turn on **custom SMTP** and paste the details from your email service.
3. If you expect a lot of sign-ups at once, raise the limits under **Authentication > Rate Limits**.

## Step 5 (optional). Google sign-in

1. In Supabase: **Authentication > Sign In / Providers > Google**. It shows a callback URL.
2. In Google Cloud Console, create an OAuth client (Web application) and add that callback URL as an authorized redirect URI.
3. Paste the Google Client ID and Secret into Supabase and turn Google on.
4. In `config.js`, set `GOOGLE_SIGN_IN: true`.

People who use Google don't need a confirmation email, so this also gets around the email limits.

## Step 6 (optional). Your own domain

In Netlify: **Domain management > Add a domain**. For a subdomain like `goals.yourdomain.com`, add the CNAME record Netlify shows you at your DNS provider. This doesn't affect your email. Netlify adds HTTPS automatically. Then update the Site URL in Step 3 to the new address.

---

## Step 7. Daily check-ins update (projects set up before November 20, 2026)

If you ran `setup.sql` before check-ins were added, run `supabase/update-checkins.sql` once in the SQL Editor. Until you do, the site works, but check-ins cannot be saved and the dock shows "Daily check-ins are almost ready".

## Making changes later

Open a chat with Claude (with GitHub connected) and describe the change, for example: "On the goal tree site, add a daily check-in button." Claude edits the files and pushes them to the repository, and Netlify republishes the site.

## Music

The 2-minute visualization plays "Deep Meditation" by AtlasAudio, from Pixabay, used under the Pixabay Content License. It plays as audio only, fades in when a session starts and fades out when the 2 minutes are done. There are no chimes. People can turn music on or off with the Music button, and their choice is remembered on their device.

To swap the track, replace `music/deep-meditation.mp3` with a new file of the same name, or ask Claude to do it. Use music you have the rights to put on a website (Pixabay tracks are fine). YouTube songs can't be used as hidden background audio.

## Privacy

- Each person's goal and fruits are stored with their account and protected by Row Level Security. Nobody else can read them through the website, other signed-in users included.
- People can delete their saved goal any time with **Delete my saved goal**.
- You, as the Supabase project owner, can see the table in your Supabase dashboard. Mention that in a short privacy note on your site if you collect sign-ups from the public.
