# Workflowy client for macOS

## Background

This is a small project I created in order to have a standalone Workflowy app a
few years ago (end of 2015, beginning of 2016). Back then I was using Workflowy
daily, and I felt like having a dedicated app instead of a tab in the browser
made it more accessible for me, and Workflowy was only available as a web app,
without any official client for macOS or any other OS.

So, I created this small app just in order to solve my needs.

## Details

The app was built in Objective-C (Swift was in its infancy, and not widely
supported). It has the following features:

- built on top of Safari WebView (a.k.a. macOS native WebView). This makes the
  app ligthweigh, and quit to start (no bulky Electron app). This was enough.
- Shortcut preference to bring Workflowy app to the front.
- Option to open multiple windows, to have different focused views.

No more, no less.

## App store

I tried to submit the app to macOS App Store but it was rejected because "it
was a simple WebView". Well, a bit more than that, plus after more search I
found an app in the App Store which was this... in a OS status bar menu.

So far so good. I was not planning on making money on that and didn't spend
time to get it published.

## Fading out

A few years after Workflowy released its own app... based on Electron. By the
time this happened I had switched to other tools because Workflowy didn't have
reminders, which was something I was used to have back then.

## Today

Today I found the repo lying around in my disk. Although I didn't publish the
source, I had it tracked in a Git repo. So I decided it may be useful to
release (at least for myself, to have a historical record of it).

So it is being published using MIT license, do whatever you want with it.

