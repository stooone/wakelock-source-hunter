# wakelock-source-hunter

This is a small script you can run on your **root**-ed Android phone to find out the source of **wakelocks.**

The main logic is to watch the **wakelock** happening and one-by-one disable the user installed apps and wait if the wakelock occurence drops. This way one can find the source of the **wakelocks.** One can do this manually but it is easyer to do this by a simple script.

The script does 30 second tests and counts the selected **wakelock** during that period. It first does 3 baseline checks with all apps enabled, then one-by-one disables then re enables the apps and prints the **wakelock** count during the test period.

## Usage

  * You must use [BetterBatteryStats](https://play.google.com/store/apps/details?id=com.asksven.betterbatterystats) to find out what **wakelock** bothers you
  * Backup/note down your app shortcuts on your launcher (if you disable an app it is removed from the launcher), or you can switch to an alternative launcher and then back this way your usual launcher's app shourtcuts will be preserved
  * Edit the script and set `WAKELOCK=` to your **wakelock** of choise
  * In a **root** terminal prepare the app list with the command: `pm list packages -3 -e > packages.txt`
  * Remove those apps from the `packages.txt` that you don't want to test, at least the terminal you are using!
  * Start the srcipt by `bash wakelock-source-hunter.sh`
  * Interpret and do experiments by the results
  
### Example

I was fighting with the `IPA_RM12` and `IPA_WS` **wakelock**. I've googled for a long time but the only info I was able to find out that it is the [Qualcomm Linux Modem's](https://osmocom.org/projects/quectel-modems/wiki/Qualcomm_Kernel#IPA-Internet-Packet-Accelerator) **wakelock**, so it has some connection with the mobile communication. So something is using the mobie net in the background constantly but not that hard that I can spot it by network usage. I know there would be other ways to find out the source of network traffic, for example by monitoring the network, but it would be more of a pain and this way I've built a more useful tool for future use. My phone was ok for hours but then somethign happened and those two **wakelocks** kept it awake around 50% screen off time, only reboot helped. So some app must stuck somehow and causes it.

```
:/storage/emulated/0 # bash wakelock-source-hunter.sh
baseline 32
baseline 8
baseline 17
net.oneplus.weather 9
com.alibaba.aliexpresshd 28
com.google.android.apps.docs.editors.docs 9
com.ichi2.anki 32
com.otpmobil.simple 0
com.niksoftware.snapseed 0
com.oneplus.soundrecorder 0
com.italki.app 3
com.devhd.feedly 1^C
```

As you can see after disabling **com.otpmobil.simple** the **wakelocks** vanished, and after re enabling it didn't returned, so the app was doing some background job what stuck sometines and caused the wakelocks for me. I deleted it and my **wakelock** issue is done. As you can see not all the **wakelocks** wanished, buy since it is a mobile network related **wakelock** it's not a problem.
