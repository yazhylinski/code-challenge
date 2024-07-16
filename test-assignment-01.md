## Smashing Wallpaper Downloader


There is a website called Smashing Magazine, which uploads wallpapers for the desktop each month. It's not efficient to manually visit the site every month and check for new content, so let's automate this task. 


You are required to create a command-line interface (CLI) utility that will download all wallpapers in the requested resolution for the specified month and year to the user's current directory. The wallpapers are found [here](https://www.smashingmagazine.com/category/wallpapers), and the wallpapers for July 2023 can be found [here](https://www.smashingmagazine.com/2023/06/desktop-wallpaper-calendars-july-2023/).

### Conditions

- Ruby 2.7+
- Any external libraries can be used 
- Ruby Style Guide ([Shopify](https://ruby-style-guide.shopify.dev/))
- If time allows, you may write tests for the utility

The wallpaper download script should run with the following parameters:

./smashing.rb —month 022018 —resolution 640x480

### Features

* If a wallpaper is available in both calendar and non-calendar versions, the utility should download both.
* Not all wallpapers are available in all resolutions. If a particular wallpaper is not available in the requested resolution, the utility should skip it.

### Results

Should be posted to your personal Github account as a public repository.
