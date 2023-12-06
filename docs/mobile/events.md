# Semantic Conventions for mobile events

**Status**: [Experimental][DocumentStatus]

This document defines semantic conventions for instrumentations that emit
events on mobile platforms. All mobile events MUST use a namespace of
`device` in the `event.name` property.

<!-- toc -->

- [Lifecycle instrumentation](#lifecycle-instrumentation)
  * [iOS](#ios)
  * [Android](#android)

<!-- tocstop -->

## Lifecycle instrumentation

This section defines how to apply semantic conventions when instrumenting
application lifecycle. This event is meant to be used in conjunction with
`os.name` [resource semantic convention](/docs/resource/os.md) to identify the
mobile operating system (e.g. Android, iOS).

### iOS

<!-- semconv ios.lifecycle.events -->
The event name MUST be `device.app.lifecycle`.

| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `ios.state` | string | This attribute represents the state the application has transitioned into at the occurrence of the event. [1] | `active` | Required |

**[1]:** The iOS lifecycle states are defined in the [UIApplicationDelegate documentation](https://developer.apple.com/documentation/uikit/uiapplicationdelegate#1656902), and from which the `OS terminology` column values are derived.

`ios.state` MUST be one of the following:

| Value  | Description |
|---|---|
| `active` | The app has become `active`. Associated with UIKit notification `applicationDidBecomeActive`. |
| `inactive` | The app is now `inactive`. Associated with UIKit notification `applicationWillResignActive`. |
| `background` | The app is now in the background. This value is associated with UIKit notification `applicationDidEnterBackground`. |
| `foreground` | The app is now in the foreground. This value is associated with UIKit notification `applicationWillEnterForeground`. |
| `terminate` | The app is about to terminate. Associated with UIKit notification `applicationWillTerminate`. |
<!-- endsemconv -->

### Android

<!-- semconv android.lifecycle.events -->
The event name MUST be `device.app.lifecycle`.

| Attribute  | Type | Description  | Examples  | Requirement Level |
|---|---|---|---|---|
| `android.state` | string | This attribute represents the state the application has transitioned into at the occurrence of the event. [1] | `created` | Required |

**[1]:** The Android lifecycle states are defined in [Activity lifecycle callbacks](https://developer.android.com/guide/components/activities/activity-lifecycle#lc), and from which the `OS identifiers` are derived.

`android.state` MUST be one of the following:

| Value  | Description |
|---|---|
| `created` | Any time before Activity.onResume() or, if the app has no Activity, Context.startService() has been called in the app for the first time. |
| `background` | Any time after Activity.onPause() or, if the app has no Activity, Context.stopService() has been called when the app was in the foreground state. |
| `foreground` | Any time after Activity.onResume() or, if the app has no Activity, Context.startService() has been called when the app was in either the created or background states. |
<!-- endsemconv -->

## Android ANR

When a client app is not responsive, instrumentation can emit an ANR event. This is an important
event because it helps developers know when their application is having user-facing performance 
problems. An periodic application-level watchdog is sometimes used to implement the ANR detector. 

`event.name`: `otel.client.anr`

Event payload:

| Field         | Type     | Description                                                            |
|---------------|----------|------------------------------------------------------------------------|
| `threshold`   | double   | Number of unresponsive seconds before the ANR was detected.            | 
| `stacktrace`  | String   | The stack trace of the main thread at the time the ANR was detected.   |

## Slow Renders / UI Jank

When a user perceives screen flicker due to frame rendering being blocked or delayed, this is called 
[_jank_](https://developer.android.com/studio/profile/jank-detection).
Detecting and reporting jank is an important feature for mobile instrumentation, because it helps 
developers streamline their code and improve the user experience.

The following event is defined for detecting and reporting jank:

`event.name`: `otel.screen.slow-renders-detected`

This event indicates that the mobile device detected slow screen renders.

Event payload: 

| Field  | Type   | Description |
|--------|--------|-------------|
| `slow-count`   | long   | The number of renders that took longer than the slow threshold but shorter than the frozen threshold (tbd defined elsewhere). |
| `frozen-count` | long   | The number of renders that took longer than the frozen threshold. |
| `activity`     | String | The name of the activity that was present when the detection occurred. This may not necessarily be the same activity that was active during the slow rendering interval. |


[DocumentStatus]: https://github.com/open-telemetry/opentelemetry-specification/tree/v1.22.0/specification/document-status.md
