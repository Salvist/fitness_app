# fitness_app

Echofi Takehome Project

### Task 1:
Your first task is to create a simple home page containing the following elements:

- Start / Stop button

Finished: There is a Start / Stop in 1 button. When the Start button is pressed, it will start the stopwatch and animate to pause button. When the pause button is pressed, it will stop the stopwatch and animate back to Start button.

- Visual display of elapsed time

Finished: There is a display of time in mm:ss.milliseconds / minutes:seconds.milliseconds.



### Task 2:
In the second task we will take the stopwatch and add some new features:

- A 'lap' button that is active while the timer is active

Finished: There is a flag button that when clicked, it will populate the lap time and split time. In addition, there is a reset button (middle) to clear the lap lists.

Note: Lap button is only active when the stopwatch is running.

- A scrollable list of lap times

Finished: There are 2 lists, lap time and split time. Lap time is a timer in that particular lap while split time is an accumulation of time through all laps.

### Task 3:
In the third (and final) task we will make some quality of life improvements to the app:

- Keep the stopwatch running while the app is in the background

Finished: The stopwatch is still running while in the background as well as if focus is in other app.

- Keep the stopwatch running while the app is killed and re-opened

Roughly Finished: The stopwatch is still running while the app is killed (or closed) using the back button. Using WillPopScope widget, the time when the app is closed is saved using shared preferences package. When the app is opened again, it will use the saved time and the time when the app is opened to regain the stopwatch time. This does not work if the app is force killed (not using the back button).

- Keep the list of laps after the app is killed and re-opened

Finished: The lists of lap is saved using shared preferences and persist when the app is re-opened.

## How the tests are done
It is done using my android phone in portrait mode. The UI might be messed up when turned into landscape as adaptive layout is not implemented.
This has not been tested in iOS so I do not know if it will work in iOS or not. My laptop barely able to run emulator so I cannot try iOS emulator.
