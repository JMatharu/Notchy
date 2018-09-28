Notchy
======

This is the full source code to Notchy, an iOS app that was a collaboration between [Ryan Jones](https://twitter.com/rjonesy), [Brad Ellis](https://twitter.com/bradellis), and [I](https://twitter.com/dwlz).

## Why Open Source

A few reasons:

1. The app doesn't make *that* much money, so it makes more sense to convert it to a community project.
2. I open source a lot of stuff, but I've never open sourced a complete iOS app. Seemed like a good opportunity to do that.

## This is awesome. How can I give you money?

The best way to contribute is to fork the code and make an improvement.

If you're dead-set on giving back, reach out to Ryan and I if you ever decide to visit Austin and buy us a coffee.

## Local Setup

1. Install the Ruby in `.ruby-version` and Bundler.

        rbenv install
        gem install bundler

2. Install gems:

        bundle install

3. Then install iOS dependencies from CocoaPods.

        pod install

3. Open `Notchy.xcworkspace` to compile and run the project.

License
-------

Notchy is licensed under the [GNU GPL version 3 or any later version](https://www.gnu.org/licenses/gpl-3.0.html), which is considered a strict open-source license.

In short: you can modify and distribute the source code to others (and even sell it!) as long as you make the source code modifications freely available.

If you would like to sell a modified version of the software (or any component thereof) and do *not* want to release the source code, you may contact me and you can purchase a [selling exception](https://www.gnu.org/philosophy/selling-exceptions), which is permissible under the GPL.
