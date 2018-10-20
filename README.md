# wakelock-source-hunter

This is a small script you can run on your **root**-ed Android phone to find out the source of **wakelocks.**

The main logic is to watch the **wakelock** happening and one-by-one disable the user installed apps and wait if the wakelock occurence drops. This way one can find the source of the **wakelocks.** One can do this manually but it is easyer to do this by a simple script.

The script does 30 second tests and counts the selected **wakelock** during that period. It first does 3 baseline checks with all apps enabled, then one-by-one disables then re enables the apps and prints the **wakelock** count during the test period.

## Usage

**Use this script at your own risk, I take no responsibility for any damages to your phone! Don't use it if you don't understand what is does!**

  * You must use [BetterBatteryStats](https://play.google.com/store/apps/details?id=com.asksven.betterbatterystats) to find out what **wakelock** bothers you
  * Backup/note down your app shortcuts on your launcher (if you disable an app it is removed from the launcher), or you can switch to an alternative launcher and then back this way your usual launcher's app shourtcuts will be preserved
  * Edit the script and set `WAKELOCK=` to your **wakelock** of choise
  * Start a shell on your phone (I recommend JuiceSSH for "local device" connection)
  * `su` to gain **root**
  * Start the srcipt by `bash wakelock-source-hunter.sh`
  * Interpret and do experiments by the results

**Note:** all environments are different, I can't guarantee they this will work in your. If you get an error message try another terminal emulator. (I use JuiceSSH.)

### Example

I was fighting with the `IPA_RM12` and `IPA_WS` **wakelock**. I've googled for a long time but the only info I was able to find out that it is the [Qualcomm Linux Modem's](https://osmocom.org/projects/quectel-modems/wiki/Qualcomm_Kernel#IPA-Internet-Packet-Accelerator) **wakelock**, so it has some connection with the mobile communication. So something is using the mobie net in the background constantly but not that hard that I can spot it by network usage. I know there would be other ways to find out the source of network traffic, for example by monitoring the network, but it would be more of a pain and this way I've built a more useful tool for future use. My phone was ok for hours but then somethign happened and those two **wakelocks** kept it awake around 50% screen off time, only reboot helped. So some app must stuck somehow and causes it.

```
~$ su
:/storage/emulated/0 # bash wakelock-source-hunter.sh
Parent app is com.sonelli.juicessh, will skip it during the tests.

I will count IPA_WS wakelocks during disabling apps one-by-one. But before I'll make some baseline with all apps enabled. Please wait...

        32 Baseline
         8 Baseline
        17 Baseline
         9 net.oneplus.weather
        28 com.alibaba.aliexpresshd
         9 com.google.android.apps.docs.editors.docs
        32 com.ichi2.anki
         0 com.otpmobil.simple
         0 com.niksoftware.snapseed
         0 com.oneplus.soundrecorder
         3 com.italki.app
         1 com.devhd.feedly^C
```

As you can see after disabling **com.otpmobil.simple** the **wakelocks** vanished, and after re enabling it didn't returned, so the app was doing some background job what stuck sometines and caused the wakelocks for me. I deleted it and my **wakelock** issue is done. As you can see not all the **wakelocks** wanished, buy since it is a mobile network related **wakelock** it's not a problem.

Please send success stories to: stone at midway dot hu
